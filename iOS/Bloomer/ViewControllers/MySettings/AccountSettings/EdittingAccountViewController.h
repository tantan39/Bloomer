//
//  EdittingAccountViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/21/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"
#import "CountryPickerView.h"

@protocol EdittingAccountViewControllerDelegate<NSObject>

@optional
- (void)didUpdateEmail:(NSString*)email;
- (void)didUpdatePhone:(NSString*)phone;
- (void)didUpdateBirthday:(NSString*)birthday;
- (void)didUpdateGender:(NSInteger)gender;

@end

@interface EdittingAccountViewController : UIViewController <UITextFieldDelegate, CountryPickerDelegate>

@property (weak, nonatomic) id <EdittingAccountViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet TextFieldValidator *textfieldContent;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *character;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *birthdayButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIImageView *iconFlag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countryViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;

- (IBAction)touchBirthdayButton:(id)sender;
- (IBAction)datePickerChanged:(id)sender;

@property (weak, nonatomic) NSString *nameText;
@property (weak, nonatomic) NSString *emailText;
@property (weak, nonatomic) UIViewController *parentView;
@property (assign, nonatomic) NSInteger change;
@property (weak, nonatomic) NSString *phoneText;
@property (assign, nonatomic) NSInteger country_id;
@property (weak, nonatomic) NSString *birthday;

@end

