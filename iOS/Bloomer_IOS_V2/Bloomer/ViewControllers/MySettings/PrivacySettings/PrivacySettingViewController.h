//
//  PrivacySettingViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Private_ShareUpdate.h"
#import "UserDefaultManager.h"
#import "BlockListsViewController.h"

@interface PrivacySettingViewController : UIViewController 
@property (assign, nonatomic) BOOL share;
@property (weak, nonatomic) IBOutlet UISwitch *shareSwitch;
@property (weak, nonatomic) IBOutlet UILabel *labelSharePrivacy;
- (IBAction)touchShareSwitch:(id)sender;
- (IBAction)touchBlockList:(id)sender;

@end
