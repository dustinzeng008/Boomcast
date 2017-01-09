//
//  User.m
//  BoomCast
//
//  Created by Yong Zeng on 12/13/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "User.h"

@implementation User

+ (User *)sharedInstance {
    static dispatch_once_t onceToken;
    static User *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[User alloc] init];
    });
    return instance;
}


- (id)init {
    self = [super init];
    if (self) {
        _username = nil;
        _email = nil;
        _profileImage = nil;
        _location = nil;
        _followNumber = nil;
        _followerNumber = nil;
        _broadcastNumber = nil;
    }
    return self;
}

- (instancetype) initWithUid:(NSString *)uid UserName:(NSString *)username
                       email:(NSString *)email location:(NSString *)location
                profileImage:(UIImage *)profileImage followNumber:(NSNumber *)followNumber
              followerNumber:(NSNumber *)followerNumber broadcastNumber:(NSNumber *)broadcastNumber{
    if (self = [super init]) {
        _uid = uid;
        _username = username;
        _email = email;
        _location = location;
        _profileImage = profileImage;
        _followNumber = followNumber;
        _followerNumber = followNumber;
        _broadcastNumber = broadcastNumber;
    }
    return self;
}

- (instancetype) initWithUid:(NSString *)uid UserName:(NSString *)username email:(NSString *)email
                    location:(NSString *)location profileImage:(UIImage *)profileImage{
    return [self initWithUid:uid UserName:username
                       email:email
                    location:location
                profileImage:profileImage
                followNumber:[NSNumber numberWithInt:0]
              followerNumber:[NSNumber numberWithInt:0]
             broadcastNumber:[NSNumber numberWithInt:0]];
}

@end
