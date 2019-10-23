//
//  UpdateProfileCustomView.h
//  Bloomer
//
//  Created by Tan Tan on 12/14/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppHelper.h"
#import "UIView+Extension.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum UpdateProfileType {
    AVATAR,
    PHONENUMBER,
    BOTH,
    NONE
} UpdateProfileType;

@protocol UpdateProfileCustomViewDelegate <NSObject>

- (void) updateProfileCustomViewCloseWithMode:(UpdateProfileType)mode;
- (void) updateProfileCustomViewUpdateWithMode:(UpdateProfileType)mode;

@end



@interface UpdateProfileCustomView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property (assign,nonatomic) UpdateProfileType mode;
@property (weak,nonatomic) id<UpdateProfileCustomViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paddingBottomConstraint;

- (void) setUpdateMode:(UpdateProfileType) mode;

@end

NS_ASSUME_NONNULL_END
