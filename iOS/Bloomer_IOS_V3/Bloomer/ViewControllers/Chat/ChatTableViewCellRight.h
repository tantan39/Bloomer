//
//  ChatTableViewCellRight.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/1/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "message.h"
#import "message_send.h"
#import "NSString+Extension.h"
@interface ChatTableViewCellRight : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *chatView;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIView *bubbleView;
@property (weak, nonatomic) IBOutlet UIImageView *imgvEmoji;

@property (strong,nonatomic) message * message;
@property (strong,nonatomic) NSMutableDictionary * stickerList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTimePaddingConstraint;

- (void) configCellWithMessage:(message *) message StickerList:(NSMutableDictionary *) stickers;

@end
