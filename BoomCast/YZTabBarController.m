//
//  YZTabBarController.m
//  BoomCast
//
//  Created by Yong Zeng on 11/23/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZTabBarController.h"
#import "UIColor+color.h"
#import "YZTabBar.h"
#import "YZNavigationController.h"
#import "YZLiveViewController.h"
#import "YZMomentsViewController.h"
#import "YZMessagesViewController.h"
#import "YZProfileViewController.h"
#import "YZPreLiveViewController.h"
#import <TSMessage.h>
#import <MBProgressHUD.h>
@import Firebase;
@import FirebaseAuth;
@import FirebaseStorage;

@interface YZTabBarController () <YZTabBarDelegate>

@property(strong, nonatomic) FIRDatabaseReference *databaseRef;
@property (strong, nonatomic) FIRStorageReference *storageRef;

@end

@implementation YZTabBarController

+ (void)initialize{
    // Get all TabBarItem appearence
    //UITabBarItem *item = [UITabBarItem appearance];
    
    // Get all tabBarItem from current class
//    UITabBarItem *item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:self]];
//    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
//    [textAttributes setObject:[UIColor mainColor] forKey:NSForegroundColorAttributeName];
//    [item setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
    
    UITabBar *tabBar = [UITabBar appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:self]];
    [tabBar setTintColor:[UIColor mainColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    [TSMessage setDefaultViewController:self];
    // [START configurestorage]
    self.storageRef = [[FIRStorage storage] reference];
    self.databaseRef = [[FIRDatabase database] reference];
    // [END configurestorage]
    [self loadData];
}

- (void)tabBarDidClickPlusBtn:(YZTabBar *)tabBar{
    YZPreLiveViewController *viewController = [[YZPreLiveViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - Set up child View controllers
- (void)setUpAllChildViewController{
    YZLiveViewController *liveViewController = [[YZLiveViewController alloc] init];
    [self setUpOneChildViewController:liveViewController
                                image:[UIImage imageNamed:@"live"]
                        selectedImage:[UIImage imageNamed:@"live_selected"]
                                title:@"Live"];
    
//    YZMomentsViewController *momentsViewController = [[YZMomentsViewController alloc] init];
//    momentsViewController.view.backgroundColor = [UIColor greenColor];
//    [self setUpOneChildViewController:momentsViewController
//                                image:[UIImage imageNamed:@"moments"]
//                        selectedImage:[UIImage imageNamed:@"moments_selected"]
//                                title:@"Moments"];
//    
//    YZMessagesViewController *messagesViewController = [[YZMessagesViewController alloc] init];
//    messagesViewController.view.backgroundColor = [UIColor orangeColor];
//    [self setUpOneChildViewController:messagesViewController
//                                image:[UIImage imageNamed:@"messages"]
//                        selectedImage:[UIImage imageNamed:@"messages_selected"]
//                                title:@"Messages"];
    
    YZProfileViewController *profileViewController = [[YZProfileViewController alloc] init];
    [self setUpOneChildViewController:profileViewController
                                image:[UIImage imageNamed:@"user"]
                        selectedImage:[UIImage imageNamed:@"user_selected"]
                                title:@"Me"];
}

- (void)setUpOneChildViewController:(UIViewController *)viewController
                              image:(UIImage *)image
                      selectedImage:(UIImage *)selectedImage
                              title:(NSString *)title{
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = image;
    //viewController.tabBarItem.badgeValue = @"10";
    viewController.tabBarItem.selectedImage = selectedImage;
    
    YZNavigationController *navigationController = [[YZNavigationController alloc]
                                                    initWithRootViewController:viewController];
    [self addChildViewController:navigationController];
}

- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // [START single_value_read]
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[[_databaseRef child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        YZLog(@"%@", snapshot);
        [User sharedInstance].uid = snapshot.key;
        [User sharedInstance].username = snapshot.value[@"username"];
        [User sharedInstance].email = snapshot.value[@"email"];
        [User sharedInstance].location = snapshot.value[@"location"];
        
        [[[_databaseRef child:@"user_follow"] child:snapshot.key] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            [User sharedInstance].followNumber = [NSNumber numberWithInteger:snapshot.children.allObjects.count];
        }];
        
        [[[_databaseRef child:@"user_follower"] child:snapshot.key] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            [User sharedInstance].followerNumber = [NSNumber numberWithInteger:snapshot.children.allObjects.count];
        }];
        
        [[[self.databaseRef child:@"user-broadcasts"] child:snapshot.key ] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            [User sharedInstance].broadcastNumber = [NSNumber numberWithInteger:snapshot.children.allObjects.count];
        }];
        
        [self setUpAllChildViewController];
        YZTabBar *tabBar = [[YZTabBar alloc] initWithFrame:self.tabBar.frame];
        tabBar.tabBarDelegate = self;
        tabBar.backgroundColor = [UIColor whiteColor];
        [self setValue:tabBar forKey:@"tabBar"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"file:%@/profileImage.jpg", documentsDirectory];
        NSString *storagePath = snapshot.value[@"profileImagePath"];
        if (![storagePath isEqualToString:@""]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[_storageRef child:storagePath]
             writeToFile:[NSURL URLWithString:filePath] completion:^(NSURL * _Nullable URL,
                                                                     NSError * _Nullable error) {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 if (error) {
                     return;
                 }
                 //YZLog(@"got image...");
                 NSData *data = [NSData dataWithContentsOfURL:URL];
                 [User sharedInstance].profileImage = [UIImage imageWithData:data];
             }];
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    // [END single_value_read]
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
