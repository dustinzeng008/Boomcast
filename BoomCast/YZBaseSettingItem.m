//
//  YZRowItem.m
//  BoomCast
//
//  Created by Yong Zeng on 11/27/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZBaseSettingItem.h"

@implementation YZBaseSettingItem

+ (instancetype)itemWithTitle:(NSString*)title{
    return [self itemWithTitle:title subTitle:nil image:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage*)image{
    return [self itemWithTitle:title subTitle:nil image:image];
}

+ (instancetype)itemWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
                        image:(UIImage*)image{
    YZBaseSettingItem *item = [[self alloc] init];
    item.title = title;
    item.subTitle = subTitle;
    item.image = image;
    return item;
}

@end
