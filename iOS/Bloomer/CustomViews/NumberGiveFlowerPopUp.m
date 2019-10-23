//
//  NumberGiveFlowerPopUp.m
//  Bloomer
//
//  Created by Tan Tan on 8/30/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "NumberGiveFlowerPopUp.h"

@implementation NumberGiveFlowerPopUp

- (instancetype)initWithFrame:(CGRect)frame{
     self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void) setupView{
    [[[NSBundle mainBundle] loadNibNamed:@"NumberGiveFlowerPopUp" owner:self options:nil] objectAtIndex:0];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];

    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.height / 2;
    self.userAvatar.layer.borderColor = [UIColor colorFromHexString:@"#E4E4E4"].CGColor;
    self.userAvatar.layer.borderWidth = 3;
    self.userAvatar.clipsToBounds = true;
    
    self.otherAvatar.layer.cornerRadius = self.otherAvatar.frame.size.height / 2;
    self.otherAvatar.layer.borderColor = [UIColor colorFromHexString:@"#E4E4E4"].CGColor;
    self.otherAvatar.layer.borderWidth = 3;
    self.otherAvatar.clipsToBounds = true;
    
    self.mainView.layer.cornerRadius = 20;
    self.mainView.clipsToBounds = true;
    
    self.flowerView.clipsToBounds = true;
    self.flowerView.layer.shadowColor = [UIColor colorFromHexString:@"#A0A0A0"].CGColor;
    self.flowerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.flowerView.layer.shadowOpacity = 0.5;

}

- (void)bindDataWithProfile:(out_profile_fetch *)profile Content:(out_content_post *)data{
    [self.userAvatar setImageWithAnimationFromURL:[NSURL URLWithString:profile.avatar] placeHolder:nil];
    self.labelUserName.text = profile.name;
    [self.labelUserFlower setFlowers:data.mygiveflower imageString:@"Icon_Flower_Black"];
    self.labelOtherName.text = @"Other Users";
    [self.labelOtherFlower setFlowers:data.flower - data.mygiveflower imageString:@"Icon_Flower_Black"];
}

- (void)showAnimateFromYOffset:(CGFloat)yOffset{
    self.yOffsetConstraint.constant = yOffset - self.heightConstraint.constant;
     [self layoutIfNeeded];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [self setAlpha:0];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setAlpha:1];
    } completion:  ^(BOOL finished){
        if(finished) {
            [self setUpTimerHidden];
        }
    }];
    
    
}

- (void) setUpTimerHidden {
    self.timerHiddenGiveFlower = [NSTimer scheduledTimerWithTimeInterval:2.5
                                                             target:self
                                                           selector:@selector(hiddenAnimation)
                                                           userInfo:nil
                                                            repeats:NO];
}
- (void) handleTapGesture:(UIGestureRecognizer *) gesture{
    [self hiddenAnimation];
}
- (void) hiddenAnimation {
    if (self.timerHiddenGiveFlower != nil) {
        [self.timerHiddenGiveFlower invalidate];
        self.timerHiddenGiveFlower = nil;
    }
    
    [self setAlpha:0];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self removeFromSuperview];
    } completion:nil];
    
}
     
@end
