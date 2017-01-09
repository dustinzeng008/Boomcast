//
//  ResetPasswordViewController.m
//  BoomCast
//
//  Created by Yong Zeng on 12/7/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//
#import "ResetPasswordViewController.h"
#import <TSMessage.h>
#import "YZCircularTextField.h"
@import FirebaseAuth;

@interface ResetPasswordViewController ()

@property (strong, nonatomic) UIButton *btn_close;

@property (strong, nonatomic) UITextField *tf_email;
@property (strong, nonatomic) UIButton *btn_retrivePassword;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [TSMessage setDefaultViewController:self];
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background"]];
    self.view.backgroundColor = bgColor;
    
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
    YZCircularTextField *tf_email = [YZCircularTextField initWithX:marginX
                                                                 y:marginY + (componentHeight + 10)*1
                                                             width:componentWidth
                                                            height:componentHeight placeHolder:@"Email"];
    [self.view addSubview:tf_email];
    _tf_email = tf_email;
    tf_email.keyboardType = UIKeyboardTypeEmailAddress;
    
    // Initialize sign up button
    UIButton *btn_retrivePassword = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_retrivePassword.frame = CGRectMake(marginX,
                                  marginY + (componentHeight + 10)*2 + 30,
                                  componentWidth,
                                  componentHeight);
    [self.view addSubview:btn_retrivePassword];
    _btn_retrivePassword = btn_retrivePassword;
    btn_retrivePassword.layer.borderColor = [[UIColor whiteColor] CGColor];
    btn_retrivePassword.layer.borderWidth = 1.0f;
    btn_retrivePassword.layer.cornerRadius = 22.0f;
    btn_retrivePassword.layer.masksToBounds = YES;
    [btn_retrivePassword setTitle:@"Retrieve Password" forState:UIControlStateNormal];
    [btn_retrivePassword addTarget:self action:@selector(retrivePassword)
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

/****************************  Click login button  **************************/
- (void)retrivePassword{
    [[FIRAuth auth]
     sendPasswordResetWithEmail:_tf_email.text
     completion:^(NSError *_Nullable error) {
         if (error) {
             [TSMessage showNotificationWithTitle:@"Error"
                                         subtitle:error.localizedDescription
                                             type:TSMessageNotificationTypeError];
             
             return;
         }
     }];
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
