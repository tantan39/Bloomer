//
//  ChangeLocationViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/27/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Profile_Location.h"
#import "UserDefaultManager.h"
#import "EditProfileViewController.h"

@interface ChangeLocationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) NSString *locationReceived;
@property (assign, nonatomic) NSInteger locationID;
@property (weak, nonatomic) UIViewController *parentView;
- (IBAction)touchChange:(id)sender;

@end
