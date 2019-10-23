//
//  UpdateProfileCustomView.m
//  Bloomer
//
//  Created by Tan Tan on 12/14/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "UpdateProfileCustomView.h"

@implementation UpdateProfileCustomView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
         [self customInit];
    }
    return self;
}

- (void) customInit{
    [[NSBundle mainBundle] loadNibNamed:@"UpdateProfileCustomView" owner:self options:nil];
    [self addSubview:self.contentView];
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [AppHelper setupFullStretchConstraintsForView:self.contentView parentView:self];
    
    [self.btnUpdate roundedBorderCornerWithRadius:4.0f];
}

- (void)setUpdateMode:(UpdateProfileType)mode{
    self.mode = mode;
    
    switch (mode) {
        case AVATAR:{
            [self.lblTitle setText:@"Update your avatar with \n your best photo"];
            [self.btnUpdate setTitle:@"Update avatar" forState:UIControlStateNormal];
        }
            break;
            
        case PHONENUMBER:{
            NSString * content = [NSString stringWithFormat:@"Upadate your phone number \n to complete your profile"];
            [self.lblTitle setText:content];
            [self.btnUpdate setTitle:@"Update phone number" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (IBAction)btnUpdate_Pressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(updateProfileCustomViewUpdateWithMode:)]) {
        [self.delegate updateProfileCustomViewUpdateWithMode:self.mode];
    }
}

- (IBAction)btnClose_Pressed:(id)sender {
//    self.paddingBottomConstraint set;
    if ([self.delegate respondsToSelector:@selector(updateProfileCustomViewCloseWithMode:)]) {
        [self.delegate updateProfileCustomViewCloseWithMode:self.mode];
    }
}

@end
