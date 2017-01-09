//
//  UIViewController+utils.m
//  BoomCast
//
//  Created by Yong Zeng on 11/23/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "UIViewController+utils.h"

@implementation UIViewController (utils)

- (void)showAlertController:(NSString *)title message:(NSString *)message showIn:(UIViewController *)viewController{
  UIAlertController * alert=   [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction* ok = [UIAlertAction
                       actionWithTitle:@"OK"
                       style:UIAlertActionStyleDefault
                       handler:^(UIAlertAction * action)
                       {
                         [alert dismissViewControllerAnimated:YES completion:nil];
                         
                       }];
  
  [alert addAction:ok];
  [viewController presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertController:(NSString *)title message:(NSString *)message{
  [self showAlertController:title message:message showIn:self];
}

- (void)showAlertController:(NSString *)message{
  [self showAlertController:@"BoomCast" message:message showIn:self];
}

- (void)showAlertController:(NSString *)message showIn:(UIViewController *)viewController{
  [self showAlertController:@"BoomCast" message:message showIn:viewController];
}


@end
