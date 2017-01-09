//
//  YZBaseSettingCell.h
//  BoomCast
//
//  Created by Yong Zeng on 11/27/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZBaseSettingItem.h"

@interface YZBaseSettingCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZBaseSettingItem *item;

@end
