//
//  YZProfileHeaderView.h
//  BoomCast
//
//  Created by Yong Zeng on 12/8/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol YZProfileHeaderViewDelegate <NSObject>

- (void)changeProfileImage:(UIImageView *)profileImageView;

@end

@interface YZProfileHeaderView : UIView

@property (nonatomic, strong) UIImage *profileImage;
//@property (nonatomic, assign) NSString *userName;
//@property (nonatomic, assign) NSString *accountNumber;
//
//@property (nonatomic, assign) NSNumber *broadcastNumber;
//@property (nonatomic, assign) NSNumber *followNumber;
//@property (nonatomic, assign) NSNumber *followerNumber;

@property (nonatomic, strong) User *user;

@property (nonatomic, weak) id <YZProfileHeaderViewDelegate> delegate;

@end
