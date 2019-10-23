//
//  ChangeGenderViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/28/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "profile_change_gender.h"
#import "UserDefaultManager.h"
#import "API_Profile_ChangingGender.h"
#import "out_profile_fetch.h"

@interface ChangesGenderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (assign, nonatomic) NSInteger gender;

- (IBAction)touchChange:(id)sender;

@end
