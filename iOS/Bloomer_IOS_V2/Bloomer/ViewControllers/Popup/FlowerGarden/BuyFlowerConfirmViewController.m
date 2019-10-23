//
//  BuyFlowerConfirmViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/18/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "BuyFlowerConfirmViewController.h"

@interface BuyFlowerConfirmViewController () {
    BuyFlowerSuccesfullViewController *popupSuccess;;
}

@end

@implementation BuyFlowerConfirmViewController

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
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.58];
    
    _mainView.layer.cornerRadius = 20;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(closePopup)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (void)closePopup {
    [self removeAnimate];
}
- (IBAction)touchNo:(id)sender {
    [self removeAnimate];
}
- (IBAction)touchYes:(id)sender {
    [self removeAnimate];
    popupSuccess = [[BuyFlowerSuccesfullViewController alloc] initWithNibName:@"BuyFlowerSuccesfullViewController" bundle:nil];
    popupSuccess.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
    [popupSuccess showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}
@end
