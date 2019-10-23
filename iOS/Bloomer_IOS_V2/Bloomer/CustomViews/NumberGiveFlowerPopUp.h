//
//  NumberGiveFlowerPopUp.h
//  Bloomer
//
//  Created by Tan Tan on 8/30/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "out_profile_fetch.h"
#import "out_content_post.h"
#import "UIImageView+Extension.h"
#import "UILabel+Extension.h"
@interface NumberGiveFlowerPopUp : UIView

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIView *flowerView;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labelUserFlower;
@property (weak, nonatomic) IBOutlet UILabel *labelOtherName;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UIImageView *otherAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labelOtherFlower;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yOffsetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) NSTimer *timerHiddenGiveFlower;


- (void) bindDataWithProfile:(out_profile_fetch *) profile Content:(out_content_post *) data;
- (void) showAnimateFromYOffset:(CGFloat) yOffset;
- (void) hiddenAnimation;


@end
