//
//  YZBroadCastTableViewCell.h
//  BoomCast
//
//  Created by Yong Zeng on 12/22/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZBroadcastFrame;

@protocol YZBroadcastTableViewDelegate <NSObject>

- (void)clickProfileImage:(YZBroadcastFrame *)broadcastFrame;

@end

@interface YZBroadCastTableViewCell : UITableViewCell

@property (nonatomic, strong) YZBroadcastFrame *broadcastFrame;

+ (instancetype)broadcastCellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id <YZBroadcastTableViewDelegate> delegate;

@end
