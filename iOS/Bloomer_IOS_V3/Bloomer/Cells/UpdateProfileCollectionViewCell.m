//
//  UpdateProfileCollectionViewCell.m
//  Bloomer
//
//  Created by Tan Tan on 12/18/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "UpdateProfileCollectionViewCell.h"

@implementation UpdateProfileCollectionViewCell

+ (CGFloat)cellHeight{
    return 120;
}

+ (NSString *)cellIdentifier{
    return @"UpdateProfileCollectionViewCell";
}

+ (NSString *)nibName{
    return @"UpdateProfileCollectionViewCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.updatePhoneNumberView setUpdateMode:PHONENUMBER];
    self.updatePhoneNumberView.delegate = self;
    
    [self.updateAvatarView setUpdateMode:AVATAR];
    self.updateAvatarView.delegate = self;
}

- (void)configCell:(out_profile_fetch *)profile{
    if ([profile.mobile isEqualToString:@""]) {
        [self.updateAvatarView setHidden:YES];
    } else if (!profile.isupload_avatar) {
        [self.updatePhoneNumberView setHidden:YES];
    }
}

- (void)updateProfileCustomViewCloseWithMode:(UpdateProfileType)mode{
    
    if ([self.delegate respondsToSelector:@selector(updateProfilePopUpClose_PressedWith:)]) {
        [self.delegate updateProfilePopUpClose_PressedWith:mode];
    }
    
    if (mode == AVATAR) {
        
        self.updateAvatarViewHeightConstraint.constant = 0;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.updateAvatarView layoutIfNeeded];
        } completion:nil];
        
    }else{
        self.updatePhoneNumberViewHeightConstraint.constant = 0;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.updatePhoneNumberView layoutIfNeeded];

        } completion:nil];
    }
}

- (void)updateProfileCustomViewUpdateWithMode:(UpdateProfileType)mode{
    if ([self.delegate respondsToSelector:@selector(updateProfilePopUpUpdate_PressedWith:)]) {
        [self.delegate updateProfilePopUpUpdate_PressedWith:mode];
    }
}

@end
