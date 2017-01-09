//
//  YZCircularTextField.h
//  BoomCast
//
//  Created by Yong Zeng on 12/7/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZCircularTextField : UITextField

+ (instancetype)initWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
              placeHolder:(NSString *)placeHolder;

@end
