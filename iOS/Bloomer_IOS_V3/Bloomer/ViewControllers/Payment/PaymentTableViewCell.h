//
//  PaymentTableViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 10/21/15.
//  Copyright © 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *flower;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *vnd;
@property (weak, nonatomic) IBOutlet UIImageView *normalBackground;
@property (weak, nonatomic) IBOutlet UIImageView *selectedBackground;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;

@end
