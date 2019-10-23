//
//  FlowerPersonView.m
//  Bloomer
//
//  Created by Steven on 3/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "FlowerPersonView.h"
#import "UIColor+Extension.h"

@implementation FlowerPersonView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height / 2;
    self.avatar.layer.borderColor = [UIColor colorFromHexString:@"#D8D8D8"].CGColor;
    self.avatar.layer.borderWidth = 1;
    self.avatar.clipsToBounds = true;
    
    self.othersView.layer.cornerRadius = self.othersView.frame.size.height / 2;
    self.othersView.layer.borderColor = [UIColor colorFromHexString:@"#B22225"].CGColor;
    self.othersView.layer.borderWidth = 2;
    self.othersView.clipsToBounds = true;
}

@end
