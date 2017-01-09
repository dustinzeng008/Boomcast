//
//  YZLiveHeaderView.m
//  BoomCast
//
//  Created by Yong Zeng on 12/26/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZLiveHeaderView.h"

#define YZTITLEFONT 12
#define YZFOLLOWBUTTONFONT 14

@interface YZLiveHeaderView()
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *onlineNumberLable;
@property (nonatomic, strong) UIButton *followButton;
@end

@implementation YZLiveHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    CGFloat marginLeft = 10;
    CGFloat marginTop = 0;
    CGFloat viewHeight = 40;
    UIView *broadcasterView = [[UIView alloc] init];
    broadcasterView.frame = CGRectMake(marginLeft, marginTop, 100, viewHeight);
    broadcasterView.layer.cornerRadius = viewHeight/2;
    broadcasterView.layer.masksToBounds = YES;
    broadcasterView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:0.5];
    [self addSubview:broadcasterView];
   
    UIImageView *profileImageView = [[UIImageView alloc] init];
    profileImageView.frame = CGRectMake(0, 0, viewHeight, viewHeight);
    profileImageView.layer.cornerRadius = viewHeight/2;
    profileImageView.layer.masksToBounds = YES;
    [broadcasterView addSubview:profileImageView];
     _profileImageView = profileImageView;
    [profileImageView setImage:[UIImage imageNamed:@"empty_profile"]];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickProfileImage:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [profileImageView addGestureRecognizer:singleTap];
    [profileImageView setUserInteractionEnabled:YES];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(viewHeight + 10, 0, 40, 20);
    [broadcasterView addSubview:titleLabel];
    [titleLabel setText:@"Live"];
    titleLabel.font = [UIFont systemFontOfSize:YZTITLEFONT];
    titleLabel.textColor = [UIColor whiteColor];
    
    UILabel *onlineNumberLable = [[UILabel alloc] init];
    onlineNumberLable.frame = CGRectMake(viewHeight + 10, 20, 40, 20);
    [broadcasterView addSubview:onlineNumberLable];
    [onlineNumberLable setText:@"0"];
    onlineNumberLable.font = [UIFont systemFontOfSize:YZTITLEFONT];
    onlineNumberLable.textColor = [UIColor whiteColor];
    _onlineNumberLable = onlineNumberLable;
    
//    UIButton *followButton = [[UIButton alloc] init];
//    followButton.frame = CGRectMake(92, 5, 50, 30);
//    followButton.backgroundColor = [UIColor mainColor];
//    [followButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [followButton setTitle:@"Follow" forState:UIControlStateNormal];
//    followButton.titleLabel.font = [UIFont systemFontOfSize:YZTITLEFONT];
//    followButton.layer.cornerRadius = 30/2;
//    followButton.layer.masksToBounds = YES;
//    [broadcasterView addSubview:followButton];
//    _followButton = followButton;
//    [followButton addTarget:self action:@selector(clickFollowButton:)
//           forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickProfileImage:(UITapGestureRecognizer *)sender{
    if (self.clickProfileImageBlock) {
        self.clickProfileImageBlock();
    }
}

//- (void)clickFollowButton:(UIButton *)sender{
//    if (self.clickFollowButtonBlock) {
//        self.clickFollowButtonBlock(self.broadcast.user.uid);
//    }
//}

- (void)setBroadcast:(YZBroadcast *)broadcast{
    _broadcast = broadcast;
    if (broadcast.user.profileImage != nil) {
        self.profileImageView.image = broadcast.user.profileImage;
    }
    self.onlineNumberLable.text = [broadcast.onlineNumber stringValue];
}

- (void)changeOnlineNumber:(NSNumber *)onlineNumber{
    self.onlineNumberLable.text = [onlineNumber stringValue];
}
@end
