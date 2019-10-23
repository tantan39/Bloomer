//
//  ChangeAboutMeViewController.h
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 12/11/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "out_profile_fetch.h"
#import "AppHelper.h"
#import "UserDefaultManager.h"
#import "API_Profile_UpdateStatus.h"
#import "AppDelegate.h"
#import "UITextView+Placeholder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangeAboutMeViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *aboutMeTV;
@property (strong, nonatomic) IBOutlet UILabel *lengAboutMeLabel;
@property (strong, nonatomic) out_profile_fetch *profileData;
@property (strong, nonatomic) void (^updateStatus)(NSString*);
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintTV;

@end

NS_ASSUME_NONNULL_END
