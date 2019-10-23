//
//  SuggestedPersonView.m
//  Bloomer
//
//  Created by Steven on 12/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "SuggestedPersonView.h"

@implementation SuggestedPersonView

+ (CGSize)viewSize
{
    return CGSizeMake(140, 185);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleView.layer.borderColor = [UIColor colorFromHexString:@"#E5E2E2"].CGColor;
    self.titleView.layer.borderWidth = 1;
}

@end
