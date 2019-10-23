//
//  Support.m
//  Bloomer
//
//  Created by VanLuu on 8/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "Support.h"

@implementation Support
#pragma mark - SUPPORT
//+ (NSString *)md5:(NSString *)input {
//    return [jsonAbstractClass md5:input];
//}

- (NSString *)daySuffixForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger dayOfMonth = [calendar component:NSCalendarUnitDay fromDate:date];
    switch (dayOfMonth) {
        case 1:
        case 21:
        case 31: return @"st";
        case 2:
        case 22: return @"nd";
        case 3:
        case 23: return @"rd";
        default: return @"th";
    }
}

+ (NSString *)suffixForRank:(NSInteger)rank {
    NSString* formattedRank = @(rank).stringValue;
    switch (rank) {
        case 1:
        case 21:
        case 31: return [NSString stringWithFormat:@"%@st",formattedRank];
        case 2:
        case 22: return [NSString stringWithFormat:@"%@nd",formattedRank];
        case 3:
        case 23: return [NSString stringWithFormat:@"%@rd",formattedRank];
        default: return [NSString stringWithFormat:@"%@th",formattedRank];
    }
}

+(UILabel*) formatLabel:(UILabel*)label raceName:(NSString*)name status:(NSInteger)status{
    //    NSString* formattedName = @"";
    switch (status) {
        case RACE_ACTIVE: // active -> normal
        {
            [label setTextColor:[UIColor blackColor]];
            [label setText:name];
            break;
        }
        /*case RACE_LEFT: // left -> middleline
        {
            NSAttributedString * title =
            [[NSAttributedString alloc] initWithString:name
                                            attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
            [label setTextColor:[UIColor lightGrayColor]];
            [label setAttributedText:title];
            
            break;
        }*/
        case RACE_CLOSED: // closed -> (CLOSED)
        {
            [label setTextColor:[UIColor lightGrayColor]];
            [label setText:[NSString stringWithFormat:@"    %@" ,name]];
            break;
        }
        case RACE_LEFT: // closed -> (CLOSED)
        {
            [label setTextColor:[UIColor lightGrayColor]];
            [label setText:[NSString stringWithFormat:@"    %@" ,name]];
            break;
        }
        default:
            break;
    }
    return label;
    //    return formattedName;
}

+ (float)calculateLabelHeight:(NSString*)text font:(UIFont*)font lineBreakMode:(NSLineBreakMode)mode
{
    return [self calculateLabelHeight:text font:font lineBreakMode:mode maxWidth:242];
}

+ (float)calculateLabelHeight:(NSString*)text font:(UIFont*)font lineBreakMode:(NSLineBreakMode)mode maxWidth:(float)maxWidth
{
    if (SYSTEM_VERSION_LESS_THAN(@"7")){
        CGSize maximumLabelSize = CGSizeMake(maxWidth, FLT_MAX);
        CGSize expectedLabelSize = [text sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:mode];
        
        return expectedLabelSize.height;
    } else {
        NSAttributedString *attributedText =
        [[NSAttributedString alloc] initWithString:text
                                        attributes:@{NSFontAttributeName: font}];
        CGRect expectedLabelSize = [attributedText boundingRectWithSize:(CGSize){maxWidth, CGFLOAT_MAX}
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                                context:nil];
        return expectedLabelSize.size.height;
    }
}


+(void) addErrorMessage:(NSString*) error intoView:(UIView*)view{
    ErrorMessageView* messView = [[ErrorMessageView alloc]initWithMessage:error];
    [view addSubview:messView];
}



    

@end
