//
//  YZLiveRoomViewController.m
//  BroadCast
//
//  Created by Yong Zeng on 12/3/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZLiveRoomViewController.h"
#import <videoprp/AgoraYuvEnhancerObjc.h>
#import "VideoSession.h"
#import "VideoViewLayouter.h"
#import "KeyCenter.h"
#import "YZLiveHeaderView.h"
#import "YZLiveBottomToolView.h"
#import "UIViewController+utils.h"
#import "YZUserInfoView.h"
#import "YZChatRoomMessage.h"
#import "TTTAttributedLabel.h"
#import "AttributedTableViewCell.h"
#import "YZFirebaseNetUtils.h"
@import Firebase;

#define USERNAMEFONT 16
#define INPUTTEXTVIEWHEIGHT 44

@interface YZLiveRoomViewController () <AgoraRtcEngineDelegate, UITextFieldDelegate,
UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIView *remoteContainerView;
@property (strong, nonatomic) UIView *transparentView;
@property (strong, nonatomic) YZLiveHeaderView *liveHeaderView;
@property (nonatomic, assign) BOOL isFollowed;
@property (strong, nonatomic) YZLiveBottomToolView *bottomToolView;
@property (strong, nonatomic) UIView *bottomTextView;

@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UITextField *messageTextField;
@property (strong, nonatomic) UITableView *chatTableView;

@property (strong, nonatomic) AgoraRtcEngineKit *rtcEngine;
@property (strong, nonatomic) AgoraYuvEnhancerObjc *agoraEnhancer;
@property (assign, nonatomic) BOOL isBroadcaster;
@property (assign, nonatomic) BOOL isMuted;
@property (strong, nonatomic) NSMutableArray<VideoSession *> *videoSessions;
@property (strong, nonatomic) VideoSession *fullSession;
@property (strong, nonatomic) VideoViewLayouter *viewLayouter;

@property (strong, nonatomic) NSString *roomName;
@property(strong, nonatomic) FIRDatabaseReference *databaseRef;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (strong, nonatomic) NSDictionary *broadcastItem;

@property (strong, nonatomic) NSMutableArray *chatMessages;
@end

@implementation YZLiveRoomViewController

- (BOOL)isBroadcaster {
    return self.clientRole == AgoraRtc_ClientRole_Broadcaster;
}

- (VideoViewLayouter *)viewLayouter {
    if (!_viewLayouter) {
        _viewLayouter = [[VideoViewLayouter alloc] init];
    }
    return _viewLayouter;
}

- (void)setClientRole:(AgoraRtcClientRole)clientRole {
    _clientRole = clientRole;
}

- (void)setVideoSessions:(NSMutableArray<VideoSession *> *)videoSessions {
    _videoSessions = videoSessions;
    if (self.remoteContainerView) {
        [self updateInterfaceWithAnimation:YES];
    }
}

- (void)setFullSession:(VideoSession *)fullSession {
    _fullSession = fullSession;
    if (self.remoteContainerView) {
        [self updateInterfaceWithAnimation:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.videoSessions = [[NSMutableArray alloc] init];
    
    self.databaseRef = [[FIRDatabase database] reference];
    self.storageRef = [[FIRStorage storage] reference];
    // Init Views
    [self initViews];
    
    // set input string as room name
    // self.roomNameLabel.text = self.roomName;
    
    [self loadAgoraKit];
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadOnLineNumber];
    [self loadChatMessages];
}

- (void)loadOnLineNumber{
    [[[_databaseRef child:@"broadcasts"] child:_broadcast.broadcastId] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [self.liveHeaderView changeOnlineNumber:snapshot.value[@"onlineNumber"]];
        [self.broadcast setOnlineNumber:snapshot.value[@"onlineNumber"]];
    }];
}

- (void)loadChatMessages{
    _chatMessages = [NSMutableArray array];
    FIRDatabaseReference *messagesRef = [[[self.databaseRef child:@"liveroom_chatchannels"] child:self.broadcast.broadcastId] child:@"messages"];
    FIRDatabaseQuery *query = [messagesRef queryLimitedToLast:25];
    [query observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *uid = snapshot.value[@"uid"];
        NSString *message = snapshot.value[@"message"];
        
        User *user = [[User alloc] init];
        [[[self.databaseRef child:@"users"] child:uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            user.uid = uid;
            user.email = snapshot.value[@"email"];
            user.location = snapshot.value[@"location"];
            user.username = snapshot.value[@"username"];
            [[[_databaseRef child:@"user_follow"] child:snapshot.key] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                user.followNumber = [NSNumber numberWithInteger:snapshot.children.allObjects.count];
            }];
            
            [[[_databaseRef child:@"user_follower"] child:snapshot.key] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                user.followerNumber = [NSNumber numberWithInteger:snapshot.children.allObjects.count];
            }];
            
            [[[self.databaseRef child:@"user-broadcasts"] child:uid ] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                user.broadcastNumber = [NSNumber numberWithInteger:snapshot.children.allObjects.count];
            }];
            YZChatRoomMessage *chatRoomMessage = [[YZChatRoomMessage alloc] initWithMessage:message user:user];
            [self.chatMessages addObject:chatRoomMessage];
            [self.chatTableView reloadData];
            
            NSString *profileImagePath = snapshot.value[@"profileImagePath"];
            if (![profileImagePath isEqualToString:@""]) {
                [[_storageRef child:profileImagePath] dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData * _Nullable data, NSError * _Nullable error) {
                    if (error) {
                        YZLog(@"get profile image error---,%@", error.localizedDescription);
                        return;
                    }
                    user.profileImage = [UIImage imageWithData:data];
                    [self.chatTableView reloadData];
                }];
            }
        }];
        
    }];
}

- (void) initViews{
    // Init remoteContainerView
    UIView *remoteContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:remoteContainerView];
    _remoteContainerView = remoteContainerView;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTapped:)];
    tapGesture.numberOfTapsRequired = 2;
    [remoteContainerView addGestureRecognizer:tapGesture];
    
    
    UIView *transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KDeviceWidth, KDeviceHeight+44)];
    [self.view addSubview:transparentView];
    _transparentView = transparentView;
    transparentView.backgroundColor = [UIColor clearColor];
    
    [self initLiveHeaderView];
    [self initBottomToolView];
    [self initBottomTextView];
    [self initChatTableView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.transparentView endEditing:true];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.transparentView endEditing:true];
}

- (void) initLiveHeaderView{
    YZLiveHeaderView *liveHeaderView = [[YZLiveHeaderView alloc] initWithFrame:CGRectMake(0, 20, KDeviceWidth, 40)];
    [self.view addSubview:liveHeaderView];
    _liveHeaderView = liveHeaderView;
    __weak typeof(self) weakSelf = self;
    [self.liveHeaderView setClickProfileImageBlock:^{
        YZLog(@"click header view...");
        YZUserInfoView *userInfoView = [[YZUserInfoView alloc] initWithFrame:CGRectMake(0, 0, KDeviceWidth, KDeviceHeight)];
        [userInfoView showInView:weakSelf.view withUser:weakSelf.broadcast.user withCurrentUID:[User sharedInstance].uid animated:YES];
    }];
//    [self.liveHeaderView setClickFollowButtonBlock:^(NSString *uid) {
//        YZLog(@"click follow button view...");
//        //[weakSelf doFollowOperationWithUID:uid];
//    }];
}

- (void) initBottomToolView{
    YZLiveBottomToolView *bottomToolView = [[YZLiveBottomToolView alloc] initWithFrame:CGRectMake(0, KDeviceHeight - BOTTOMTOOL_BUTTON_SIZE, KDeviceWidth, BOTTOMTOOL_BUTTON_SIZE)];
    if (!self.isBroadcaster) {
        [bottomToolView hideBroadCasterButton];
    }
    [self.view addSubview:bottomToolView];
    
    [bottomToolView setClickBottomToolBlock:^(UIButton *sender) {
        switch (sender.tag) {
            case YZLiveBottomToolTypeMessage:
                [self doMessagePressed];
                break;
            case YZLiveBottomToolTypeOverTurn:
                [self doSwitchCameraPressed];
                break;
            case YZLiveBottomToolTypeMute:
                [self doMutePressed:sender];
                break;
            case YZLiveBottomToolTypeClose:
                [self doLeavePressed];
                break;
            default:
                break;
        }
    }];
    
    _bottomToolView = bottomToolView;
}

- (void) initBottomTextView{
    UIView *bottomTextView = [[UIView alloc] initWithFrame:CGRectMake(0, KDeviceHeight, KDeviceWidth, INPUTTEXTVIEWHEIGHT)];
    [self.transparentView addSubview:bottomTextView];
    _bottomTextView = bottomTextView;
    UIImageView *bottomViewBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                              KDeviceWidth, INPUTTEXTVIEWHEIGHT)];
    [bottomViewBG setImage:[UIImage imageNamed:@"chat_bottom_bg"]];
    [bottomTextView addSubview:bottomViewBG];
    
    UITextField *messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 6, KDeviceWidth - 44 - 3*10, 32)];
    messageTextField.backgroundColor = [UIColor whiteColor];
    [bottomTextView addSubview:messageTextField];
    _messageTextField = messageTextField;
    messageTextField.enablesReturnKeyAutomatically = YES;
    messageTextField.returnKeyType = UIReturnKeySend;
    messageTextField.layer.cornerRadius = 6;
    messageTextField.layer.masksToBounds=YES;
    messageTextField.leftView = [[UIView alloc]
                          initWithFrame:CGRectMake(0, 0, 6, 32)];
    messageTextField.leftViewMode = UITextFieldViewModeAlways;
    messageTextField.delegate = self;
    
    // Keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(KDeviceWidth - 54, 6, 44, 32)];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [bottomTextView addSubview:sendButton];
    
    //YZLog(@"%f, %f", self.transparentView.bounds.size.height, self.transparentView.frame.size.height);
}

- (void)initChatTableView{
    _chatMessages = [NSMutableArray array];
    
    UITableView *chatTableView = [[UITableView alloc] init];
    CGFloat chatTableViewWidth = KDeviceWidth - 60;
    CGFloat chatTableViewHeight = 150;
    chatTableView.frame = CGRectMake(0, KDeviceHeight - chatTableViewHeight - BOTTOMTOOL_BUTTON_SIZE,
                                     chatTableViewWidth, chatTableViewHeight);
    _chatTableView = chatTableView;
    //[self.transparentView addSubview:chatTableView];
    [self.transparentView insertSubview:chatTableView belowSubview:self.transparentView];
    chatTableView.dataSource = self;
    chatTableView.delegate = self;
    chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //chatTableView.allowsSelection = NO;
    chatTableView.backgroundColor = [UIColor clearColor];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    YZLog(@"%f, %f", self.bottomTextView.frame.origin.x, self.bottomTextView.frame.origin.y);
    CGFloat duration = [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect frame = [notification.userInfo[@ "UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat offsetY, offsetYofTableView;
    if (frame.origin.y == KDeviceHeight) {
        offsetY = frame.origin.y - self.view.frame.size.height;
        offsetYofTableView = 0;
    } else {
        offsetY = frame.origin.y - self.transparentView.frame.size.height;
        offsetYofTableView = INPUTTEXTVIEWHEIGHT;
    }
    [UIView animateWithDuration:duration animations:^{
        self.transparentView.transform = CGAffineTransformMakeTranslation(0, offsetY);
        self.chatTableView.transform = CGAffineTransformMakeTranslation(0, offsetYofTableView);
    }];
}

- (void)doMessagePressed{
    [_messageTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMessage];
    return YES;
}

- (void)sendMessage{
    NSString *uid = [FIRAuth auth].currentUser.uid;
    NSString *message = _messageTextField.text;
    NSNumber *timestamp = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    NSDictionary *messageItem = @{@"uid": uid,
                                  @"message": message,
                                  @"timestamp": timestamp};
    FIRDatabaseReference *messagesRef = [[[self.databaseRef child:@"liveroom_chatchannels"] child:self.broadcast.broadcastId] child:@"messages"];
    FIRDatabaseReference *messageItemRef = [messagesRef childByAutoId];
    [messageItemRef setValue:messageItem];
    _messageTextField.text = @"";     //Clear textfield data
}

- (void)doSwitchCameraPressed{
    [self.rtcEngine switchCamera];
}

- (void)doMutePressed:(UIButton *)sender{
    //self.isMuted = !self.isMuted;
    _isMuted = !_isMuted;
    [self.rtcEngine muteLocalAudioStream:_isMuted];
    [sender setImage:[UIImage imageNamed:(self.isMuted ? @"btn_mute_cancel" : @"btn_mute")]
            forState:UIControlStateNormal];
}

- (void)doLeavePressed{
    [self leaveChannel];
}

// Set user role: audience or broadcaster
- (void)doBroadcastPressed:(UIButton *)sender {
    if (self.isBroadcaster) {
        self.clientRole = AgoraRtc_ClientRole_Audience;
    } else {
        self.clientRole = AgoraRtc_ClientRole_Broadcaster;
    }
    
    // set client role: broadcaster or audience
    [self.rtcEngine setClientRole:self.clientRole withKey:nil];
    [self updateInterfaceWithAnimation:YES];
}

- (void)doDoubleTapped:(UITapGestureRecognizer *)sender {
    if (!self.fullSession) {
        VideoSession *tappedSession = [self.viewLayouter responseSessionOfGesture:sender
                                                                       inSessions:self.videoSessions
                                                                  inContainerView:self.remoteContainerView];
        if (tappedSession) {
            self.fullSession = tappedSession;
        }
    } else {
        self.fullSession = nil;
    }
}


- (void)dealloc{
    YZLog(@"delloc...");
}

- (void)viewWillDisappear:(BOOL)animated{
    YZLog(@"viewwilldisappear...");
    // unregister for keyboard notifications while moving to the other screen.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
}



- (void)leaveChannel {
    [self setIdleTimerActive:YES];
    
    [self.rtcEngine setupLocalVideo:nil];
    [self.rtcEngine leaveChannel:nil];
    if (self.isBroadcaster) {
        [self.rtcEngine stopPreview];
    }
    
    for (VideoSession *session in self.videoSessions) {
        [session.hostingView removeFromSuperview];
    }
    [self.videoSessions removeAllObjects];
    
    [self.agoraEnhancer turnOff];
    
    if (self.isBroadcaster) {
        NSString *uid = [FIRAuth auth].currentUser.uid;
        NSString *userName = [User sharedInstance].username;
        NSString *title = self.broadcastTitle;
        NSString *roomName = self.roomName;
        
        _broadcast.isLive = NO;
        
        NSDictionary *broadcastItem = @{@"uid": uid,
                                        @"broadcasterName": userName,
                                        @"broadcastTitle": title,
                                        @"roomName": roomName,
                                        @"isLive": [NSNumber numberWithBool:NO],
                                        @"onlineNumber": _broadcast.onlineNumber};
        NSDictionary *childUpdates = @{[@"/broadcasts/" stringByAppendingString:_broadcast.broadcastId]: broadcastItem,
                                       [NSString stringWithFormat:@"/user-broadcasts/%@/%@/", uid, _broadcast.broadcastId]: broadcastItem};
        [_databaseRef updateChildValues:childUpdates];
        if ([self.delegate respondsToSelector:@selector(liveVCNeedClose:)]) {
            [self.delegate liveVCNeedClose:self];
        }
    } else {
        FIRDatabaseReference *ref = [[self.databaseRef child:@"broadcasts"] child:_broadcast.broadcastId];
        [self changeOnlineNumber:ref isIncrease:NO];
        
        FIRDatabaseReference *ref1 = [[[self.databaseRef child:@"user-broadcasts"]
                                       child:_broadcast.user.uid] child:_broadcast.broadcastId];
        [self changeOnlineNumber:ref1 isIncrease:NO];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setIdleTimerActive:(BOOL)active {
    [UIApplication sharedApplication].idleTimerDisabled = !active;
}

- (void)updateInterfaceWithAnimation:(BOOL)animation {
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self updateInterface];
            [self.view layoutIfNeeded];
        }];
    } else {
        [self updateInterface];
    }
}

- (void)updateInterface {
    NSArray *displaySessions;
    if (!self.isBroadcaster && self.videoSessions.count) {
        displaySessions = [self.videoSessions subarrayWithRange:NSMakeRange(1, self.videoSessions.count - 1)];
    } else {
        displaySessions = [self.videoSessions copy];
    }
    
    [self.viewLayouter layoutSessions:displaySessions fullSession:self.fullSession inContainer:self.remoteContainerView];
    [self setStreamTypeForSessions:displaySessions fullSession:self.fullSession];
}

// set remote vide stream type based on if it is fullsession
- (void)setStreamTypeForSessions:(NSArray<VideoSession *> *)sessions fullSession:(VideoSession *)fullSession {
    if (fullSession) {
        for (VideoSession *session in sessions) {
            [self.rtcEngine setRemoteVideoStream:session.uid type:(session == self.fullSession ? AgoraRtc_VideoStream_High : AgoraRtc_VideoStream_Low)];
        }
    } else {
        for (VideoSession *session in sessions) {
            [self.rtcEngine setRemoteVideoStream:session.uid type:AgoraRtc_VideoStream_High];
        }
    }
}

- (void)addLocalSession {
    VideoSession *localSession = [VideoSession localSession];
    [self.videoSessions addObject:localSession];
    [self.rtcEngine setupLocalVideo:localSession.canvas];
    [self updateInterfaceWithAnimation:YES];
}

- (VideoSession *)fetchSessionOfUid:(NSUInteger)uid {
    for (VideoSession *session in self.videoSessions) {
        if (session.uid == uid) {
            return session;
        }
    }
    return nil;
}

- (VideoSession *)videoSessionOfUid:(NSUInteger)uid {
    VideoSession *fetchedSession = [self fetchSessionOfUid:uid];
    if (fetchedSession) {
        return fetchedSession;
    } else {
        VideoSession *newSession = [[VideoSession alloc] initWithUid:uid];
        [self.videoSessions addObject:newSession];
        [self updateInterfaceWithAnimation:YES];
        return newSession;
    }
}

//MARK: - Agora Media SDK
- (void)loadAgoraKit {
    // initialize Agora Rtc Engine
    self.rtcEngine = [AgoraRtcEngineKit sharedEngineWithAppId:[KeyCenter AppId] delegate:self];
    // Set it to broadcasting mode
    [self.rtcEngine setChannelProfile:AgoraRtc_ChannelProfile_LiveBroadcasting];
    [self.rtcEngine enableDualStreamMode:YES];
    //[self.rtcEngine setEncryptionSecret:self.userPassword];
    // Allow video stream
    [self.rtcEngine enableVideo];
    // Set video profile: resolution, fps, kbps
    [self.rtcEngine setVideoProfile:self.videoProfile swapWidthAndHeight:YES];
    [self.rtcEngine setClientRole:self.clientRole withKey:nil];
    
    
    // user is broadcaster
    if (self.isBroadcaster) {
        // start local video preview, while not sending data to server
        [self.rtcEngine startPreview];
    }
    
    // add user itself to session, and setup local canvas
    [self addLocalSession];
    if(self.isBroadcaster){
        self.roomName = [NSString stringWithFormat:@"%@_%lld", [FIRAuth auth].currentUser.uid,
                         (long long)([[NSDate date] timeIntervalSince1970] * 1000.0)];
    } else {
        self.roomName = self.broadcast.roomName;
    }
    
    YZLog(@"roomName:%@", self.roomName);
    //  the video channel, and use the room name as the channel id
    int code = [self.rtcEngine joinChannelByKey:nil
                                    channelName:self.roomName
                                           info:nil
                                            uid:0
                                    joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
                                        YZLog(@"channel---%@", channel);
                                    }];
    if (code == 0) {
        [self setIdleTimerActive:NO];
        if (self.isBroadcaster) {
            NSString *broadcastId = [[_databaseRef child:@"broadcasts"] childByAutoId].key;
            _broadcast = [[YZBroadcast alloc] initWithBroadcastId:broadcastId
                                                            title:self.broadcastTitle
                                                         roomName:self.roomName
                                                           isLive:YES
                                                     onlineNumber:[NSNumber numberWithInt:0]
                                                             user:[User sharedInstance]];
            [self.liveHeaderView setBroadcast:_broadcast];
            [self postNewBroadcast];
        } else {
            FIRDatabaseReference *ref = [[self.databaseRef child:@"broadcasts"] child:_broadcast.broadcastId];
            [self changeOnlineNumber:ref isIncrease:YES];
            
            FIRDatabaseReference *ref1 = [[[self.databaseRef child:@"user-broadcasts"]
                                           child:_broadcast.user.uid] child:_broadcast.broadcastId];
            [self changeOnlineNumber:ref1 isIncrease:YES];
        
            [self.liveHeaderView setBroadcast:_broadcast];
        }
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlertController:[NSString stringWithFormat:@"Join channel failed: %d", code]];
        });
    }
    
    if (self.isBroadcaster) {
        // enable 美颜 功能
        self.agoraEnhancer = [[AgoraYuvEnhancerObjc alloc] init];
        self.agoraEnhancer.lighteningFactor = 0.7;
        self.agoraEnhancer.smoothness = 0.5;
        [self.agoraEnhancer turnOn];
    }
}

- (void)changeOnlineNumber:(FIRDatabaseReference *)ref isIncrease:(BOOL)isIncrease{
    // [START post_stars_transaction]
    [ref runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
        NSMutableDictionary *broadcastDic = currentData.value;
        if (!broadcastDic || [broadcastDic isEqual:[NSNull null]]) {
            return [FIRTransactionResult successWithValue:currentData];
        }
        int onlineNumber = [broadcastDic[@"onlineNumber"] intValue];
        onlineNumber = isIncrease?onlineNumber + 1:onlineNumber - 1;
        broadcastDic[@"onlineNumber"] = [NSNumber numberWithInt:onlineNumber];
        self.broadcast.onlineNumber = [NSNumber numberWithInt:onlineNumber];
        
        // Set value and report transaction success
        [currentData setValue:broadcastDic];
        return [FIRTransactionResult successWithValue:currentData];
    } andCompletionBlock:^(NSError * _Nullable error,
                           BOOL committed,
                           FIRDataSnapshot * _Nullable snapshot) {
        // Transaction completed
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    // [END post_stars_transaction]
}

- (void)postNewBroadcast{
    // Create new post at /user-broadcasts/$userid/$broadcastid and at
    // /broadcasts/$broadcastid simultaneously
    // [START write_fan_out]
    NSDictionary *broadcastItem = @{@"uid": self.broadcast.user.uid,
                           @"broadcasterName": self.broadcast.user.username,
                           @"broadcastTitle": self.broadcast.title,
                           @"roomName": self.broadcast.roomName,
                           @"isLive": [NSNumber numberWithBool:YES],
                           @"onlineNumber": [NSNumber numberWithInt:1]};
    NSDictionary *childUpdates = @{[@"/broadcasts/" stringByAppendingString:self.broadcast.broadcastId]: broadcastItem,
                                   [NSString stringWithFormat:@"/user-broadcasts/%@/%@/", self.broadcast.user.uid, self.broadcast.broadcastId]: broadcastItem};
    [_databaseRef updateChildValues:childUpdates];
    // [END write_fan_out]
    
    // Create new LiveRoom chat channels at /$liveroom_chatchannels/$broadcastid
    NSDictionary *liveRoomChatChildUpdates = @{[NSString stringWithFormat:@"/liveroom_chatchannels/%@/messages", self.broadcast.broadcastId]: [NSDictionary dictionary]};
    [_databaseRef updateChildValues:liveRoomChatChildUpdates];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed {
    VideoSession *userSession = [self videoSessionOfUid:uid];
    [self.rtcEngine setupRemoteVideo:userSession.canvas];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed {
    if (self.videoSessions.count) {
        [self updateInterfaceWithAnimation:NO];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason {
    VideoSession *deleteSession;
    for (VideoSession *session in self.videoSessions) {
        if (session.uid == uid) {
            deleteSession = session;
        }
    }
    
    if (deleteSession) {
        [self.videoSessions removeObject:deleteSession];
        [deleteSession.hostingView removeFromSuperview];
        [self updateInterfaceWithAnimation:YES];
        
        if (deleteSession == self.fullSession) {
            self.fullSession = nil;
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(liveVCNeedClose:)]) {
        [self.delegate liveVCNeedClose:self];
    }
}


#pragma Chat Feature
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatMessages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(__unused NSIndexPath *)indexPath
{
    YZChatRoomMessage *chatMessage = self.chatMessages[indexPath.row];
    NSString *message = [NSString stringWithFormat:@"%@: %@", chatMessage.user.username, chatMessage.message];
    return [AttributedTableViewCell heightForCellWithText:message
                                           availableWidth:CGRectGetWidth(tableView.frame)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZChatRoomMessage *chatMessage = self.chatMessages[indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    
    AttributedTableViewCell *cell = (AttributedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[AttributedTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *message = [NSString stringWithFormat:@"%@: %@", chatMessage.user.username, chatMessage.message];
    cell.summaryText = message;
    //cell.summaryLabel.delegate = self;
    //cell.summaryLabel.userInteractionEnabled = YES;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.transparentView endEditing:true];
    YZChatRoomMessage *chatMessage = self.chatMessages[indexPath.row];
    YZUserInfoView *userInfoView = [[YZUserInfoView alloc] initWithFrame:CGRectMake(0, 0, KDeviceWidth, KDeviceHeight)];
    [userInfoView showInView:self.view withUser:chatMessage.user withCurrentUID:[User sharedInstance].uid animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//#pragma mark - TTTAttributedLabelDelegate
//- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
