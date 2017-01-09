//
//  YZNavigationController.m
//  BoomCast
//
//  Created by Yong Zeng on 11/26/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZNavigationController.h"
#import "UIColor+color.h"

@interface YZNavigationController ()

@end

@implementation YZNavigationController


+ (void)initialize{
//    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:
//                             [NSArray arrayWithObject:self]];
//    
    // set navigation bar text color
//    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
//    [textAttributes setObject:[UIColor mainColor] forKey:NSForegroundColorAttributeName];
//    [item setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:self]];
    [navigationBar setBarTintColor:[UIColor mainColor]];
    [navigationBar setTintColor:[UIColor whiteColor]];
    
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
    [textAttributes setObject:[UIColor cloudsColor] forKey:NSForegroundColorAttributeName];

    [navigationBar setTitleTextAttributes:textAttributes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark---  Hide Tabbar when viewcontroller is not rootviewcontroller
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
