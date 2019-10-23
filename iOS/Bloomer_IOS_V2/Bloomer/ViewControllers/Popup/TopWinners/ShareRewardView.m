//
//  ShareRewardView.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 1/4/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "ShareRewardView.h"

@interface ShareRewardView ()

@end

@implementation ShareRewardView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _numFlower.transform = CGAffineTransformMakeRotation(M_PI * 350 / 180.0);
    _YouReceive.text = [AppHelper getLocalizedString:@"YouReceived.label"];
    _MessageDisappearLabel.text =[AppHelper getLocalizedString:@"disappearMessageRewardShare.label"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showInView:(UIView*)view animated:(BOOL)animated andNumberFlower:(NSInteger)num {
    dispatch_async(dispatch_get_main_queue(), ^{
        [view addSubview:self.view];
        _numFlower.text = [@(num) stringValue];
        _numFlowerLabel.text = [NSString stringWithFormat: NSLocalizedString(@"numberFlowerReward.label", ), (long)num];
        if(animated) {
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
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self removeAnimate];
        });
        
    }];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
