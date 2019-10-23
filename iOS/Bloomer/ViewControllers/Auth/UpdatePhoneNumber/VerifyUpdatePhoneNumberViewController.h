//
//  VerifyUpdatePhoneNumberViewController.h
//  Bloomer
//
//  Created by Steven on 3/8/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyUpdatePhoneNumberViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *getAudioCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *resendCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *codeLabels;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewCenterY;
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;
@property (assign, nonatomic) BOOL linkWithExistedPhone;

@property (strong, nonatomic) NSString* phoneNumber;

- (IBAction)verifyCodeTextFieldEditingChanged:(id)sender;
- (IBAction)touchResendCodeButton:(id)sender;
- (IBAction)touchGetAudioCodeButton:(id)sender;
- (IBAction)touchCompleteButton:(id)sender;

- (void)setVerifyCodeNumber:(NSString*)verifyCodeNumber;

@end
