//
//  FlowerRelationCell.m
//  Bloomer
//
//  Created by Steven on 3/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "FlowerRelationCell.h"
#import "UIColor+Extension.h"
#import "ChatViewController.h"
#import "UserDefaultManager.h"
#import "AppHelper.h"

@implementation FlowerRelationCell
{
    UIAlertView *unfollowAlertView;
    UserDefaultManager *userDefaultManager;
}

+ (CGFloat)cellHeight
{
    return 105;
}

+ (NSString*)cellIdentifier
{
    return @"FlowerRelationCell";
}

+ (NSString*)nibName
{
    return @"FlowerRelationCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    self.buttonFollow.layer.cornerRadius = self.buttonFollow.frame.size.height / 2;
    self.buttonFollow.clipsToBounds = true;
    
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height / 2;
    self.avatar.layer.borderColor = [UIColor colorFromHexString:@"#D8D8D8"].CGColor;
    self.avatar.layer.borderWidth = 1;
    self.avatar.clipsToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)switchStateForButtonFollow:(BOOL)isFollow
{
    if (!isFollow)
    {
        [self.buttonFollow setTitle:[AppHelper getLocalizedString:@"FlowerRelation.buttonFollow"] forState:UIControlStateNormal];
        self.buttonFollow.backgroundColor = [UIColor colorFromHexString:@"#7ED321"];
    }
    else
    {
        [self.buttonFollow setTitle:[AppHelper getLocalizedString:@"FlowerRelation.buttonUnfollow"] forState:UIControlStateNormal];
        self.buttonFollow.backgroundColor = [UIColor colorFromHexString:@"#737373"];
    }
}

// MARK: - Actions

- (IBAction)touchButtonChat:(id)sender
{
    ChatViewController *view = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    view.uid = self.data.uid;
    view.screen_name = self.data.name;
//    view.isBlock = roomInfo.is_block;
//    view.blocker = roomInfo.blocker;
    view.isChat = self.data.is_chat;
    view.receiverAvatar = self.avatar;
    view.hidesBottomBarWhenPushed = TRUE;
    
    [self.navigationController pushViewController:view animated:TRUE];
}

- (IBAction)touchButtonFollow:(id)sender
{
    if (self.data.is_follow)
    {
        unfollowAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                       message:NSLocalizedString(@"Are you sure you want to unfollow this user?",nil)
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"No",)
                                             otherButtonTitles:NSLocalizedString(@"Yes",nil), nil];
        [unfollowAlertView show];
    }
    else
    {
        block_remove *param = [[block_remove alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:self.data.uid];
        if (param) {
            API_ReFollow *api = [[API_ReFollow alloc] initWithParams:param];
            [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                if (response.status)
                {
                    self.data.is_follow = true;
                    [self switchStateForButtonFollow:true];
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

// MARK: - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == unfollowAlertView)
    {
        if (buttonIndex == 1)
        {
            block_remove *param = [[block_remove alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:self.data.uid];
            if (param) {
                API_UnFollow *api = [[API_UnFollow alloc] initWithParams:param];
                [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                    if (response.status)
                    {
                        self.data.is_follow = false;
                        [self switchStateForButtonFollow:false];
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
