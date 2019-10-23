//
//  ChangeAvatarViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/21/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "avatar.h"
#import "UIImageView+AFNetworking.h"
#import "ImagePickerPopUpViewController.h"
#import "AvatarCollectionViewCell.h"
#import "payload.h"
#import "API_Avatar_RaceAttached.h"

@interface ChangeAvatarViewController : UIViewController < UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *avatarView;
@property (strong, nonatomic) NSMutableArray *avatarList;
@property (weak, nonatomic) IBOutlet UIScrollView *slideshow;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UIImageView *image6;
@property (weak, nonatomic) IBOutlet UIImageView *image7;
@property (weak, nonatomic) IBOutlet UILabel *raceName1;
@property (weak, nonatomic) IBOutlet UILabel *raceName2;
@property (weak, nonatomic) IBOutlet UILabel *raceName3;
@property (weak, nonatomic) IBOutlet UILabel *raceName4;
@property (weak, nonatomic) IBOutlet UILabel *raceName5;
@property (weak, nonatomic) IBOutlet UILabel *raceName6;
@property (weak, nonatomic) IBOutlet UILabel *raceName7;
@property (strong, nonatomic) NSMutableArray *avatarListUpdate;
@property (weak, nonatomic) UIViewController *parentView;
@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSMutableArray *listGallery;;
@property (strong, nonatomic) NSString* curRaceKey;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *racesButtons;
@property (weak, nonatomic) IBOutlet UICollectionView *avatarCollectionView;

@property (assign, nonatomic) BOOL isUploadFromBloomer;

- (IBAction)touchAvatar:(UIButton *)sender;
-(void) updateAvatarForRaceByIndex:(NSInteger)index andImage:(UIImage*) chosenImg;
@end
