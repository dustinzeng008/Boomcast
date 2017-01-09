//
//  YZRowItem.h
//  BoomCast
//
//  Created by Yong Zeng on 11/27/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YZBaseSettingItemOption)();

@interface YZBaseSettingItem : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, strong) Class destinationVC;
@property (nonatomic, copy) YZBaseSettingItemOption option;

+ (instancetype)itemWithTitle:(NSString*)title;
+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage*)image;
+ (instancetype)itemWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
                        image:(UIImage*)image;


@end
