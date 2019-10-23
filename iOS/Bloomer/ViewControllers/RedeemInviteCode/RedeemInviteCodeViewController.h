//
//  RedeemInviteCodeViewController.h
//  Bloomer
//
//  Created by Steven on 12/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "API_VerifyInviteCode.h"

@interface RedeemInviteCodeViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *dismissKBGesture;
@property (weak, nonatomic) IBOutlet UIView *expireView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expireViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *expireLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCode;
@property (weak, nonatomic) IBOutlet UIButton *buttonRedeemCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewCenterYConstraint;

@property (strong, nonatomic) NSString *code;

@property (copy,nonatomic) void (^RedeemmInviteCodeFailure)();
@property (assign, nonatomic) BOOL redeemInviteCodeSuccess;

@end
