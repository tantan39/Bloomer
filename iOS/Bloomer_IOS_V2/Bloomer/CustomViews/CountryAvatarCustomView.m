//
//  CountryAvatarCustomView.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "CountryAvatarCustomView.h"

@interface CountryAvatarCustomView()

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation CountryAvatarCustomView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.gradientView.bounds;
    self.gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor colorWithWhite:0 alpha:0.7].CGColor];
    [self.gradientView.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gradientLayer.frame = self.gradientView.bounds;
}

- (void)setModel:(CountryAvatar *)model{
    if (model.urlAvatar) {
        [self.imgvAvatar setContentMode:UIViewContentModeScaleToFill];
        [self.imgvAvatar setImageWithURL:[NSURL URLWithString:model.urlAvatar]];
        [self.imgvAvatar setContentMode:UIViewContentModeScaleAspectFit];
    }
    
    self.lblDescription.text = model.name;
}

@end
