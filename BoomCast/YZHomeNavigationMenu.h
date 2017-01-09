//
//  YZHomeNavigationMenu.h
//  BoomCast
//
//  Created by Yong Zeng on 12/20/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MENUITEMWIDTH 70
#define MENUITEMHEIGHT 26
#define MARGIN 10

typedef NS_ENUM(NSUInteger, HomeNavigationMenuType) {
    HomeNavigationMenuTypeHottest,
    HomeNavigationMenuTypeNewest,
    HomeNavigationMenuTypeFollow
};

@interface YZHomeNavigationMenu : UIView

@property(nonatomic, copy)void (^selectedBlock) (HomeNavigationMenuType type);
@property (nonatomic, weak, readonly) UIView *underLine;
@property(nonatomic, assign) HomeNavigationMenuType selectedItemType;

@end
