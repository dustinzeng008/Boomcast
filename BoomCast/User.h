//
//  User.h
//  BoomCast
//
//  Created by Yong Zeng on 12/13/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(strong, nonatomic) NSString *uid;
@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSString *email;
@property(strong, nonatomic) NSString *location;
@property(strong, nonatomic) UIImage *profileImage;
@property(strong, nonatomic) NSNumber *followNumber;
@property(strong, nonatomic) NSNumber *followerNumber;
@property(strong, nonatomic) NSNumber *broadcastNumber;
+ (User *)sharedInstance;

- (instancetype) initWithUid:(NSString *)uid UserName:(NSString *)username
                       email:(NSString *)email location:(NSString *)location
                profileImage:(UIImage *)profileImage followNumber:(NSNumber *)followNumber
              followerNumber:(NSNumber *)followerNumber broadcastNumber:(NSNumber *)broadcastNumber;

- (instancetype) initWithUid:(NSString *)uid UserName:(NSString *)username email:(NSString *)email
                         location:(NSString *)location profileImage:(UIImage *)profileImage;

@end
