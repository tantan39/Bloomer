//
//  ShareRewardView.h
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 1/4/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppHelper.h"

@interface ShareRewardView : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *MessageDisappearLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFlower;
@property (weak, nonatomic) IBOutlet UILabel *YouReceive;
@property (weak, nonatomic) IBOutlet UILabel *numFlowerLabel;

- (void)showInView:(UIView*)view animated:(BOOL)animated andNumberFlower:(NSInteger)num;

@end
