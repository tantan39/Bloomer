//
//  ChangeStatusPopUpViewController.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 3/22/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "API_Profile_UpdateStatus.h"
#import "UserDefaultManager.h"
#import "EditProfileViewController.h"

@interface ChangeStatusPopUpViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) UIViewController *parentView;

@property (weak, nonatomic) IBOutlet UITextView *textData;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *statusName;

- (void)showInView:(UIView *)aView andData:(NSString*) stringData animated:(BOOL)animated;

@end
