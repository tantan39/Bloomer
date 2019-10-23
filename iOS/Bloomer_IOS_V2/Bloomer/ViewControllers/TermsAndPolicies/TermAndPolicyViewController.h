//
//  TermAndPolicyViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/7/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TermAndPolicyViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) NSString* urlString;
@property (assign, nonatomic) BOOL isTerm;
- (IBAction)touchBackButton:(id)sender;

@end
