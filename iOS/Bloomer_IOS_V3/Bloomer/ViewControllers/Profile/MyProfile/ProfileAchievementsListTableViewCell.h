//
//  ProfileAchievementsListTableViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/24/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Support.h"
#import "UIColor+Extension.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define FIRST_RANK 0xf5a625
#define SECOND_RANK 0x85cf32
#define THIRD_RANK 0x20b0d2

@interface ProfileAchievementsListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Dot;
@property (weak, nonatomic) IBOutlet UILabel *NameRank;
@property (weak, nonatomic) IBOutlet UILabel *Rank;
@property (weak, nonatomic) IBOutlet UILabel *BigTitle;
@property (weak, nonatomic) IBOutlet UIImageView *LinkWeb;
@property (weak, nonatomic) IBOutlet UIImageView *Lock;
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UIImageView *Flowers;
@property (weak, nonatomic) IBOutlet UILabel *FlowerQuantity;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundheaderView;

-(void) setUpType0:(NSString*) Name rank:(NSString*) rank;
-(void) setUpType1:(NSString*) Name flowers:(NSString*) quantityF;
-(void) setUpType2:(NSString*) Name;
-(void) setUpType3:(NSString*) Name;


@end
