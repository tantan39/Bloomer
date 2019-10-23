//
//  ChatListTableViewCell.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/6/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface ChatListTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIImageView *notificationDot;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end
