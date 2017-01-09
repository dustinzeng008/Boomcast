//
//  YZProfileHeaderView.m
//  BoomCast
//
//  Created by Yong Zeng on 12/8/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZProfileHeaderView.h"

#define IMAGEWIDTH 64

@interface YZProfileHeaderView() <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *accountNumberLabel;

@property (nonatomic, strong) UILabel *broadcastNumberLabel;
@property (nonatomic, strong) UILabel *followNumberLabel;
@property (nonatomic, strong) UILabel *followerNumberLabel;

@end

@implementation YZProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setProfileImage:(UIImage *)profileImage{
    _profileImage = profileImage;
    self.profileImageView.image = profileImage;
}

- (void) setUpViews{
    self.backgroundColor = [UIColor whiteColor];
    [self initUpperViews];
    [self initBottomViews];
}

- (void) initUpperViews {
    CGFloat profileImageX = 20;
    CGFloat profileImageY = 20;
    CGFloat profileImageWidth = IMAGEWIDTH;
    CGFloat profileImageHeight = profileImageWidth;
    UIImageView *profileImageView = [[UIImageView alloc] init];
    profileImageView.frame = CGRectMake(profileImageX, profileImageY, profileImageWidth, profileImageHeight);
    [self addSubview:profileImageView];
    _profileImageView = profileImageView;
    [profileImageView setImage:[UIImage imageNamed:@"empty_profile"]];
    profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    profileImageView.layer.cornerRadius = profileImageWidth/2;
    profileImageView.layer.masksToBounds = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePicture:)];
    singleTap.delegate = self;
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [profileImageView addGestureRecognizer:singleTap];
    [profileImageView setUserInteractionEnabled:YES];
    
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.frame = CGRectMake(profileImageX + IMAGEWIDTH + 10,
                                     profileImageY + 10,
                                     KDeviceWidth - profileImageWidth - profileImageX - 10*2,
                                     22);
    [self addSubview:userNameLabel];
    _userNameLabel = userNameLabel;
    userNameLabel.text = @"User Name";
    userNameLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    UILabel *accountNumberLabel = [[UILabel alloc] init];
    accountNumberLabel.frame = CGRectMake(profileImageX + IMAGEWIDTH + 10,
                                          profileImageY + 32,
                                          KDeviceWidth - profileImageWidth - profileImageX - 10*2,
                                          22);
    [self addSubview:accountNumberLabel];
    _accountNumberLabel = accountNumberLabel;
    accountNumberLabel.text = @"Account Number";
    accountNumberLabel.font = [UIFont systemFontOfSize:14];
    accountNumberLabel.textColor = [UIColor grayColor];
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     profileImageY + profileImageHeight + 10,
                                                                     KDeviceWidth,
                                                                     1)];
    [self addSubview:separatorView];
    separatorView.backgroundColor = [UIColor colorFromHexCode:@"F5F5F5"];
}

- (void) initBottomViews {
    UIView *broadcastButton = [self headerToolButton:@"Broadcasts" withTag:1];
    broadcastButton.frame = CGRectMake(0, 97, KDeviceWidth / 3, 64);
    [self addSubview:broadcastButton];
    
    UIView *followButton = [self headerToolButton:@"Follow" withTag:2];
    followButton.frame = CGRectMake(KDeviceWidth / 3, 97, KDeviceWidth / 3, 64);
    [self addSubview:followButton];
    
    UIView *followerButton = [self headerToolButton:@"Follower" withTag:3];
    followerButton.frame = CGRectMake((KDeviceWidth / 3)*2, 97, KDeviceWidth / 3, 64);
    [self addSubview:followerButton];
}

- (UIView *) headerToolButton:(NSString *)title withTag:(int)tag{
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KDeviceWidth / 3, 64)];
    [self addSubview:buttonView];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, KDeviceWidth / 3, 20)];
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
    //numberLabel.backgroundColor = [UIColor redColor];
    
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, KDeviceWidth / 3, 20)];
    [buttonView addSubview:textlabel];
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.text = title;
    textlabel.font = [UIFont systemFontOfSize:14];
    textlabel.textColor = [UIColor grayColor];
    //textlabel.backgroundColor = [UIColor blueColor];
    
    return buttonView;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}

- (void)changePicture:(UIGestureRecognizer *)gestureRecognizer {
    YZLog(@"gestureRecognizer...");
    if ([self.delegate respondsToSelector:@selector(changeProfileImage:)]) {
        [self.delegate changeProfileImage:_profileImageView];
    }
}

- (void)setUser:(User *)user{
    _user = user;
    self.userNameLabel.text = user.username;
    self.accountNumberLabel.text = user.location;
    self.broadcastNumberLabel.text = [user.broadcastNumber stringValue];
    self.followNumberLabel.text = [user.followNumber stringValue];
    self.followerNumberLabel.text = [user.followerNumber stringValue];
    if (user.profileImage != nil) {
        self.profileImageView.image = user.profileImage;
    }
}

@end
