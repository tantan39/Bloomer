//
//  CommentTableViewCell.m
//  Xinh
//
//  Created by Truong Thuan Tai on 12/9/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "MyProfileViewController.h"

@implementation CommentTableViewCell

// MARK: - Static variables

+ (CGFloat)cellHeight
{
    return 70;
}

+ (NSString*)cellIdentifier
{
    return @"CommentCell";
}

// MARK: - Functions

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height / 2;
    self.avatar.clipsToBounds = TRUE;
    self.avatar.layer.borderWidth = 1;
    self.avatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) prepareForReuse
{
    _avatar.image = nil;
}

- (IBAction)touchAvatarButton:(id)sender
{
    UserDefaultManager *userDefaultManager = [[UserDefaultManager alloc] init];
    out_profile_fetch *profileData = [userDefaultManager getUserProfileData];
    
    if (profileData.uid != _uid)
    {
        UserProfileViewController *view;
        
        view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
        view.hidesBottomBarWhenPushed = FALSE;
        view.uid = _uid;
        
        if (self.navigationController.viewControllers.count >= 2)
        {
            [self.navigationController popToRootViewControllerAnimated:false];
        }
        [_navigationController pushViewController:view animated:TRUE];
    }
    else
    {
        [AppDelegate setSelectedIndexTabbar:4];
        [self.navigationController popToRootViewControllerAnimated:true];
    }
}
@end
