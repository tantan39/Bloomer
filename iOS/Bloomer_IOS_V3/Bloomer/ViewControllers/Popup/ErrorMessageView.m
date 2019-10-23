//
//  ErrorMessageView.m
//  Bloomer
//
//  Created by VanLuu on 9/7/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ErrorMessageView.h"
#import "Support.h"

@implementation ErrorMessageView

-(id) initWithMessage:(NSString*)content{
    CGFloat height = IS_IPHONE_X ? 65 : 45;
    self = [super initWithFrame:CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width, height)];
    self.backgroundColor = [UIColor blackColor];
    
    CGFloat heightLabel = 30;
    CGRect frameLable = IS_IPHONE_X ? CGRectMake(0, self.bounds.size.height - heightLabel, self.bounds.size.width, heightLabel) : self.bounds;
    UILabel *messLabel = [[UILabel alloc] initWithFrame:frameLable];
    messLabel.backgroundColor = [UIColor clearColor];
    messLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:12];
    messLabel.textColor = [UIColor whiteColor];
    messLabel.textAlignment = NSTextAlignmentCenter;
    [messLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [messLabel setNumberOfLines:0];
    messLabel.text = content;
    
    [self addSubview:messLabel];
    
    [NSTimer scheduledTimerWithTimeInterval:ERROR_MESSAGE_DURATION
                                     target:self
                                   selector:@selector(removeErrorMessage:)
                                   userInfo:@{@"param" : self}
                                    repeats:FALSE];
    return self;
}

- (void)removeErrorMessage:(NSTimer *)timer {
    UIView* messView = timer.userInfo[@"param"];
    [messView removeFromSuperview];
}

@end
