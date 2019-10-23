//
//  ChangeCaptionViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/21/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Profile_UpdateStatus.h"
#import "UserDefaultManager.h"
#import "EditProfileViewController.h"

@interface ChangeCaptionViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
@property (weak, nonatomic) IBOutlet UILabel *charCountLabel;

@property (weak, nonatomic) NSString *caption;
@property (weak, nonatomic) UIViewController *parentView;

@end
