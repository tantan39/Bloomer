//
//  DiscoveryPopupViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/21/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "ChoosingLocationViewController.h"
#import "DiscoveryViewController.h"

#import "city.h"

@interface DiscoveryPopupViewController : UIViewController

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)showAnimate;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *genderButton;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

- (IBAction)touchDone:(id)sender;
- (IBAction)touchFemale:(id)sender;
- (IBAction)touchMale:(id)sender;
- (IBAction)touchGender:(id)sender;
- (IBAction)touchChange:(id)sender;

@property (weak, nonatomic) UIViewController *parentView;

@end
