//
//  FlowerItemTableViewCell.m
//  Bloomer
//
//  Created by VanLuu on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "FlowerItemTableViewCell.h"
#import "NSNumber+Extension.h"

@implementation FlowerItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.HotLabel.layer.cornerRadius = self.HotLabel.frame.size.height / 2;
    self.HotLabel.layer.masksToBounds = YES;
    
    self.HotLabelNormal.layer.cornerRadius = self.HotLabelNormal.frame.size.height / 2;
    self.HotLabelNormal.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected)
    {
        [self.normalView setHidden:TRUE];
        [self.highlightView setHidden:FALSE];
    }
    else
    {
        [self.normalView setHidden:FALSE];
        [self.highlightView setHidden:TRUE];
    }
    // Configure the view for the selected state
}
-(void)prepareForReuse{
//    [self.normalView setHidden:FALSE];
//    [self.highlightView setHidden:TRUE];
    UILabel *lblnormal_Desc = (UILabel *)[_normalView viewWithTag:2];
    UILabel *lblhighlight_Desc = (UILabel *)[_highlightView viewWithTag:2];
    
    [lblnormal_Desc setHidden:NO];
    [lblhighlight_Desc setHidden:NO];
    [_iconaddImageView setHidden:NO];
    [_iconaddGreenImageView setHidden:NO];
}

-(void) initItemWithPaymentPackage:(payment_package*) paymentInfo
{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    [nf setLocale:[NSLocale currentLocale]];
    [nf setMaximumFractionDigits:2];
    
    UILabel *lblnormal_flowerNumner = (UILabel *)[_normalView viewWithTag:1];
    UILabel *lblhighlight_flowerNumner = (UILabel *)[_highlightView viewWithTag:1];
    NSString* sflower =[NSString stringWithFormat:NSLocalizedString(@"%@ Flowers", nil) , [[NSNumber numberWithDouble:paymentInfo.flower] formatWithLocale:[NSLocale currentLocale]]];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:sflower];
    
    if(_isEvent)
        [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@2 range:[sflower rangeOfString:sflower]];

    lblnormal_flowerNumner.attributedText = attributedString;
    lblhighlight_flowerNumner.attributedText = attributedString;
    
//    [lblnormal_flowerNumner setText:sflower];
//    [lblhighlight_flowerNumner setText:sflower];
    
    UILabel *lblnormal_Desc = (UILabel *)[_normalView viewWithTag:2];
    UILabel *lblhighlight_Desc = (UILabel *)[_highlightView viewWithTag:2];
    NSString* desc =[NSString stringWithFormat:NSLocalizedString(@"%@ Flowers",nil),paymentInfo.productDescription];
    [lblnormal_Desc setText:desc];
    [lblhighlight_Desc setText:desc];

    [_iconAddFlowerNormal setHidden:[paymentInfo.productDescription isEqualToString:@""]];
    [_iconAddFlowerHighlight setHidden:[paymentInfo.productDescription isEqualToString:@""]];

    UILabel *lblhighlight_money = (UILabel *)[_highlightView viewWithTag:3];
    UILabel *lblnormal_money = (UILabel *)[_normalView viewWithTag:3];
    NSString* sMoney =[NSString stringWithFormat:@"%@", [[NSNumber numberWithDouble:paymentInfo.money] formatWithCurrency:paymentInfo.currency]];
    [lblnormal_money setText:sMoney];
    [lblhighlight_money setText:sMoney];
    
    UILabel *lblhighlight_currency = (UILabel*)[_highlightView viewWithTag:4];
    UILabel *lblnormal_currency = (UILabel*)[_normalView viewWithTag:4];
    [lblhighlight_currency setText:paymentInfo.currency];
    [lblnormal_currency setText:paymentInfo.currency];
    
    [_HotLabel setHidden:!paymentInfo.isShot];
    [_HotLabelNormal setHidden:!paymentInfo.isShot];
    
    if(paymentInfo.isShot == true)
    {
        lblnormal_money.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:13.0f];
        lblnormal_flowerNumner.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:13.0f];
        lblhighlight_money.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:13.0f];
        lblhighlight_flowerNumner.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:13.0f];
        lblnormal_Desc.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:11.0f];
        lblhighlight_Desc.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:11.0f];
    }
    else
    {
        lblnormal_money.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:13.0f];
        lblnormal_flowerNumner.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:13.0f];
        lblhighlight_money.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:13.0f];
        lblhighlight_flowerNumner.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:13.0f];
        lblnormal_Desc.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:11.0f];
        lblhighlight_Desc.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:11.0f];
    }
    
    if([paymentInfo.productDescription isEqualToString:@""])
    {
        [lblnormal_Desc setHidden:YES];
        [lblhighlight_Desc setHidden:YES];
        [_iconaddImageView setHidden:YES];
        [_iconaddGreenImageView setHidden:YES];
    }
}

@end
