//
//  InviteCodeViewController.h
//  Bloomer
//
//  Created by Steven on 12/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "API_GetInviteCode.h"
//#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface InviteCodeViewController : UIViewController<FBSDKSharingDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelCode;
@property (weak, nonatomic) IBOutlet UIButton *buttonSendInviteCode;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;

- (IBAction)touchButtonSendInviteCode:(id)sender;

@end
