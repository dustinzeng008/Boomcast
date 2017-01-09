//
//  YZTool.m
//  BoomCast
//
//  Created by Yong Zeng on 12/1/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZTool.h"

@implementation YZTool

/****************************  Validate Email  *****************************/
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate
                              predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
