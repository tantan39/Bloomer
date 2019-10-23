//
//  PhotosTaggedCollectionViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/22/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullPictureViewController.h"
#import "SEDraggableLocation.h"
#import "ThankYou.h"
#import "Support.h"

@interface PhotosTaggedCollectionViewCell : UICollectionViewCell <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property (weak, nonatomic) IBOutlet SEDraggableLocation *draggableLocation;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIImageView *iconGivedFlowerPhoto;
@property (weak, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) NSString *post_id;
@property (strong, nonatomic) ThankYou* thankyouView;

-(void) showThankYou:(BOOL)isShow;
- (IBAction)touchPhoto:(id)sender;
@end
