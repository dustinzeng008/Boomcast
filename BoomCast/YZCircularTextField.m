//
//  YZCircularTextField.m
//  BoomCast
//
//  Created by Yong Zeng on 12/7/16.
//  Copyright © 2016 Yong Zeng. All rights reserved.
//

#import "YZCircularTextField.h"

@implementation YZCircularTextField

+ (instancetype)initWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
              placeHolder:(NSString *)placeHolder{
    YZCircularTextField *textField = [[self alloc] init];
    textField.frame = CGRectMake(x, y, width, height);
    textField.layer.borderColor = [[UIColor whiteColor] CGColor];
    textField.layer.borderWidth = 1.0f;
    textField.layer.cornerRadius = height / 2;
    textField.layer.masksToBounds=YES;
    textField.leftView = [[UIView alloc]
                         initWithFrame:CGRectMake(0, 0, 12, height)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.returnKeyType = UIReturnKeyNext;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textColor = [UIColor whiteColor];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
