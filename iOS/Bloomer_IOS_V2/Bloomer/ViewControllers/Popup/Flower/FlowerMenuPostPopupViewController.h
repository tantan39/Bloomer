//
//  FlowerMenuPostPopupViewController.h
//  Xinh
//
//  Created by Truong Thuan Tai on 12/19/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "flower_give.h"
//#import "flower_give_using.h"
#import "out_flower_give.h"
#import "UserDefaultManager.h"
#import "face.h"
#import "DiscoveryViewController.h"

@protocol FlowerMenuPopupViewDelegate <NSObject>

- (void)didEndEditing:(NSInteger)nFlower isCanel:(BOOL)isCanel;

@end

@interface FlowerMenuPostPopupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *editorField;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UIView *popupView;

@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) face *faceData;
@property (assign, nonatomic) NSInteger uid;
@property (weak, nonatomic) NSString *postID;
@property (weak, nonatomic) NSString *key;
@property (weak, nonatomic) NSString *ckey;
@property (assign, nonatomic) BOOL isProfile;
@property BOOL isFirstRank;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)removeAnimate;

- (IBAction)closePopup:(id)sender;
- (IBAction)touchBackground:(id)sender;
- (IBAction)touchSendButton:(id)sender;

@property (weak, nonatomic) id<FlowerMenuPopupViewDelegate> delegate;

@end
