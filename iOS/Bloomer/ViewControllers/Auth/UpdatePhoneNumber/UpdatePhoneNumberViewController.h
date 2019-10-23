//
//  UpdatePhoneNumberViewController.h
//  Bloomer
//
//  Created by Steven on 3/7/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryPickerView.h"

@interface UpdatePhoneNumberViewController : UIViewController<CountryPickerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconFlag;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

- (IBAction)phoneNumberTextFieldEditingChanged:(id)sender;
- (IBAction)touchCountryFlagButton:(id)sender;

@end
