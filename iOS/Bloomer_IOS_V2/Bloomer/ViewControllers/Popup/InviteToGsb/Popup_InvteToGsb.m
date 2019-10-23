//
//  PopupForWinner.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/12/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "Popup_InvteToGsb.h"
#import "Support.h"
#import "AppDelegate.h"

@interface Popup_InvteToGsb ()
{
    NSString * myAvatar;
    NSString * myMessage;
}
@end

@implementation Popup_InvteToGsb

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.20];
    
    _CongratsLabel.text = NSLocalizedString(@"PopUpWinner.congrats", );
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPopupWithImageLink:(NSString *)url message:(NSString *)msg
{
    myMessage = msg;
    myAvatar = url;
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        if (animated) {
            [self showAnimate];
        }
    });
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1, 1);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1, 1);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
        [_WinnerImage setImageWithURL:[NSURL URLWithString:myAvatar]];
        
        _PopUp.layer.cornerRadius = 20;
        _NameWinner.text = myMessage;
    }];
}

- (IBAction)touchOutside:(id)sender {
    [self removeAnimate];
}

@end
