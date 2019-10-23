//
//  ConfirmationPopupViewController.m
//  Bloomer
//
//  Created by VanLuu on 7/13/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ConfirmationPopupViewController.h"
#import "UserDefaultManager.h"
@interface ConfirmationPopupViewController ()

@end

@implementation ConfirmationPopupViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (SYSTEM_VERSION_LESS_THAN(@"7"))
        {
            CGRect frame = self.view.frame;
            frame.size.height += 20;
            self.view.frame = frame;
        }
        if(IS_IPHONE_4)
        {
            CGRect frame = self.view.frame;
            frame.size.height -= DELTA_IPHONE_4;
            self.view.frame = frame;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.70];
    _lblContent.layer.cornerRadius = 20;
    _btnCancel.layer.cornerRadius = 12;
    _btnOK.layer.cornerRadius = 12;
    
    [_lblContent setText:[NSString stringWithFormat:NSLocalizedString(@"You are switching to\n\n%@ Contest!",),_raceName]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
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

- (IBAction)onTouchCancel:(id)sender {
    [self removeAnimate];
}
- (IBAction)onTouchOK:(id)sender {
    [self removeAnimate];
    [self.delegate didConfirmationPopupOK:_locationID];
}

@end
