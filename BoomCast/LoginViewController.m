//
//  LoginViewController.m
//  BoomCast
//
//  Created by Yong Zeng on 12/7/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//
#import "LoginViewController.h"
#import "YZTabBarController.h"
#import "ResetPasswordViewController.h"
#import "SignUpViewController.h"
#import <MBProgressHUD.h>
#import "YZCircularTextField.h"
#import <TSMessage.h>
@import FirebaseAuth;

@interface LoginViewController () <UITextFieldDelegate>

@property (strong, nonatomic) YZCircularTextField *tf_Email;
@property (strong, nonatomic) YZCircularTextField *tf_Password;
@property (strong, nonatomic) UIButton *btn_Login;
@property (strong, nonatomic) UIButton *btn_ForgetPassword;
@property (strong, nonatomic) UIButton *btn_SignUp;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [TSMessage setDefaultViewController:self];
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background"]];
    self.view.backgroundColor = bgColor;
    [self initViews];
}

/************************  Initialize view content  *************************/
- (void)initViews{
    CGFloat marginX = 20;
    CGFloat marginY = 100;
    CGFloat componentWidth = KDeviceWidth - marginX*2;
    CGFloat componentHeight = 44;
    
    // --------------------  Initialize email textfield  ---------------------
    YZCircularTextField *tf_Email = [YZCircularTextField initWithX:marginX
                                                                y:marginY + (componentHeight + 10)*0
                                                            width:componentWidth
                                                           height:componentHeight placeHolder:@"Email"];
    [self.view addSubview:tf_Email];
    _tf_Email = tf_Email;
    tf_Email.delegate = self;
    tf_Email.keyboardType = UIKeyboardTypeEmailAddress;
    
    // ------------------  Initialize password textfield  --------------------
    YZCircularTextField *tf_Password = [YZCircularTextField initWithX:marginX
                                                                 y:marginY + (componentHeight + 10)*1
                                                             width:componentWidth
                                                            height:componentHeight placeHolder:@"Password"];
    [self.view addSubview:tf_Password];
    _tf_Password = tf_Password;
    tf_Password.delegate = self;
    [tf_Password setSecureTextEntry:YES];
    
    // ---------------------------  Broadcast login   -----------------------------
    UIButton *btn_Login = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Login.frame = CGRectMake(marginX,
                                 marginY + (componentHeight + 10)*2 + 30,
                                 componentWidth,
                                 componentHeight);
    [self.view addSubview:btn_Login];
    _btn_Login = btn_Login;
    btn_Login.layer.borderColor = [[UIColor whiteColor] CGColor];
    btn_Login.layer.borderWidth = 1.0f;
    btn_Login.layer.cornerRadius = 22.0f;
    btn_Login.layer.masksToBounds = YES;
    [btn_Login setTitle:@"Log in" forState:UIControlStateNormal];
    [btn_Login addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // ----------------  Initialize forget password button  ------------------
    UIButton *btn_ForgetPassword=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_ForgetPassword setFrame:CGRectMake(marginX,
                                             marginY + (componentHeight + 10)*3 + 30,
                                             componentWidth/2,
                                             componentHeight)];
    [self.view addSubview:btn_ForgetPassword];
    _btn_ForgetPassword = btn_ForgetPassword;
    btn_ForgetPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn_ForgetPassword setTitle:@"Forget Password" forState:UIControlStateNormal];
    [btn_ForgetPassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[[_btn_ForgetPassword titleLabel] setFont:[UIFont boldSystemFontOfSize:18]];
    [btn_ForgetPassword addTarget:self action:@selector(forgetPasswordClick)
                  forControlEvents:UIControlEventTouchUpInside];
    
    
    // --------------------  Initialize sign up button  ----------------------
    UIButton *btn_SignUp=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_SignUp setFrame:CGRectMake(marginX + componentWidth/2,
                                     marginY + (componentHeight + 10)*3 + 30,
                                     componentWidth/2,
                                     componentHeight)];
    [self.view addSubview:btn_SignUp];
    _btn_SignUp = btn_SignUp;
    btn_SignUp.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn_SignUp setTitle:@"Sign Up" forState:UIControlStateNormal];
    [btn_SignUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[[_btn_SignUp titleLabel] setFont:[UIFont boldSystemFontOfSize:18]];
    [btn_SignUp addTarget:self action:@selector(signUpClick)
          forControlEvents:UIControlEventTouchUpInside];
    
    
    // ----------  Tap View to end edit /Tap view to hide keyboard  ----------
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}


/****************************  Click login button  **************************/
- (void)loginClick{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // [START headless_email_auth]
    [[FIRAuth auth] signInWithEmail:_tf_Email.text
                           password:_tf_Password.text
                         completion:^(FIRUser *user, NSError *error) {
                             // [START_EXCLUDE]
                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                             if (error) {
                                 [TSMessage showNotificationWithTitle:@"Error"
                                                             subtitle:error.localizedDescription
                                                                 type:TSMessageNotificationTypeError];
                                 return;
                             }
                             // [END_EXCLUDE]
                         }];
    // [END headless_email_auth]
    
}


/*********************  Click forgetpassword button  ************************/
- (void)forgetPasswordClick{
    ResetPasswordViewController *resetPasswordViewController =
                                    [[ResetPasswordViewController alloc] init];
    [self presentViewController:resetPasswordViewController animated:YES completion:nil];
//    [self.navigationController pushViewController:resetPasswordViewController
//                                         animated:YES];
}


/**************************  Click signup button  ***************************/
- (void)signUpClick{
    SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
    [self presentViewController:signUpViewController animated:YES completion:nil];
//    [self.navigationController pushViewController:signUpViewController
//                                         animated:YES];
}


/*************************  Tap to dismiss keyboard  ************************/
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}


#pragma mark - UITextFieldDelegate
/*****************  When click return button on textfield  ******************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _tf_Email) {
        [_tf_Password becomeFirstResponder];
    }else if (textField == _tf_Password){
        [self loginClick];
    }
    return YES;
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
