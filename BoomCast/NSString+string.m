//
//  NSString+string.m
//  BoomCast
//
//  Created by Yong Zeng on 12/13/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "NSString+string.h"

@implementation NSString (string)

+(NSString *)trim:(NSString *) strInput{
    return [strInput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (CGSize)sizeWithText: (NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize{
    CGSize textSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return textSize;
}

+ (BOOL)isEmpty:(NSString*)string{
    if (string == nil || string == NULL || [[NSString trim:string] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isValidEmail:(NSString*)email{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
