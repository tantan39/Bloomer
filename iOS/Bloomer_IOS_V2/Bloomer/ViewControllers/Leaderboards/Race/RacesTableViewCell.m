//
//  RacesTableViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/27/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "RacesTableViewCell.h"
#import "MessagePopupRacesViewController.h"
#import "UIColor+Extension.h"

@implementation RacesTableViewCell {
    MessagePopupRacesViewController *popup;
}

+ (NSString *)cellIdentifier {
    return @"RacesTableViewCell";
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _avatar.layer.cornerRadius = _avatar.frame.size.height / 2;
    _avatar.layer.borderWidth = 1;
    _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatar.clipsToBounds = TRUE;
    
    self.avatarRoundView.layer.cornerRadius = self.avatarRoundView.frame.size.height / 2;
    self.avatarRoundView.clipsToBounds = true;
}

-(void)prepareForReuse
{
    _avatar.image = nil;
    _name.textColor = UIColorFromRGB(0x545454);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setVideoLink:(NSString *)link {
    self.link = link;
    [self.TopRankImage setHidden:link == nil || [link isEqualToString:@""]];
}

- (IBAction)touchMessage:(id)sender {
    [self showUpBubbleViewWithMessage];
}

- (void)showUpBubbleViewWithMessage
{
        popup = [[MessagePopupRacesViewController alloc] initWithNibName:@"MessagePopupRacesViewController" bundle:nil];
        popup.number = @(_cellIndex.row + 1).stringValue;
        popup.distance =  _cellIndex.row * 80 + 232 - _tableView.contentOffset.y;
        popup.message = _message;
        popup.name = _name.text;
        popup.username = _username.text;
        popup.numberFlower = _numFlower.text;
        popup.avatarImage = _avatar.image;
        
        [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}

- (IBAction)ButtonForTopRank:(id)sender {
    if([self.link isEqualToString:@""]) return;
    
    BrowserViewController *browserview = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
    browserview.urlString = self.link;
    browserview.hidesBottomBarWhenPushed = true;
    [self.MyNavigationController pushViewController:browserview animated:true];
}

- (void)showUpBubbleView:(BOOL) isHide
{
    popup = [[MessagePopupRacesViewController alloc] initWithNibName:@"MessagePopupRacesViewController" bundle:nil];
    popup.number = _number.text;
    if(isHide == true)
    {
        popup.distance =  _cellIndex.row * 80 + 193 - _tableView.contentOffset.y;
    }
    else
    {
        popup.distance =  _cellIndex.row * 80 + 237 - _tableView.contentOffset.y;
    }
    popup.message = @"";
    popup.name = _name.text;
    popup.username = _username.text;
    popup.numberFlower = _numFlower.text;
    popup.uid = _uid;
    popup.avatarString = _avatarString;
    popup.MyNavigationController = _MyNavigationController;
    popup.parentView = _parentView;
    
    [popup.BubbleBlueMessage setHidden:true];
    [popup.TriangularBubblePart setHidden:true];
    [popup.messageLabel setHidden: true];
    
    popup.isSurpriseFunc = true;
    
    [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}

- (void)switchStyleForAvatarBorderViewWithMedal:(NSString*)medal isIcon:(BOOL)isIcon
{
    if(isIcon) {
        self.avatarSquareView.backgroundColor = [UIColor colorFromHexString:@"#d22225"];
        self.avatarRoundView.backgroundColor = [UIColor colorFromHexString:@"#d22225"];
        return;
    } else {
        if ([medal isEqualToString:@"G"])
        {
            self.avatarSquareView.backgroundColor = [UIColor colorFromHexString:@"#E4A821"];
            self.avatarRoundView.backgroundColor = [UIColor colorFromHexString:@"#E4A821"];
            return;
        }
        
        if ([medal isEqualToString:@"S"])
        {
            self.avatarSquareView.backgroundColor = [UIColor colorFromHexString:@"#8A8C9D"];
            self.avatarRoundView.backgroundColor = [UIColor colorFromHexString:@"#8A8C9D"];
            return;
        }
        
        if ([medal isEqualToString:@"B"])
        {
            self.avatarSquareView.backgroundColor = [UIColor colorFromHexString:@"#9F7C66"];
            self.avatarRoundView.backgroundColor = [UIColor colorFromHexString:@"#9F7C66"];
            return;
        }
        
        if ([medal isEqualToString:@""] || medal == nil)
        {
            self.avatarSquareView.backgroundColor = [UIColor clearColor];
            self.avatarRoundView.backgroundColor = [UIColor clearColor];
            return;
        }
    }
}

@end
