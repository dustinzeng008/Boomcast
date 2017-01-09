//
//  YZNewestViewController.m
//  BoomCast
//
//  Created by Yong Zeng on 12/20/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZNewestViewController.h"
#import <MBProgressHUD.h>
#import "YZBroadcastFrame.h"
#import "YZBroadcast.h"
#import "YZBroadCastTableViewCell.h"
#import "YZLiveRoomViewController.h"
#import <TSMessage.h>
#import "YZUserInfoView.h"
@import Firebase;

@interface YZNewestViewController () <UITableViewDelegate, UITableViewDataSource,
                                YZLiveRoomVCDelegate, YZBroadcastTableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property(strong, nonatomic) FIRDatabaseReference *databaseRef;
@property (strong, nonatomic) FIRStorageReference *storageRef;

@property (nonatomic, strong) NSMutableArray *broadcastFrames;
@end

@implementation YZNewestViewController

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
//    if ([self isBeingPresented] || [self isMovingToParentViewController]) {
//        // Perform an action that will only be done once
//        [self loadNewestBroadcast];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [TSMessage setDefaultViewController:self];
    // Do any additional setup after loading the view.
    //[self loadNewestBroadcast];
    // [START create_database_reference]
    self.databaseRef = [[FIRDatabase database] reference];
    self.storageRef = [[FIRStorage storage] reference];
    // [END create_database_reference]
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadNewestBroadcast];
}

- (void)loadNewestBroadcast{
    _broadcastFrames = [[NSMutableArray alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    FIRDatabaseQuery *query = [[self.databaseRef child:@"broadcasts"] queryLimitedToLast:20];
    [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        for (int i = 0; i < snapshot.children.allObjects.count; i++) {
            FIRDataSnapshot *broadcastItem = snapshot.children.allObjects[i];
            NSString *uid = broadcastItem.value[@"uid"];
            NSString *roomName = broadcastItem.value[@"roomName"];
            NSNumber *onlineNumber = broadcastItem.value[@"onlineNumber"];
            BOOL isLive = [broadcastItem.value[@"isLive"] boolValue];
            NSString *broadcastTitle = broadcastItem.value[@"broadcastTitle"];
            NSString *broadcastId = broadcastItem.key;
            
            BOOL isExist = false;
            for(int j = 0; j < self.broadcastFrames.count; j++){
                YZBroadcastFrame *broadcastFrame = [self.broadcastFrames objectAtIndex:j];
                YZBroadcast *broadcast =  broadcastFrame.broadcast;
                if([broadcastId isEqualToString:broadcast.broadcastId]){
                    isExist = true;
                    if(!isLive){
                        [self.broadcastFrames removeObjectAtIndex:j];
                    } else {
                        broadcast.onlineNumber = onlineNumber;
                    }
                }
            }
            if(isExist){
                [self.tableView reloadData];
                continue;
            }
            
            if (!isLive) {
                continue;
            }
            
            User *user = [[User alloc] init];
            [[[self.databaseRef child:@"users"] child:uid] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
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
                
                YZBroadcast *broadcast = [[YZBroadcast alloc] initWithBroadcastId:broadcastId title:broadcastTitle roomName:roomName isLive:isLive onlineNumber:onlineNumber user:user];
                //[_broadcastList addObject:broadcast];
                YZBroadcastFrame* broadcastFrame = [[YZBroadcastFrame alloc] init];
                broadcastFrame.broadcast = broadcast;
                [self.broadcastFrames insertObject:broadcastFrame atIndex:0];
                [self.tableView reloadData];
                
                NSString *profileImagePath = snapshot.value[@"profileImagePath"];
                if (![profileImagePath isEqualToString:@""]) {
                    [[_storageRef child:profileImagePath] dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData * _Nullable data, NSError * _Nullable error) {
                        if (error) {
                            YZLog(@"get profile image error---,%@", error.localizedDescription);
                            return;
                        }
                        user.profileImage = [UIImage imageWithData:data];
                        [self.tableView reloadData];
                    }];
                }
            }];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.broadcastFrames.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.create reuseable cell
    YZBroadCastTableViewCell * cell = [YZBroadCastTableViewCell broadcastCellWithTableView:tableView];
    cell.delegate = self;
    // 2. set child component's value
    YZBroadcastFrame *frame = self.broadcastFrames[indexPath.row];
    cell.broadcastFrame = frame;
    //[cell setBroadcastFrame:frame];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YZBroadcastFrame *frame = self.broadcastFrames[indexPath.row];
    YZBroadcast *broadcast = frame.broadcast;
    
    YZLiveRoomViewController *liveVC = [[YZLiveRoomViewController alloc] init];
    liveVC.broadcast = broadcast;
    liveVC.userName = [User sharedInstance].username;
    liveVC.broadcastTitle = broadcast.title;
    liveVC.videoProfile = AgoraRtc_VideoProfile_480P;
    liveVC.clientRole = AgoraRtc_ClientRole_Audience;
    liveVC.delegate = self;
    [self presentViewController:liveVC animated:YES completion:nil];
}

- (void)liveVCNeedClose:(YZLiveRoomViewController *)liveVC{
    [TSMessage showNotificationWithTitle:@"Live stream ended!"
                                subtitle:nil
                                    type:TSMessageNotificationTypeWarning];
}

#pragma tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YZBroadcastFrame *frame = self.broadcastFrames[indexPath.row];
    YZLog(@"frame height：%f", frame.rowHeight);
    return frame.rowHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y + _tableView.contentInset.top;
    CGFloat panTranslationY = [scrollView.panGestureRecognizer translationInView:self.tableView].y;
    
    if (offsetY > 64) {
        if (panTranslationY > 0) {  //scroll down to show
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [self.tabBarController.tabBar setHidden:NO];
        }
        else {  //scroll up hide
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.tabBarController.tabBar setHidden:YES];
        }
    }
    else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.tabBarController.tabBar setHidden:NO];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if(velocity.y > 0) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.tabBarController.tabBar setHidden:YES];
    }
    else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.tabBarController.tabBar setHidden:NO];
    }
}

#pragma YZBroadcastTableView Delegate
- (void)clickProfileImage:(YZBroadcastFrame *)broadcastFrame{
    YZLog(@"click profile image...");
    YZUserInfoView *userInfoView = [[YZUserInfoView alloc] initWithFrame:self.view.bounds];
    [userInfoView showInView:self.view withUser:broadcastFrame.broadcast.user withCurrentUID:[User sharedInstance].uid animated:YES];
}

@end
