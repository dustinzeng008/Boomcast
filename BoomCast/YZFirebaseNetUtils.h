//
//  YZFirebaseNetUtils.h
//  BoomCast
//
//  Created by Yong Zeng on 1/1/17.
//  Copyright © 2017 Yong Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZFirebaseNetUtils : NSObject

+ (void)checkFollowStatusWithUID:(NSString *)uid followerID:(NSString *)followerID
                      completion:(void(^)(BOOL isFollowed))completion;

+ (void)addFollowWithUID:(NSString *)uid followerID:(NSString *)followerID;

+ (void)deleteFollowWithUID:(NSString *)uid followerID:(NSString *)followerID;

@end
