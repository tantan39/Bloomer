//
//  ContactListTableViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/25/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ContactListTableViewCell.h"

@implementation ContactListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self initCell];
}

-(void)initCell{
    _avatar.layer.cornerRadius = _avatar.frame.size.width / 2;
    _avatar.layer.borderWidth = 1;
    _avatar.layer.borderColor = [UIColor colorWithRed:0.784 green:0.812 blue:0.831 alpha:1.0].CGColor;
    _avatar.clipsToBounds = TRUE;
    
//    if(!_isChat){
//        [_chatButton setHidden:YES];
//    } else {
//        [_chatButton setHidden:NO];
//    }
}

-(void)prepareForReuse{
    [self initCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)touchAvatar:(id)sender {
    UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    view.uid = _uid;
    view.hidesBottomBarWhenPushed = FALSE;
    
    [_navigationController pushViewController:view animated:YES];
}

- (IBAction)touchChat:(id)sender {
    ChatViewController *view;
    view = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    
    view.uid = _uid;
    view.screen_name = _name.text;
    //    view.isBlock = profileData.is_block;
    //    view.blocker = profileData.blocker;
    view.receiverAvatar = _avatar;
    
    view.hidesBottomBarWhenPushed = TRUE;
    
    [self.navigationController pushViewController:view animated:TRUE];
}
@end
