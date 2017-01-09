//
//  YZBroadcast.m
//  BoomCast
//
//  Created by Yong Zeng on 12/22/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZBroadcast.h"

@implementation YZBroadcast

- (instancetype) initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype) broadcastWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}

- (instancetype) initWithBroadcastId:(NSString *)broadcastId title:(NSString *)title
                            roomName:(NSString *)roomName isLive:(BOOL)isLive
                        onlineNumber:(NSNumber *)onlineNumber user:(User *)user{
    if (self = [super init]) {
        _broadcastId = broadcastId;
        _title = title;
        _roomName = roomName;
        _isLive = isLive;
        _onlineNumber = onlineNumber;
        _user = user;
    }
    return self;
}

@end
