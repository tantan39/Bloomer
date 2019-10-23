//
//  FlowerGiverCell.h
//  Bloomer
//
//  Created by Steven on 4/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowerGiverCell : UITableViewCell
    
+ (CGFloat) cellHeight;
+ (NSString*) cellIdentifier;
+ (NSString*) nibName;
    
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelFlower;
@property (weak, nonatomic) IBOutlet UILabel *labelBloomerMatched;

@end
