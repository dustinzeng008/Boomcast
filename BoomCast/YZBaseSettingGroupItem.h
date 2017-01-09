//
//  YZGroupItem.h
//  BoomCast
//
//  Created by Yong Zeng on 11/27/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZBaseSettingGroupItem : NSObject

// Number of cells in a group (YZRowItem)
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;

@end
