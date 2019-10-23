//
//  UITextField+Extension.h
//  Bloomer
//
//  Created by Tran Thai Tan on 6/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
@interface UITextField (Extension)

- (void) addLeftPaddingView;
- (void) addRightPaddingView;

- (BOOL) validateDisplayName;

- (void) setupUnderline;
- (void) setupPasswordUnderline;
-(BOOL) validatePhoneNumber;
- (BOOL)validatePassword;
- (BOOL) validateEmail;
- (BOOL) validateBirthday;

@end
