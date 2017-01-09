//
//  YZTabBar.h
//  BoomCast
//
//  Created by Yong Zeng on 11/26/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZTabBar;
@protocol YZTabBarDelegate <NSObject>

@optional
- (void)tabBarDidClickPlusBtn:(YZTabBar *)tabBar;

@end

@interface YZTabBar : UITabBar

@property (nonatomic, weak) id <YZTabBarDelegate> tabBarDelegate;

@end
