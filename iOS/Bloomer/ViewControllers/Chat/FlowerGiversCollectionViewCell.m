//
//  FlowerGiversCollectionViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 6/13/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "FlowerGiversCollectionViewCell.h"

@implementation FlowerGiversCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _avatar.layer.cornerRadius = _avatar.frame.size.width / 2;
    _avatar.layer.borderWidth = 2;
    _avatar.layer.borderColor = [UIColor colorWithRed:0.592 green:0.592 blue:0.592 alpha:1.0].CGColor;
    _avatar.clipsToBounds = TRUE;
}

-(void) prepareForReuse{
    _avatar.image = nil;
    [_name setText:@""];
    [_flower setText:@""];
}

- (IBAction)touchAvatar:(id)sender {
    UserProfileViewController *view;
    
    view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    view.uid = self.profileID;
//    FlowerGiversListViewController* main = (FlowerGiversListViewController*)_mainView;
    _mainView.hidesBottomBarWhenPushed = false;
    [_mainView.navigationController pushViewController:view animated:TRUE];
}
@end
