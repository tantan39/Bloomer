//
//  SettingsEditViewController.h
//  Xinh
//
//  Created by Truong Thuan Tai on 12/10/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenderTableViewCell.h"
#import "out_profile_fetch.h"
#import "UserDefaultManager.h"

@interface SettingsEditViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *nameView;
@property (strong, nonatomic) IBOutlet UIView *emailView;
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UIView *genderView;
@property (weak, nonatomic) out_profile_fetch *profileData;
@property (weak, nonatomic) IBOutlet UITextField *nameEditor;
@property (weak, nonatomic) IBOutlet UITextField *emailEditor;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property int viewType;
- (IBAction)emailEditingDidEnd:(id)sender;
- (IBAction)datePickerValueChanged:(id)sender;
@end
