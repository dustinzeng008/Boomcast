//
//  UIImage+Image.h
//  BoomCast
//
//  Created by Yong Zeng on 11/23/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)


// load original image
+ (instancetype)imageWithOriginalName:(NSString *)imageName;

+ (instancetype)imageWithStretchableName:(NSString *)imageName;

+ (UIImage *)imageFromColor:(UIColor *)color;

+ (UIImage*)renderImage:(NSString *)imagName;


@end
