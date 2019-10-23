//
//  PopUpTopWinners.h
//  Bloomer
//
//  Created by Steven on 1/3/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpTopWinners : UIView<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;

@property (weak, nonatomic) UIView *ownerView;
@property (weak, nonatomic) UINavigationController *navigationController;

- (IBAction)touchCloseButton:(id)sender;

+ (id)createInView:(UIView*)view topWinners:(NSMutableArray*)topWinners flowers:(NSInteger)flowers navigation:(UINavigationController*) navigationController;
- (void)showWithAnimated:(BOOL)animated;

@end
