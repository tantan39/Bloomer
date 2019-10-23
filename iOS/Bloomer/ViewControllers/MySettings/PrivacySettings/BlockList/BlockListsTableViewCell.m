//
//  BlockListsTableViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "BlockListsTableViewCell.h"

@implementation BlockListsTableViewCell {
    UIAlertView *unB;
    UserDefaultManager *userDefaultManager;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _avatar.layer.cornerRadius = _avatar.frame.size.width / 2;
    _avatar.layer.borderWidth = 1;
    _avatar.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _unBlockButton.layer.cornerRadius = _unBlockButton.frame.size.height/2;
    _avatar.clipsToBounds = TRUE;
    userDefaultManager = [[UserDefaultManager alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)touchUnBlock:(id)sender {
    unB = [[UIAlertView alloc] initWithTitle:nil
                                               message:NSLocalizedString(@"Are you sure you want to unblock this user?",nil)
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"No",nil)
                                     otherButtonTitles:NSLocalizedString(@"Yes",nil), nil];
    [unB show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == unB) {
        if (buttonIndex == 1) {
            block_remove *params = [[block_remove alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:_uid];
            if(params) {
                API_BlockRemove *api = [[API_BlockRemove alloc] initWithParams:params];
                [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                    if (response.status)
                    {
                        BlockListsViewController *view = (BlockListsViewController *)_parentView;
                        [view loadBlocker];
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
