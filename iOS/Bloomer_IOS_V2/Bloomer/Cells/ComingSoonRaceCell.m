//
//  ComingSoonRaceCell.m
//  Bloomer
//
//  Created by Tran Thai Tan on 9/27/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "ComingSoonRaceCell.h"

@implementation ComingSoonRaceCell

+ (CGFloat)cellHeight
{
    return 200;
}

+ (NSString*)cellIdentifier
{
    return @"ComingSoonRaceCell";
}

+ (NSString*)nibName
{
    return @"ComingSoonRaceCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.mainView.layer.borderColor = [UIColor colorFromHexString:@"#EFEFEF"].CGColor;
    self.mainView.layer.borderWidth = 1;
    self.mainView.layer.cornerRadius = 10;
    
}

@end
