//
//  YZChatRoomMessage.m
//  BoomCast
//
//  Created by Yong Zeng on 12/28/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZChatRoomMessage.h"

@implementation YZChatRoomMessage

- (instancetype) initWithMessage:(NSString *)message user:(User *)user{
    if (self = [super init]) {
        _message = message;
        _user = user;
    }
    return self;
}

@end
