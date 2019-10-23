//
//  PopUpTutorial.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/18/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "PopUpTutorial.h"
#import "NotificationViewController.h"

@interface PopUpTutorial ()
{
    UserDefaultManager* userDefaultManager;
}

@end

@implementation PopUpTutorial

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _OkButton.layer.cornerRadius = 20;
    _DontRemindButton.layer.cornerRadius = 20;
    [_OkButton setTitle:NSLocalizedString(@"TutorialOKButton.tittle", ) forState:UIControlStateNormal];
    [_DontRemindButton setTitle:NSLocalizedString(@"DontRemindMe.tittle", ) forState:UIControlStateNormal];

    userDefaultManager = [[UserDefaultManager alloc] init];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.70];

    _PopupContent.layer.cornerRadius = 20;
//
    NSString *sTut = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"GiveFlower_%@",NSLocalizedString(@"EN",nil)] ofType: @"gif"];
    NSData *dataTut = [NSData dataWithContentsOfFile: sTut];
    FLAnimatedImage *imgTut = [FLAnimatedImage animatedImageWithGIFData:dataTut];
    
    [_GifTut setAnimatedImage:imgTut];
//    ((FLAnimatedImageView*)_GifTut).debug_delegate = self;
    
//    [imgTut setLoopCount:0];
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

- (IBAction)TouchOk:(id)sender {
    [self removeAnimate];
}

- (IBAction)TouchDontRemind:(id)sender {
    [userDefaultManager didTutorialGiveFlowerRace:TRUE];
    [self removeAnimate];
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
    [UIView animateWithDuration:.4 animations:^{
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

    }];
    
}


@end
