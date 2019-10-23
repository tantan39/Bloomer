//
//  TabBarView.h
//  Xinh
//
//  Created by Truong Thuan Tai on 11/20/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEDraggable.h"
#import "SEDraggableLocation.h"
#import "UserDefaultManager.h"
#import "NotificationHelper.h"
#import "out_profile_fetch.h"
#import "PopUpTutorial.h"

@interface TabBarView : UIView<SEDraggableEventResponder, SEDraggableLocationEventResponder,UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) UITabBarController *tabBarController;
@property CGRect viewFrame;
@property (weak, nonatomic) IBOutlet UIImageView *flowerButton;
@property (strong, nonatomic) SEDraggableLocation *homeLocation;
@property (strong, nonatomic) SEDraggable *draggableButton;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIView *flowerView;
@property (weak, nonatomic) IBOutlet UILabel *flowerValue;
@property (weak, nonatomic) IBOutlet UILabel *stayFlowerValue;
@property (weak, nonatomic) IBOutlet UIImageView *FlowerTutorial;
@property (weak, nonatomic) IBOutlet UIView *BouncingView;
@property (strong, nonatomic) PopUpTutorial* popupTutorialFlowerGive;

- (void) initTabbar;
- (void) updateFlowerValue;
- (void) snapbackFlowerIconToTabbar;
- (void) setFlowerButtonWithDefaultImage;
//- (void) flowerTutorial;
//- (void) setUpLoading:(BOOL) loaddingState;
//- (BOOL) getLoadingState;


@end
