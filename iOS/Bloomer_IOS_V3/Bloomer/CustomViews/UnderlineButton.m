//
//  UnderlineButton.m
//  Bloomer
//
//  Created by Tran Thai Tan on 6/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "UnderlineButton.h"


@implementation UnderlineButton
@synthesize underLineView;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
//     Drawing code
    [super drawRect:rect];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUnderline];
    }
    
    return self;
}

-(void) setupUnderline{
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    
    underLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 6, textSize.width, 1)];
    [underLineView setBackgroundColor:self.titleLabel.textColor];
    [self addSubview:underLineView];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    activeColor = [UIColor colorFromHexString:@"#C7C7C7"];
    deactiveColor = self.titleLabel.textColor;
    if (highlighted) {
        [underLineView setBackgroundColor:activeColor];
    }else{
        [underLineView setBackgroundColor:deactiveColor];
    }
}

- (void) setStatusEnable:(BOOL) enable{
    if (enable) {
        [self setEnabled:YES];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.underLineView setBackgroundColor:[UIColor blackColor]];
        
    }else{
        [self setEnabled:NO];
        [self setTitleColor:[UIColor colorFromHexString:@"#C7C7C7"] forState:UIControlStateNormal];
        [self.underLineView setBackgroundColor:[UIColor colorFromHexString:@"#C7C7C7"]];
    }
}

@end
