//
//  UpdateProfileCollectionViewCell.h
//  Bloomer
//
//  Created by Tan Tan on 12/18/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateProfileCustomView.h"
#import "out_profile_fetch.h"
NS_ASSUME_NONNULL_BEGIN

@protocol UpdateProfileCollectionViewCellDelegate <NSObject>

- (void) updateProfilePopUpClose_PressedWith:(UpdateProfileType) type;
- (void) updateProfilePopUpUpdate_PressedWith:(UpdateProfileType) type;

@end

@interface UpdateProfileCollectionViewCell : UICollectionViewCell <UpdateProfileCustomViewDelegate>

@property (weak, nonatomic) IBOutlet UpdateProfileCustomView *updateAvatarView;
@property (weak, nonatomic) IBOutlet UpdateProfileCustomView *updatePhoneNumberView;
@property (weak,nonatomic) id<UpdateProfileCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updatePhoneNumberViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updateAvatarViewHeightConstraint;

+ (CGFloat) cellHeight;
+ (NSString *) cellIdentifier;
+ (NSString *)nibName;

- (void) configCell:(out_profile_fetch *) profile;

@end

NS_ASSUME_NONNULL_END
