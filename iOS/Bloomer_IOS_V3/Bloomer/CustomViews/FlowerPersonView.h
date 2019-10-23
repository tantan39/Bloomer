//
//  FlowerPersonView.h
//  Bloomer
//
//  Created by Steven on 3/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowerPersonView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelFlower;
@property (weak, nonatomic) IBOutlet UIView *othersView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end
