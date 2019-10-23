//
//  CountryAvatarCustomView.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryAvatar.h"
#import "RacesViewController.h"


@interface CountryAvatarCustomView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imgvAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (strong,nonatomic) CountryAvatar * model;
@property (weak, nonatomic) IBOutlet UIView *gradientView;
@end
