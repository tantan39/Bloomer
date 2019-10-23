//
//  ChatTableViewCellRight.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/1/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "ChatTableViewCellRight.h"

@implementation ChatTableViewCellRight

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setupViews];
}

//- (void)prepareForReuse{
//    [super prepareForReuse];
//    [self setupViews];
//}

- (void) setupViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bubbleView.layer.cornerRadius = 10;
    self.bubbleView.clipsToBounds = TRUE;
    [_time setText:@""];
    [_arrowImageView setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)configCellWithMessage:(message *)message StickerList:(NSMutableDictionary *)stickers{
    if (message) {
        self.message = message;
        self.stickerList = stickers;
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
    self.labelTimePaddingConstraint.constant = self.contentView.bounds.size.width - self.imgvEmoji.frame.origin.x + 16;
}

- (void) configtForText{
    [self.imgvEmoji setHidden:YES];
    [self.arrowImageView setHidden : NO];
    [self.lblMessage setHidden:NO];
    [self.bubbleView setHidden:NO];
    self.lblMessage.text = self.message.body;
    CGFloat labelWidth = self.lblMessage.intrinsicContentSize.width;
    self.labelTimePaddingConstraint.constant = self.contentView.bounds.size.width - (self.contentView.bounds.size.width - labelWidth - 10 - 12 - 16) + 12;
    
}

@end
