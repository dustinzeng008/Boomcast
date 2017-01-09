//
//  YZBroadcast.h
//  BoomCast
//
//  Created by Yong Zeng on 12/22/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface YZBroadcast : NSObject

@property (nonatomic, copy) User *user;
@property (nonatomic, copy) NSString *broadcastId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, assign) BOOL isLive;
@property (nonatomic, copy) NSNumber *onlineNumber;

- (instancetype) initWithBroadcastId:(NSString *)broadcastId title:(NSString *)title
                            roomName:(NSString *)roomName isLive:(BOOL)isLive
                        onlineNumber:(NSNumber *)onlineNumber user:(User *)user;
- (instancetype) initWithDic:(NSDictionary *)dic;
+ (instancetype) broadcastWithDic:(NSDictionary *)dic;

@end
