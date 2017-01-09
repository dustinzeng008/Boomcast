//
//  YZChatRoomMessage.h
//  BoomCast
//
//  Created by Yong Zeng on 12/28/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface YZChatRoomMessage : NSObject

@property (nonatomic, copy) User *user;
@property (nonatomic, copy) NSString *message;

- (instancetype) initWithMessage:(NSString *)message user:(User *)user;
@end
