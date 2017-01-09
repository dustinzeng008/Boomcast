//
//  YZFirebaseNetUtils.m
//  BoomCast
//
//  Created by Yong Zeng on 1/1/17.
//  Copyright © 2017 Yong Zeng. All rights reserved.
//

#import "YZFirebaseNetUtils.h"
@import Firebase;

@implementation YZFirebaseNetUtils


+ (void)checkFollowStatusWithUID:(NSString *)uid followerID:(NSString *)followerID
                      completion:(void(^)(BOOL isFollowed))completion{
    FIRDatabaseReference *databaseRef = [[FIRDatabase database] reference];
    [[[databaseRef child:@"user_follower"] child:uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        BOOL result = false;
        while (child = [children nextObject]) {
            //YZLog(@"child data---%@", child);
            //YZLog(@"child.value:%@   currentUID:%@", child.value, [User sharedInstance].uid);
            if ([child.value isEqualToString:followerID]) {
                result = true;
            }
        }
        completion(result);
    }];
}

+ (void)addFollowWithUID:(NSString *)uid followerID:(NSString *)followerID{
    FIRDatabaseReference *databaseRef = [[FIRDatabase database] reference];
    FIRDatabaseReference *userFollowRef = [[databaseRef child:@"user_follow"] child:followerID];
    FIRDatabaseReference *userFollowItemRef = [userFollowRef childByAutoId];
    [userFollowItemRef setValue:uid];
    
    FIRDatabaseReference *userFollowerRef = [[databaseRef child:@"user_follower"] child:uid];
    FIRDatabaseReference *userFollowerItemRef = [userFollowerRef childByAutoId];
    [userFollowerItemRef setValue:followerID];
}

+ (void)deleteFollowWithUID:(NSString *)uid followerID:(NSString *)followerID{
    FIRDatabaseReference *databaseRef = [[FIRDatabase database] reference];
    FIRDatabaseReference *userFollowRef = [[databaseRef child:@"user_follow"] child:followerID];
    [userFollowRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        while (child = [children nextObject]) {
            [[userFollowRef child:child.key] removeValue];
            if ([child.value isEqualToString:followerID]) {
                [[userFollowRef child:child.key] removeValue];
            }
        }
    }];
    
    FIRDatabaseReference *userFollowerRef = [[databaseRef child:@"user_follower"] child:uid];
    [userFollowerRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        while (child = [children nextObject]) {
            [[userFollowerRef child:child.key] removeValue];
            if ([child.value isEqualToString:followerID]) {
                [[userFollowerRef child:child.key] removeValue];
            }
        }
    }];
}

@end
