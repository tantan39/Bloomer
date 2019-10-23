//
//  ReportChatPopUpViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "block_add.h"
#import "API_BlockAdd.h"

@interface ReportChatPopUpViewController : UIViewController
@property (assign, nonatomic) NSInteger uid;
@property (weak, nonatomic) UIViewController *parentView;
- (IBAction)touchCancelButton:(id)sender;
- (IBAction)touchBlockButton:(id)sender;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@end
