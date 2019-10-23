//
//  BuyFlowerConfirmViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/18/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "BuyFlowerSuccesfullViewController.h"

@interface BuyFlowerConfirmViewController : UIViewController

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@property (weak, nonatomic) IBOutlet UIView *mainView;
- (IBAction)touchNo:(id)sender;
- (IBAction)touchYes:(id)sender;

@end
