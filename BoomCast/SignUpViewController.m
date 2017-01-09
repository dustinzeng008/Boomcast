//
//  SignUpViewController.m
//  BoomCast
//
//  Created by Yong Zeng on 12/7/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "SignUpViewController.h"
#import "YZTool.h"
#import <MBProgressHUD.h>
#import "YZCircularTextField.h"
#import <TSMessage.h>
@import Firebase;
@import FirebaseAuth;

@interface SignUpViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) UIButton *btn_close;

@property (strong, nonatomic) YZCircularTextField *tf_username;
@property (strong, nonatomic) YZCircularTextField *tf_email;
@property (strong, nonatomic) YZCircularTextField *tf_location;
@property (strong, nonatomic) YZCircularTextField *tf_password;
@property (strong, nonatomic) YZCircularTextField *tf_confirmPassword;

@property (strong, nonatomic) UIButton *btn_signUp;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [TSMessage setDefaultViewController:self];
    _ref = [[FIRDatabase database] reference];
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background"]];
    self.view.backgroundColor = bgColor;
    [self initViews];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)deregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self deregisterFromKeyboardNotifications];
    
    [super viewWillDisappear:animated];
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
    
    // --------------------  Initialize username textfield  ---------------------
    YZCircularTextField *tf_username = [YZCircularTextField initWithX:marginX
                                                                 y:marginY + (componentHeight + 10)*0
                                                             width:componentWidth
                                                            height:componentHeight placeHolder:@"User Name"];
    [self.view addSubview:tf_username];
    _tf_username = tf_username;
    tf_username.returnKeyType = UIReturnKeyNext;
    tf_username.delegate = self;
    
    // --------------------  Initialize email textfield  ---------------------
    YZCircularTextField *tf_email = [YZCircularTextField initWithX:marginX
                                                                 y:marginY + (componentHeight + 10)*1
                                                             width:componentWidth
                                                            height:componentHeight placeHolder:@"Email"];
    [self.view addSubview:tf_email];
    _tf_email = tf_email;
    tf_email.returnKeyType = UIReturnKeyNext;
    tf_email.delegate = self;
    tf_email.keyboardType = UIKeyboardTypeEmailAddress;
    
    // --------------------  Initialize location textfield  ---------------------
    YZCircularTextField *tf_location = [YZCircularTextField initWithX:marginX
                                                                    y:marginY + (componentHeight + 10)*2
                                                                width:componentWidth
                                                               height:componentHeight placeHolder:@"Location"];
    [self.view addSubview:tf_location];
    _tf_location = tf_location;
    tf_location.returnKeyType = UIReturnKeyNext;
    tf_location.delegate = self;
    
    // ------------------  Initialize password textfield  --------------------
    YZCircularTextField *tf_password = [YZCircularTextField initWithX:marginX
                                                                    y:marginY + (componentHeight + 10)*3
                                                                width:componentWidth
                                                               height:componentHeight placeHolder:@"Password"];
    [self.view addSubview:tf_password];
    _tf_password = tf_password;
    tf_password.returnKeyType = UIReturnKeyNext;
    tf_password.delegate = self;
    [tf_password setSecureTextEntry:YES];
    
    // --------------  Initialize confirm password textfield  ----------------
    YZCircularTextField *tf_confirmPassword = [YZCircularTextField initWithX:marginX
                                                                    y:marginY + (componentHeight + 10)*4
                                                                width:componentWidth
                                                               height:componentHeight placeHolder:@"Confirm Password"];
    [self.view addSubview:tf_confirmPassword];
    _tf_confirmPassword = tf_confirmPassword;
    tf_confirmPassword.returnKeyType = UIReturnKeyNext;
    tf_confirmPassword.delegate = self;
    [tf_confirmPassword setSecureTextEntry:YES];
    
    // Initialize sign up button
    UIButton *btn_signUp = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_signUp.frame = CGRectMake(marginX,
                                 marginY + (componentHeight + 10)*5 + 30,
                                 componentWidth,
                                 componentHeight);
    [self.view addSubview:btn_signUp];
    _btn_signUp = btn_signUp;
    btn_signUp.layer.borderColor = [[UIColor whiteColor] CGColor];
    btn_signUp.layer.borderWidth = 1.0f;
    btn_signUp.layer.cornerRadius = 22.0f;
    btn_signUp.layer.masksToBounds = YES;
    [btn_signUp setTitle:@"Sign Up" forState:UIControlStateNormal];
    [btn_signUp addTarget:self action:@selector(clickSignUp) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Tap View to end edit /Tap view to hide keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

/**************************  Click signup button  ***************************/
- (void)clickSignUp{
    [self dismissKeyboard];
    //----------------  check if input correct information  -----------------
    
    if (self.tf_username.text.length == 0 || self.tf_email.text.length == 0 || self.tf_location.text.length == 0 ||
         self.tf_password.text.length == 0 || self.tf_confirmPassword.text.length == 0) {
        [TSMessage showNotificationWithTitle:@"Error"
                                    subtitle:@"Something is Empty!"
                                        type:TSMessageNotificationTypeError];
    }else if (![self.tf_password.text isEqualToString:self.tf_confirmPassword.text]) {
        [TSMessage showNotificationWithTitle:@"Error"
                                    subtitle:@"Password is Inconsistent!"
                                        type:TSMessageNotificationTypeError];
    }else{
        // [START create_user]
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[FIRAuth auth]
         createUserWithEmail:self.tf_email.text.lowercaseString
         password:self.tf_password.text
         completion:^(FIRUser *_Nullable user,
                      NSError *_Nullable error) {
             // [START_EXCLUDE]
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (error) {
                 [TSMessage showNotificationWithTitle:@"Error"
                                             subtitle:error.localizedDescription
                                                 type:TSMessageNotificationTypeError];

                 return;
             }
             // [END_EXCLUDE]
             //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
             // [START basic_write]
             NSDictionary *userInfo = @{@"username": [NSString trim:self.tf_username.text],
                                        @"email": [NSString trim:self.tf_email.text],
                                        @"location": [NSString trim:self.tf_location.text],
                                        @"profileImagePath": @""};
             [[[_ref child:@"users"] child:user.uid] setValue:userInfo];
             // [END basic_write]
             
         }];
        // [END create_user]
    }
}



/************************  Tap to dismiss keyboard  *************************/
- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)closeViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
/******************  When click return button on textfield  *****************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _tf_username) {
        [_tf_username becomeFirstResponder];
    }else if (textField == _tf_email){
        [_tf_email becomeFirstResponder];
    }else if (textField == _tf_password){
        [_tf_password becomeFirstResponder];
    }else if (textField == self.tf_confirmPassword){
        [self clickSignUp];
    }
    return YES;
}

- (void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    UITextField *currentTextField;
    if (self.tf_username.isFirstResponder) {
        currentTextField = self.tf_username;
    } else if (self.tf_email.isFirstResponder){
        currentTextField = self.tf_email;
    } else if (self.tf_location.isFirstResponder){
        currentTextField = self.tf_location;
    } else if (self.tf_password.isFirstResponder){
        currentTextField = self.tf_password;
    } else if (self.tf_confirmPassword.isFirstResponder){
        currentTextField = self.tf_confirmPassword;
    }
    
    //currentTextField.frame.origin.y +  currentTextField.frame.size.height
    CGFloat textFieldMaxY = CGRectGetMaxY(currentTextField.frame);
    CGFloat signUpMaxY = CGRectGetMaxY(_btn_signUp.frame);
    CGFloat confirmPasswordMaxY = CGRectGetMaxY(_tf_confirmPassword.frame);
    
    //get keyboard y
    CGRect keyboardEndFrame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardEndFrame.origin.y;
    
    CGFloat delta = keyboardY - textFieldMaxY - (signUpMaxY - confirmPasswordMaxY);
    if(delta < 0){ //move up
        [UIView animateWithDuration:0.25 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, delta);
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
