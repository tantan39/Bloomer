//
//  FlowerMenuPopUpViewController.h
//  Xinh
//
//  Created by Truong Thuan Tai on 12/8/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "flower_give.h"
//#import "flower_give_using.h"
#import "out_flower_give.h"
#import "UserDefaultManager.h"

@interface FlowerMenuPopUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *editorField;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;
@property (weak, nonatomic) IBOutlet UIView *popupView;

@property (weak, nonatomic) UIViewController *parentView;
@property (assign, nonatomic) NSInteger iRace;
@property NSInteger uid;
@property BOOL isFirstRank;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;

- (IBAction)closePopup:(id)sender;
- (IBAction)touchBackground:(id)sender;
- (IBAction)touchSendButton:(id)sender;

@end
