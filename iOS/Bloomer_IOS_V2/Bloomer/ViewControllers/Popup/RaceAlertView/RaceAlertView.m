//
//  RaceAlertView.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/23/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "RaceAlertView.h"
#import "AppDelegate.h"

@interface RaceAlertView () {
    AppDelegate *appDelegate;
}

@end

@implementation RaceAlertView

-(instancetype)initWithMessage:(NSString*)message gsb:(NSInteger)gsb {
    self = [self init];
    if(self) {
        _message.text = message;
        [_fullMessage setHidden:YES];
        switch (gsb) {
            case 1:
                _trophyImage.image = [UIImage imageNamed:@"Icon_Trophy_Bronze"];
                break;
            case 7:
                _trophyImage.image = [UIImage imageNamed:@"Icon_Trophy_Silver"];
                break;
            case 28:
                _trophyImage.image = [UIImage imageNamed:@"Icon_Trophy_Gold"];
                break;
            default:
                break;
        }
    }
    return self;
}

-(instancetype)initWithMessage:(NSString *)message {
    self = [self init];
    if(self) {
        _fullMessage.text = message;
        [_fullMessage setHidden:NO];
    }
    return self;
}

-(instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"RaceAlertView" owner:self options:nil] objectAtIndex:0];
    if(self) {
        self.frame = [UIScreen mainScreen].bounds;
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    _dialogView.layer.cornerRadius = 20;
}

-(void)show {
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    self.alpha = 0;
    _dialogView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        _dialogView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)close {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        _dialogView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        if(finished) {
            [self removeFromSuperview];
        }
    }];
}

- (IBAction)touchViewMore:(id)sender {
    [AppDelegate setSelectedIndexTabbar:4];
    MyProfileViewController *myprofileVC = appDelegate.tabBarView.getMyProfileVC;
    [myprofileVC TouchAchievement:nil];
    [self close];
}

- (IBAction)touchLater:(id)sender {
    [self close];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self close];
}
@end
