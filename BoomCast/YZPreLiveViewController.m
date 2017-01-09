//
//  YZPreLiveViewController.m
//  BoomCast
//
//  Created by Yong Zeng on 12/14/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZPreLiveViewController.h"
#import "YZLiveRoomViewController.h"
#import "YZCircularTextField.h"
#import <TSMessage.h>

@interface YZPreLiveViewController ()

@property (strong, nonatomic) UIButton *btn_close;

@property (strong, nonatomic) UITextField *tf_broadCastTitle;
@property (strong, nonatomic) UIButton *btn_BeginBroadCast;

@end

@implementation YZPreLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background"]];
    self.view.backgroundColor = bgColor;
    [TSMessage setDefaultViewController:self];
    [self initViews];
}

/*************************  Initialize view content  ************************/
- (void)initViews{
    CGFloat marginX = 20;
    CGFloat marginY = 100;
    CGFloat componentWidth = KDeviceWidth - marginX*2;
    CGFloat componentHeight = 44;
    
    // ------------------------ Initialize close button -------------------------
    UIButton *btn_close = [[UIButton alloc] initWithFrame:CGRectMake(KDeviceWidth - componentHeight - marginX,
                                                                     20,
                                                                     componentHeight,
                                                                     componentHeight)];
    [self.view addSubview:btn_close];
    _btn_close = btn_close;
    [btn_close setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [btn_close addTarget:self action:@selector(closeViewController) forControlEvents:UIControlEventTouchUpInside];
    
    // --------------------  Initialize email textfield  ---------------------
    YZCircularTextField *tf_broadCastTitle = [YZCircularTextField initWithX:marginX
                                                                 y:marginY + (componentHeight + 10)*1
                                                             width:componentWidth
                                                            height:componentHeight placeHolder:@"Broadcast Title"];
    [self.view addSubview:tf_broadCastTitle];
    _tf_broadCastTitle = tf_broadCastTitle;
    
    // Initialize sign up button
    UIButton *btn_BeginBroadCast = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_BeginBroadCast.frame = CGRectMake(marginX,
                                           marginY + (componentHeight + 10)*2 + 30,
                                           componentWidth,
                                           componentHeight);
    [self.view addSubview:btn_BeginBroadCast];
    _btn_BeginBroadCast = btn_BeginBroadCast;
    btn_BeginBroadCast.layer.borderColor = [[UIColor whiteColor] CGColor];
    btn_BeginBroadCast.layer.borderWidth = 1.0f;
    btn_BeginBroadCast.layer.cornerRadius = 22.0f;
    btn_BeginBroadCast.layer.masksToBounds = YES;
    [btn_BeginBroadCast setTitle:@"Begin Broadcast" forState:UIControlStateNormal];
    [btn_BeginBroadCast addTarget:self action:@selector(beginBroadCast)
                  forControlEvents:UIControlEventTouchUpInside];
    
    // ----------  Tap View to end edit /Tap view to hide keyboard  ----------
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

/*************************  Tap to dismiss keyboard  ************************/
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)closeViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)beginBroadCast{
    if ([self.tf_broadCastTitle.text isEqual:@""]) {
        [TSMessage showNotificationWithTitle:@"Error"
                                    subtitle:@"Please input broadcast title"
                                        type:TSMessageNotificationTypeError];
    } else {
        //[self closeViewController];
        
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//        }];
        YZLiveRoomViewController *liveVC = [[YZLiveRoomViewController alloc] init];
        liveVC.userName = [User sharedInstance].username;
        liveVC.broadcastTitle = self.tf_broadCastTitle.text;
        liveVC.videoProfile = AgoraRtc_VideoProfile_480P;
        liveVC.clientRole = AgoraRtc_ClientRole_Broadcaster;
        [self presentViewController:liveVC animated:YES completion:nil];
        
    }
    
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
