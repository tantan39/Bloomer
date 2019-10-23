//
//  UITextField+Extension.m
//  Bloomer
//
//  Created by Tran Thai Tan on 6/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

- (void)addLeftPaddingView{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, self.bounds.size.height)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)addRightPaddingView{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, self.bounds.size.height)];
    self.rightView = paddingView;
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (BOOL)validateDisplayName{
    NSString *passwordRegex = @"^.{1,20}$";
    
    NSPredicate *password = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    NSString * trimText = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [password evaluateWithObject:trimText] ? YES : NO;
}

- (BOOL) validatePhoneNumber{
    NSString *phoneRegex = @"^[0-9]{7,11}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    NSString * phoneNumb = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    phoneNumb = [[phoneNumb componentsSeparatedByCharactersInSet:
                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                 componentsJoinedByString:@""];
    
    return [phoneTest evaluateWithObject:phoneNumb] ? YES : NO;
}

- (BOOL)validatePassword{
//    NSString *passwordRegex = @"^.*((?=.*[A-Za-z])|(?=.*\\d)|(?=.*[$@$!%*#?&]))(?=.{6,20}).*$";
    NSString *passwordRegex = @"^.{6,20}$";

    NSPredicate *password = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [password evaluateWithObject:self.text] ? YES : NO;
}

- (BOOL) validateEmail {
    NSString *emailRegex = @"^[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *email = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [email evaluateWithObject:self.text] ? YES : NO;
}

- (BOOL)validateBirthday{
//    NSDate * date = [NSString sring]
    return YES;
}

- (void)setupUnderline{
    CALayer * underlineLayer = [CALayer layer];
    CGFloat borderWidth = 1;
    underlineLayer.borderColor = [UIColor colorFromHexString:@"#EDEDED"].CGColor;
    underlineLayer.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
    underlineLayer.borderWidth = borderWidth;
    [self.layer addSublayer:underlineLayer];
    self.layer.masksToBounds = YES;
}

- (void) setupPasswordUnderline{
    
    CALayer * underlineLayer = [CALayer layer];
    CGFloat borderWidth = 1;
    underlineLayer.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.bounds.size.width, self.bounds.size.height);
    underlineLayer.borderWidth = borderWidth;
    underlineLayer.borderColor = [UIColor colorFromHexString:@"#545454"].CGColor;
    [self.layer addSublayer:underlineLayer];
    self.layer.masksToBounds = YES;
}

@end
