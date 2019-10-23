//
//  Spinner.m
//  Xinh
//
//  Created by Truong Thuan Tai on 12/19/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "Spinner.h"

@implementation Spinner
{
    UIImageView *spinnerView;
}

-(id)initWithFrame:(CGRect)frame Color:(UIColor*)color
{
    self = [super init];
    
    if(self)
    {
        [self setFrame:frame];
//        self.color = color;
//        self.transform = CGAffineTransformMakeScale(2.0, 2.0);
        
        spinnerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [spinnerView setCenter:CGPointMake(frame.size.width / 2, frame.size.height/2)];
        spinnerView.animationImages = [[self getAnimationImages] copy];
        spinnerView.animationDuration = 2;
        spinnerView.animationRepeatCount = 0;
        self.userInteractionEnabled = FALSE;
        
        [self addSubview:spinnerView];
    }
    
    return self;
}

- (void)startAnimating
{
    [spinnerView setHidden:FALSE];
    [spinnerView startAnimating];
    self.userInteractionEnabled = TRUE;
}

- (void)stopAnimating
{
    [spinnerView setHidden:TRUE];
    [spinnerView stopAnimating];
    self.userInteractionEnabled = FALSE;
}

- (NSMutableArray*)getAnimationImages
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 1; i < 26; i++)
    {
        NSString *path = [NSString stringWithFormat:@"spinner%ld.png",i];
        
        [images addObject:[UIImage imageNamed:path]];
        /*
        if (i + 1 > 0 && i + 1 < 10)
        {
            path = [NSString stringWithFormat:@"spinner0%ld.png", (long)i + 1];
        }
        else
            if (i + 1 >= 10 && i + 1 < 100)
            {
                path = [NSString stringWithFormat:@"spinner%ld.png", (long)i + 1];
            }
            else
            {
                path = [NSString stringWithFormat:@"spinner%ld.png", (long)i + 1];
            }
        
        [images addObject:[UIImage imageNamed:path]];
         */
    }
    
    return images;
}

@end
