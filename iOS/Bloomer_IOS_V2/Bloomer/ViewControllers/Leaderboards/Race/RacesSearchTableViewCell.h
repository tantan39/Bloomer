//
//  RacesSearchTableViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/13/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RacesSearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;

+ (NSString *)cellIdentifier;

@end
