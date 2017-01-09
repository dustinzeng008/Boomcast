//
//  YZLiveHeaderView.h
//  BoomCast
//
//  Created by Yong Zeng on 12/26/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZBroadcast.h"

@interface YZLiveHeaderView : UIView
@property (nonatomic, strong) YZBroadcast *broadcast;

@property(nonatomic, copy) void (^clickProfileImageBlock) ();
//@property(nonatomic, copy) void (^clickFollowButtonBlock) (NSString *uid);

- (void)changeOnlineNumber:(NSNumber *)onlineNumber;
@end
