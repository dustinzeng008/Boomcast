//
//  YZLiveRoomTableViewCell.h
//  BoomCast
//
//  Created by Yong Zeng on 12/28/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZChatRoomMessage.h"

@interface YZLiveRoomTableViewCell : UITableViewCell

@property (nonatomic, strong) YZChatRoomMessage *chatRoomMessage;

+ (instancetype) cellWithTableView:(UITableView *)tableView;
+ (CGFloat)heightForCellWithText:(NSString *)text availableWidth:(CGFloat)availableWidth;

@end
