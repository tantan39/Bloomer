//
//  NotificationPopup.m
//  Bloomer
//
//  Created by Tai Truong on 10/5/15.
//  Copyright © 2015 Glassegg. All rights reserved.
//

#define MAX_WIDTH 280
#define LABEL_FONT_NAME @"SourceSansPro"

#import "NotificationPopup.h"

@implementation NotificationPopup

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self setFrame:frame];
        
        self.backgroundColor = [UIColor whiteColor];
        
        CALayer *viewLayer = [self layer];
        [viewLayer setMasksToBounds:NO ];
        [viewLayer setShadowColor:[[UIColor lightGrayColor] CGColor]];
        [viewLayer setShadowOpacity:10.0];
        [viewLayer setShadowRadius:20.0];
        [viewLayer setShadowOffset:CGSizeMake(0, 0)];
        [viewLayer setShouldRasterize:NO];
        [viewLayer setCornerRadius:20.0];
        [viewLayer setBorderColor:[UIColor lightGrayColor].CGColor];
        [viewLayer setBorderWidth:0.0];
        [viewLayer setShadowPath:[UIBezierPath bezierPathWithRect:self.bounds].CGPath];
        
        _popupLabel = [[UILabel alloc] init];
        _popupLabel.textAlignment = NSTextAlignmentCenter;
        _popupLabel.numberOfLines = 0;
        _popupLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_popupLabel];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        CALayer *viewLayer = [self layer];
        [viewLayer setMasksToBounds:NO ];
        [viewLayer setShadowColor:[[UIColor lightGrayColor] CGColor]];
        [viewLayer setShadowOpacity:10.0];
        [viewLayer setShadowRadius:20.0];
        [viewLayer setShadowOffset:CGSizeMake(0, 0)];
        [viewLayer setShouldRasterize:NO];
        [viewLayer setCornerRadius:20.0];
        [viewLayer setBorderColor:[UIColor lightGrayColor].CGColor];
        [viewLayer setBorderWidth:0.0];
        [viewLayer setShadowPath:[UIBezierPath bezierPathWithRect:self.bounds].CGPath];
        
        _popupLabel = [[UILabel alloc] init];
        _popupLabel.textAlignment = NSTextAlignmentCenter;
        _popupLabel.numberOfLines = 0;
        _popupLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_popupLabel];
    }
    
    return self;
}

- (void)setLabelText:(NSString*)text
{
    _popupLabel.text = text;
    CGSize fittedSize = [_popupLabel sizeThatFits:CGSizeMake(MAX_WIDTH, CGFLOAT_MAX)];
    
    [_popupLabel setFrame:CGRectMake(0, 0, fittedSize.width, fittedSize.height)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, fittedSize.width, fittedSize.height)];
    
    CALayer *viewLayer = [self layer];
    [viewLayer setCornerRadius:self.frame.size.height / 2];
}

@end
