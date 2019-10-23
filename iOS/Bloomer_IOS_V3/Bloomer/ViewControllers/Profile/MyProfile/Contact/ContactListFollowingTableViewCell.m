//
//  ContactListFollowingTableViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/25/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ContactListFollowingTableViewCell.h"

@implementation ContactListFollowingTableViewCell {
    UIAlertView *unF;
    UserDefaultManager *userDefaultManager;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    userDefaultManager = [[UserDefaultManager alloc] init];
    [self initCell];
}

-(void)initCell{
    _avatar.layer.cornerRadius = _avatar.frame.size.width / 2;
    _avatar.layer.borderWidth = 1;
    _avatar.layer.borderColor = [UIColor colorWithRed:0.784 green:0.812 blue:0.831 alpha:1.0].CGColor;
    _avatar.clipsToBounds = TRUE;
    _followerButton.layer.cornerRadius = 13;
    _unFollowerButton.layer.cornerRadius = 13;
    
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

- (IBAction)touchUnFollow:(id)sender {
    unF = [[UIAlertView alloc] initWithTitle:nil
                                     message:NSLocalizedString(@"Are you sure you want to unfollow this user?",nil)
                                    delegate:self
                           cancelButtonTitle:NSLocalizedString(@"No",)
                           otherButtonTitles:NSLocalizedString(@"Yes",nil), nil];
    [unF show];
}

- (IBAction)touchAvatar:(id)sender {
    UserProfileViewController *view;
    view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    view.uid = _userID;
    view.hidesBottomBarWhenPushed =FALSE;
    [_navigationController pushViewController:view animated:YES];
}
- (IBAction)touchFollow:(id)sender {
    block_remove *param = [[block_remove alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:_uid];
    if (param) {
        API_ReFollow *api = [[API_ReFollow alloc] initWithParams:param];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status)
            {
                ContactListViewController *view = (ContactListViewController *)_parentView;
                [view updateFollowing:TRUE userID:_uid];
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == unF) {
        if (buttonIndex == 1) {
            block_remove *param = [[block_remove alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:_uid];
            
            if (param) {
                API_UnFollow *api = [[API_UnFollow alloc] initWithParams:param];
                [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                    if (response.status)
                    {
                        ContactListViewController *view = (ContactListViewController *)_parentView;
                        [view updateFollowing:FALSE userID:_uid];
                    }
                    else
                    {
                        [AppHelper showMessageBox:nil message:response.message];
                    }
                } ErrorHandlure:^(NSError *error) {
                    
                }];
            }
            
        }
    }
}


@end
