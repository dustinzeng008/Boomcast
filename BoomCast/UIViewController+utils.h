//
//  UIViewController+utils.h
//  BoomCast
//
//  Created by Yong Zeng on 11/23/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (utils)
//+ (void)showAlertController:(NSString *title) message:(NSString *message) (void(^)(NSString *str))block
- (void)showAlertController:(NSString *)title message:(NSString *)message showIn:(UIViewController *)viewController;
- (void)showAlertController:(NSString *)title message:(NSString *)message;
- (void)showAlertController:(NSString *)message;
- (void)showAlertController:(NSString *)message showIn:(UIViewController *)viewController;
@end
