//
//  TabBarCameraCustomView.m
//  Bloomer
//
//  Created by Tan Tan on 11/23/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "TabBarCameraCustomView.h"

@implementation TabBarCameraCustomView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self customInit];
}

- (void) customInit{
    [[NSBundle mainBundle] loadNibNamed:@"TabBarCameraCustomView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    
//    self.imgvCamera.layer.cornerRadius = self.imgvCamera.bounds.size.width/2;
//    self.imgvCamera.clipsToBounds = YES;
    
}

@end
