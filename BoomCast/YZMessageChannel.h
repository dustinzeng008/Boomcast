//
//  YZMessageChannel.h
//  BoomCast
//
//  Created by Yong Zeng on 12/25/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface YZMessageChannel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) User *user;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSDate *date;

@end
