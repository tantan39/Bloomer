//
//  ThankYou.m
//  Bloomer
//
//  Created by VanLuu on 8/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ThankYou.h"

@implementation ThankYou
{
    NSInteger popupStyle;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void) repositionToPoint:(CGPoint)point{
    switch ([self popupStyle]) {
        case ThankYouStyleForTableViewCell:{
            [self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
            break;
        }
        case ThankYouStyleForCollectionViewCell:{
           [self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
            break;
        }
        case ThankYouStyleForProfile:{
            [self setFrame:CGRectMake(point.x, point.y - self.frame.size.height, self.frame.size.width, self.frame.size.height)];
            break;
        }
        case ThankYouStyleForBloomerProfile:{
            [self setFrame:CGRectMake(point.x, point.y-self.frame.size.height, self.frame.size.width, self.frame.size.height)];
            break;
        }
        case ThankYouStyleForTopBloomerProfile:{
            [self setFrame:CGRectMake(point.x, point.y + self.frame.size.height -10, self.frame.size.width, self.frame.size.height)];
            break;
        }
    }
    
}

-(void) updatePotistion:(CGPoint)point andFrame:(CGRect)frame{
    switch ([self popupStyle]) {
        case ThankYouStyleForTableViewCell:{
            [self setFrame:CGRectMake(point.x, point.y, frame.size.width, frame.size.height)];
            break;
        }
        case ThankYouStyleForCollectionViewCell:{
            [self setFrame:CGRectMake(point.x, point.y, frame.size.width, frame.size.height)];
            break;
        }
        case ThankYouStyleForProfile:{
            [self setFrame:CGRectMake(point.x, point.y - frame.size.height, frame.size.width, frame.size.height)];
            break;
        }
        case ThankYouStyleForBloomerProfile:{
            [self setFrame:CGRectMake(point.x, point.y - frame.size.height, frame.size.width, frame.size.height)];
            break;
        }
    }
    
}

- (void)createAtPoint:(CGPoint)point andFrame:(CGRect)frame{
    switch ([self popupStyle]) {
        case ThankYouStyleForTableViewCell:{
            UIImageView* background =  [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"rec_ThankYou"]];
//            self = [super initWithFrame:CGRectMake(point.x  , point.y - background.frame.size.height, background.frame.size.width, background.frame.size.height)];
            [self setFrame:CGRectMake(point.x  , point.y - background.frame.size.height, background.frame.size.width, background.frame.size.height)];
            [self addSubview:background];
            
            UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, self.frame.size.width, self.frame.size.height)];
            content.text = THANK_YOU_CONTENT;
            [content setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:THANK_YOU_FONT_SIZE]];
            content.textAlignment = NSTextAlignmentCenter;
            content.textColor = [UIColor whiteColor];
            [content setBackgroundColor:[UIColor clearColor]];
            
            [self addSubview:content];
            break;
        }
        case ThankYouStyleForCollectionViewCell:{
            UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/3*2, self.frame.size.width, self.frame.size.height/3)];
            content.text = THANK_YOU_COLLECTION_CELL_CONTENT;
            [content setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:THANK_YOU_FONT_SIZE]];
            content.textAlignment = NSTextAlignmentCenter;
            content.numberOfLines = 0;
            content.lineBreakMode = NSLineBreakByWordWrapping;
            content.textColor = [UIColor whiteColor];
            [content setBackgroundColor:[UIColor clearColor]];
            //    [content setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
            //add smile icon
            UILabel *smile = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            smile.text = THANK_YOU_SMILE_CONTENT;
            [smile setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:THANK_YOU_SMILE_FONT_SIZE]];
            smile.textAlignment = NSTextAlignmentCenter;
            [smile setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f]];
            
            [self addSubview:smile];
            [self addSubview:content];
//            self.autoresizesSubviews= YES;
            break;
        }
        case ThankYouStyleForProfile:{
            UIImageView* background =  [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"rec_ThankYou"]];
//            self = [super initWithFrame:CGRectMake(point.x  , point.y - background.frame.size.height, background.frame.size.width, background.frame.size.height)];
            //    [self setFrame:CGRectMake(point.x  , point.y - self.frame.size.height, self.frame.size.width, self.frame.size.height)];
            [self setFrame:CGRectMake(point.x  , point.y - background.frame.size.height, background.bounds.size.width, background.frame.size.height)];
            [self addSubview:background];
            
            UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, self.frame.size.width, self.frame.size.height)];
            content.text = THANK_YOU_CONTENT;
            [content setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:THANK_YOU_FONT_SIZE]];
            content.textAlignment = NSTextAlignmentCenter;
            content.textColor = [UIColor whiteColor];
            [content setBackgroundColor:[UIColor clearColor]];
            
            [self addSubview:content];
            break;
        }
    }
    }

- (id)initWithStyle:(NSInteger)style atPoint:(CGPoint)point{
    return [self initWithStyle:style atPoint:point frame:CGRectZero];
}

    
- (id)initWithStyle:(NSInteger)style atPoint:(CGPoint)point frame:(CGRect)frame{
    [self setPopupStyle: style];
    switch ([self popupStyle]) {
        case ThankYouStyleForBloomerProfile:{
            return [self initForProfileTableCellViewAtPoint:point];
            break;
        }
        case ThankYouStyleForTableViewCell:{
            return [self initForRaceViewAtPoint:point];
            break;
        }
        case ThankYouStyleForCollectionViewCell:{
            return [self initForCollectionViewCellViewAtPoint:point frame:frame];
            break;
        }
        case ThankYouStyleForProfile:{
            return [self initForProfileViewAtPoint:point];
            break;
        }
        case ThankYouStyleForTopBloomerProfile:{
            return [self initForProfileTopTableCellViewAtPoint:point];
            break;
        }
    }
    
    return self;
}
- (id)initForRaceViewAtPoint:(CGPoint)point{
//    UIImageView* background =  [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"rec_ThankYou@2x"]];
//    self = [super initWithFrame:CGRectMake(point.x  , point.y - background.frame.size.height, background.frame.size.width, background.frame.size.height)];
//    [self addSubview:background];
    self = [super initWithImage: [UIImage imageNamed:@"rec_ThankYou"]];
    [self setFrame:CGRectMake(point.x  , point.y, self.frame.size.width, self.frame.size.height)];
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, self.frame.size.width, self.frame.size.height)];
    content.text = THANK_YOU_CONTENT;
    [content setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:THANK_YOU_FONT_SIZE]];
    content.textAlignment = NSTextAlignmentCenter;
    content.textColor = [UIColor whiteColor];
    [content setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:content];
    
    return self;
}

- (id)initForProfileTableCellViewAtPoint:(CGPoint)point{
    self = [super initWithImage: [UIImage imageNamed:@"rec_ThankYou"]];

    [self setFrame:CGRectMake(point.x  , point.y - self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, self.frame.size.width, self.frame.size.height)];
    content.text = THANK_YOU_CONTENT;
    [content setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:THANK_YOU_FONT_SIZE]];
    content.textAlignment = NSTextAlignmentCenter;
    content.textColor = [UIColor whiteColor];
    [content setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:content];
    
    return self;
}

- (id)initForProfileTopTableCellViewAtPoint:(CGPoint)point{
    self = [super initWithImage: [UIImage imageNamed:@"rec_ThankYou"]];
    self.image = [UIImage imageWithCGImage:self.image.CGImage scale:1.0 orientation:UIImageOrientationDownMirrored];
    
    [self setFrame:CGRectMake(point.x  , point.y + self.frame.size.height - 10, self.frame.size.width, self.frame.size.height)];
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    content.text = THANK_YOU_CONTENT;
    [content setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:THANK_YOU_FONT_SIZE]];
    content.textAlignment = NSTextAlignmentCenter;
    content.textColor = [UIColor whiteColor];
    [content setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:content];
    
    return self;
}

- (id)initForCollectionViewCellViewAtPoint:(CGPoint)point frame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(point.x, point.y, frame.size.width, frame.size.height)];
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/3*2, self.frame.size.width, self.frame.size.height/3)];
    content.text = THANK_YOU_COLLECTION_CELL_CONTENT;
    [content setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:THANK_YOU_FONT_SIZE]];
    content.textAlignment = NSTextAlignmentCenter;
    content.numberOfLines = 0;
    content.lineBreakMode = NSLineBreakByWordWrapping;
    content.textColor = [UIColor whiteColor];
    [content setBackgroundColor:[UIColor clearColor]];
//    [content setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    //add smile icon
    UILabel *smile = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    smile.text = THANK_YOU_SMILE_CONTENT;
    [smile setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:THANK_YOU_SMILE_FONT_SIZE]];
    smile.textAlignment = NSTextAlignmentCenter;
    [smile setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f]];
    [self addSubview:smile];
    [self addSubview:content];
    
    return self;
}

- (id)initForProfileViewAtPoint:(CGPoint)point{
   
//    UIImageView* background =  [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"rec_ThankYou@2x"]];
//    self = [super initWithFrame:CGRectMake(point.x  , point.y - background.frame.size.height, background.frame.size.width, background.frame.size.height)];
    //    [self addSubview:background];
     self = [super initWithImage: [UIImage imageNamed:@"rec_ThankYou"]];
    [self setFrame:CGRectMake(point.x  , point.y - self.frame.size.height, self.frame.size.width, self.frame.size.height)];

    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, self.frame.size.width, self.frame.size.height)];
    content.text = THANK_YOU_CONTENT;
    [content setFont:[UIFont fontWithName:DEFAULT_FONT_NAME size:THANK_YOU_FONT_SIZE]];
    content.textAlignment = NSTextAlignmentCenter;
    content.textColor = [UIColor whiteColor];
    [content setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:content];
    return self;
}
    
- (NSInteger)popupStyle {
    return popupStyle;
}

- (void)setPopupStyle:(NSInteger)newValue {
    popupStyle = newValue;
}


-(void)clear{
    for (UIView* subview in self.subviews) {
        [subview removeFromSuperview];
    }
}
@end
