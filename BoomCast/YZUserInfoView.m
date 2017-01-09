//
//  YZUserInfoView.m
//  BoomCast
//
//  Created by Yong Zeng on 12/28/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZUserInfoView.h"
#import "YZFirebaseNetUtils.h"

@interface YZUserInfoView()
@property (nonatomic, strong) UIView *popUpView;
@property (nonatomic, strong) UIImageView *profileImage;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *broadcastNumberLabel;
@property (nonatomic, strong) UILabel *followNumberLabel;
@property (nonatomic, strong) UILabel *followerNumberLabel;
@property (nonatomic, strong) UIButton *btn_follow;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *currentUID;
@end

@implementation YZUserInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
        [self initViews];
    }
    return self;
}

- (void) initViews{
    CGFloat popUpViewWidth = 260;
    CGFloat popUpViewHeight = 300;
    UIView *popUpView = [[UIView alloc] init];
    popUpView.frame = CGRectMake((KDeviceWidth - popUpViewWidth )/2, (KDeviceHeight - popUpViewHeight)/2, popUpViewWidth, popUpViewHeight);
    [self addSubview:popUpView];
    _popUpView = popUpView;
    popUpView.layer.cornerRadius = 5;
    popUpView.layer.shadowOpacity = 0.8;
    popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    [popUpView setBackgroundColor:[UIColor whiteColor]];
    [popUpView setUserInteractionEnabled:YES];
    
    
    // ------------------------ Initialize Close Button -------------------------
    CGFloat closeButtonWidth = 44;
    UIButton *btn_close = [[UIButton alloc] initWithFrame:CGRectMake(popUpViewWidth - closeButtonWidth,
                                                                     0,
                                                                     closeButtonWidth,
                                                                     closeButtonWidth)];
    [popUpView addSubview:btn_close];
    
    [btn_close setTintColor:[UIColor lightGrayColor]];
    [btn_close setImage:[UIImage renderImage:@"close"] forState:UIControlStateNormal];
    [btn_close addTarget:self action:@selector(closePopView:) forControlEvents:UIControlEventTouchUpInside];
    [btn_close setUserInteractionEnabled:YES];
    
    // ------------------------ Initialize Profile Image -------------------------
    CGFloat profileImageWidth = 80;
    CGFloat profileImageX = (popUpViewWidth - profileImageWidth)/2;
    CGFloat profileImageY = 30;
    UIImageView *profileImageView = [[UIImageView alloc] init];
    profileImageView.frame = CGRectMake(profileImageX,
                                        profileImageY,
                                        profileImageWidth,
                                        profileImageWidth);
    [popUpView addSubview:profileImageView];
    _profileImage = profileImageView;
    [profileImageView setImage:[UIImage imageNamed:@"empty_profile"]];
    profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    profileImageView.layer.cornerRadius = profileImageWidth/2;
    profileImageView.layer.masksToBounds = YES;
    
    // ------------------------ Initialize User Name Label -------------------------
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.frame = CGRectMake(30,
                                     CGRectGetMaxY(profileImageView.frame) + 10,
                                     popUpViewWidth - 30*2,
                                     22);
    [popUpView addSubview:userNameLabel];
    _userNameLabel = userNameLabel;
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    userNameLabel.text = @"User Name";
    userNameLabel.font = [UIFont systemFontOfSize:18];
    
    [self initFriendsViewFromY:CGRectGetMaxY(userNameLabel.frame)+10 width:popUpViewWidth];
    
    // ------------------------ Initialize Follow Button -------------------------
    CGFloat followButtonHeight = 44;
    UIButton *btn_follow = [[UIButton alloc] initWithFrame:CGRectMake(15,
                                                                      CGRectGetMaxY(userNameLabel.frame)+20 +64 +10,
                                                                      popUpViewWidth - 2*15,
                                                                      followButtonHeight)];
    [popUpView addSubview:btn_follow];
    _btn_follow = btn_follow;
    [btn_follow setBackgroundImage:[UIImage imageFromColor:[UIColor mainColor]]
                          forState:UIControlStateNormal];
    [btn_follow setBackgroundImage:[UIImage imageFromColor:[UIColor greenSeaColor]]
                          forState:UIControlStateHighlighted];
    [[btn_follow titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    [btn_follow setBackgroundColor:[UIColor mainColor]];
    [btn_follow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_follow setTitle:@"Follow" forState:UIControlStateNormal];
    //[btn_follow setEnabled:NO];
    [btn_follow setUserInteractionEnabled:YES];
    btn_follow.layer.cornerRadius = 10/2;
    btn_follow.layer.masksToBounds = YES;
    [btn_follow addTarget:self action:@selector(clickFollowButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) initFriendsViewFromY:(CGFloat)y width:(CGFloat)width{
    
    UIView *broadcastButton = [self headerToolButton:@"Broadcasts" withTag:1 withWidth:width];
    broadcastButton.frame = CGRectMake(0, y, width / 3, 64);
    [_popUpView addSubview:broadcastButton];
    
    UIView *followButton = [self headerToolButton:@"Follow" withTag:2 withWidth:width];
    followButton.frame = CGRectMake(width / 3, y, width / 3, 64);
    [_popUpView addSubview:followButton];
    
    UIView *followerButton = [self headerToolButton:@"Follower" withTag:3 withWidth:width];
    followerButton.frame = CGRectMake((width / 3)*2, y, width / 3, 64);
    [_popUpView addSubview:followerButton];
}

- (UIView *) headerToolButton:(NSString *)title withTag:(int)tag withWidth:(CGFloat)width{
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width / 3, 64)];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, width / 3, 20)];
    [buttonView addSubview:numberLabel];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = @"0";
    if (tag == 1) {
        _broadcastNumberLabel = numberLabel;
    } else if (tag == 2){
        _followNumberLabel = numberLabel;
    } else if (tag == 3){
        _followerNumberLabel = numberLabel;
    }
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, width / 3, 20)];
    [buttonView addSubview:textlabel];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.text = title;
    textlabel.font = [UIFont systemFontOfSize:14];
    textlabel.textColor = [UIColor grayColor];
    
    return buttonView;
}

- (void)closePopView:(UIButton*)sender{
    YZLog(@"close popview...");
    [self removeAnimate];
}

- (void)clickFollowButton:(UIButton*)sender{
    YZLog(@"click follow button...");
    [self removeAnimate];

    if ([self.btn_follow.titleLabel.text isEqualToString:@"Follow"]) {
        [self.btn_follow setTitle:@"UnFollow" forState:UIControlStateNormal];
        [YZFirebaseNetUtils addFollowWithUID:self.user.uid followerID:_currentUID];
    } else {
        [self.btn_follow setTitle:@"Follow" forState:UIControlStateNormal];
        [YZFirebaseNetUtils deleteFollowWithUID:self.user.uid followerID:_currentUID];
    }
}

- (void)showInView:(UIView *)superView withUser:(User *)user
      withCurrentUID:(NSString *)uid animated:(BOOL)animated{
    [superView addSubview:self];
    if (animated) {
        [self showAnimate];
    }
    _user = user;
    _currentUID = uid;
    
    self.userNameLabel.text = user.username;
    self.broadcastNumberLabel.text = [user.broadcastNumber stringValue];
    self.followNumberLabel.text = [user.followNumber stringValue];
    self.followerNumberLabel.text = [user.followerNumber stringValue];
    if(user.profileImage != nil){
        [self.profileImage setImage:user.profileImage];
    }
    if ([user.uid isEqualToString:[User sharedInstance].uid]) {
        self.btn_follow.userInteractionEnabled = NO;
    }
    //Check if the user is followed
    YZLog(@"user.uid:%@   uid:%@", user.uid, uid);
    [YZFirebaseNetUtils checkFollowStatusWithUID:user.uid followerID:uid completion:^(BOOL isFollowed) {
        [self.btn_follow setEnabled:YES];
        if (isFollowed) {
            [self.btn_follow setTitle:@"UnFollow" forState:UIControlStateNormal];
        } else {
            [self.btn_follow setTitle:@"Follow" forState:UIControlStateNormal];
        }
    }];
}

- (void)showAnimate{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate{
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
