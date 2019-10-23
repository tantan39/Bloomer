//
//  MatchingFlowerPopUpView.h
//  Bloomer
//
//  Created by Steven on 9/29/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchingFlowerPopUpView : UIView

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *labelTop;
//@property (weak, nonatomic) IBOutlet UILabel *labelBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewWidth;
@property (weak, nonatomic) IBOutlet UIImageView *iconBonusMultiplier;

@property (weak, nonatomic) UIView *ownerView;

+ (id)createInView:(UIView*)view flowers:(NSInteger)flowers;
- (void)showWithAnimated:(BOOL)animated;

@end
