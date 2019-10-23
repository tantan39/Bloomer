//
//  FlowerItemTableViewCell.h
//  Bloomer
//
//  Created by VanLuu on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "payment_package.h"

@interface FlowerItemTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet UIView *highlightView;
@property (weak, nonatomic) IBOutlet UIImageView *iconaddImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconaddGreenImageView;
@property (weak, nonatomic) IBOutlet UILabel *HotLabel;
@property (weak, nonatomic) IBOutlet UILabel *HotLabelNormal;
@property (weak, nonatomic) IBOutlet UIImageView *iconAddFlowerNormal;
@property (weak, nonatomic) IBOutlet UIImageView *iconAddFlowerHighlight;
@property (assign, nonatomic) bool isEvent;

-(void) initItemWithPaymentPackage:(payment_package*) paymentInfo;

@end
