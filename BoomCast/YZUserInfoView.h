//
//  YZUserInfoView.h
//  BoomCast
//
//  Created by Yong Zeng on 12/28/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
//@protocol YZUserInfoViewDelegate <NSObject>
//
//- (void)clickFollowButtonWithUID:(NSString *)uid;
//
//@end

@interface YZUserInfoView : UIView
- (void)showInView:(UIView *)superView withUser:(User *)user
    withCurrentUID:(NSString *)uid animated:(BOOL)animated;

//@property (nonatomic, weak) id <YZUserInfoViewDelegate> delegate;
@end
