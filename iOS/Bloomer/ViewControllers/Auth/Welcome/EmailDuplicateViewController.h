//
//  EmailDuplicateViewController.h
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 12/4/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmailDuplicateViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) NSString * message;
@property (assign,nonatomic) UINavigationController *navicontroller;
- (IBAction)touchSignIn:(id)sender;
- (IBAction)touchCancel:(id)sender;

@end

NS_ASSUME_NONNULL_END
