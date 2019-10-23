//
//  ChooseLocationTableViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/3/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ChooseLocationTableViewCell.h"

@implementation ChooseLocationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    if (selected) {
        [self.locationName setTextColor:[UIColor colorFromHexString:@"#B22225"]];
        [self.imgvSelected setHidden:false];
    }else{
        self.locationName.textColor = [UIColor colorFromHexString:@"#C7C7C7"];
        [self.imgvSelected setHidden:true];
    }
}



- (void)updateStatusSelected{
    [self setSelected:YES];
}

- (void)updateStatusDeSelected{
    [self setSelected:NO];
}

@end
