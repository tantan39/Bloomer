//
//  RewardsPopUpViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 10/6/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardsPopUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *popUpView;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)removeAnimate;
@end
