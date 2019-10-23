//
//  ChatTableViewCellLeft.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/1/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "ChatTableViewCellLeft.h"
#import "UserDefaultManager.h"

@implementation ChatTableViewCellLeft

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupViews];
}

- (void) setupViews{
    self.bubbleView.layer.cornerRadius = 10;
    self.bubbleView.clipsToBounds = TRUE;
    _avatar.layer.cornerRadius = _avatar.frame.size.width / 2;
    _avatar.layer.borderWidth = 2;
    _avatar.layer.borderColor = [UIColor grayColor].CGColor;
    _avatar.clipsToBounds = TRUE;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_time setText:@""];
    [_arrowImageView setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)configCellWithMessage:(message *)message Avatar:(UIImage *) avatar StickerList:(NSMutableDictionary *)stickers{
    if (message) {
        self.message = message;
        self.avatar.image = avatar;
        self.stickerList = stickers;
        self.userID = message.sender_id;
        
        switch (message.resource) {
            case RES_TYPE_STICKER:
                [self configForSticker];
                break;
                
            default:
                [self configtForText];
                break;
        }
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:message.timestamp/1000.0];
        if (message.sent == 1){
            self.time.text = [NSString stringFromDate:date WithFormat:@"hh:mm"];
        }
    }
}

- (void) configForSticker{
    NSString* iconName = (NSString*)[self.stickerList objectForKey:self.message.body];
    [self.imgvEmoji setImage:[UIImage imageNamed:iconName]];
    [self.imgvEmoji setHidden:NO];
    [self.arrowImageView setHidden : YES];
    [self.lblMessage setHidden:YES];
    [self.bubbleView setHidden:YES];
    self.labelTimePaddingConstraint.constant = 6 + self.avatar.bounds.size.width + 10 + self.arrowImageView.bounds.size.width + self.imgvEmoji.bounds.size.width + 12;
}

- (void) configtForText{
    [self.imgvEmoji setHidden:YES];
    [self.arrowImageView setHidden : NO];
    [self.lblMessage setHidden:NO];
    [self.lblMessage sizeToFit];
    [self.bubbleView setHidden:NO];
    self.lblMessage.text = self.message.body;
    CGFloat labelWidth = self.lblMessage.intrinsicContentSize.width;
    self.labelTimePaddingConstraint.constant = 6 + self.avatar.bounds.size.width + 10 + self.arrowImageView.bounds.size.width + labelWidth + 16 + 12;
    
}

- (IBAction)touchAvatar:(id)sender
{
    if (self.userID) {
        UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
        view.uid = self.userID;
        
        [self.navigationController popToRootViewControllerAnimated:false];
        [self.navigationController pushViewController:view animated:TRUE];
    }
}

@end
