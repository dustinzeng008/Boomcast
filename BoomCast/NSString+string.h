//
//  NSString+string.h
//  BoomCast
//
//  Created by Yong Zeng on 12/13/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (string)

+(NSString *)trim:(NSString *) strInput;
+ (CGSize)sizeWithText: (NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize;
+ (BOOL)isEmpty:(NSString*)string;
+ (BOOL)isValidEmail:(NSString*)email;
@end
