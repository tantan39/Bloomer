//
//  TabBarView.m
//  Xinh
//
//  Created by Truong Thuan Tai on 11/20/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "TabBarView.h"
#import "TutorialPopUpView.h"
#import "TabBarViewController.h"
#import "RacesViewController.h"
#import "FriendsUpdateViewController.h"
#import "UserProfileViewController.h"
#import "DiscoveryViewController.h"
#import "AppHelper.h"

#define OBJECT_WIDTH 50.0f
#define OBJECT_HEIGHT 50.0f
#define MARGIN_VERTICAL 0.0f
#define MARGIN_HORIZONTAL 0.0f

@implementation TabBarView
{
    UserDefaultManager *userDefaultManager;
    BOOL isLoadingTut;
    BOOL isFlowerBouncing;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil];
        userDefaultManager = [[UserDefaultManager alloc] init];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flowerButtonTap)];
        singleTap.numberOfTapsRequired = 1;
        [_flowerButton addGestureRecognizer:singleTap];
        [_flowerButton setUserInteractionEnabled:TRUE];
        
        [self addSubview:self.view];
        [self updateFlowerValue];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil];
        userDefaultManager = [[UserDefaultManager alloc] init];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flowerButtonTap)];
        singleTap.numberOfTapsRequired = 1;
        [_flowerButton addGestureRecognizer:singleTap];
        [_flowerButton setUserInteractionEnabled:TRUE];
        [_FlowerTutorial setImage:nil];
        
        isLoadingTut = false;
        isFlowerBouncing = false;
        
        [self addSubview:self.view];
        [self updateFlowerValue];
    }
    return self;
}

- (void) initTabbar
{
    SEDraggableLocation *home = [[SEDraggableLocation alloc] initWithFrame:_flowerView.frame];
    [self addSubview:home];
    [self configureDraggableLocation:home];
    home.delegate = self;
    _homeLocation = home;
    
    SEDraggable *draggable = [[SEDraggable alloc] initWithImageView: _flowerButton];
    draggable.delegate = self;
    [draggable addSubview:_flowerValue];
    [self configureDraggableObject:draggable];
    _draggableButton = draggable;
    
    [self.view setExclusiveTouch:TRUE];
    [self.view bringSubviewToFront:_flowerValue];
}

- (void) configureDraggableLocation:(SEDraggableLocation *)draggableLocation {
    // set the width and height of the objects to be contained in this SEDraggableLocation (for spacing/arrangement purposes)
    draggableLocation.objectWidth = OBJECT_WIDTH;
    draggableLocation.objectHeight = OBJECT_HEIGHT;
    
    // set the bounding margins for this location
    draggableLocation.marginLeft = MARGIN_HORIZONTAL;
    draggableLocation.marginRight = MARGIN_HORIZONTAL;
    draggableLocation.marginTop = MARGIN_VERTICAL;
    draggableLocation.marginBottom = MARGIN_VERTICAL;
    
    // set the margins that should be preserved between auto-arranged objects in this location
    draggableLocation.marginBetweenX = MARGIN_HORIZONTAL;
    draggableLocation.marginBetweenY = MARGIN_VERTICAL;
    
    // set up highlight-on-drag-over behavior
    draggableLocation.highlightColor = [UIColor greenColor].CGColor;
    draggableLocation.highlightOpacity = 0.4f;
    draggableLocation.shouldHighlightOnDragOver = YES;
    
    // you may want to toggle this on/off when certain events occur in your app
    draggableLocation.shouldAcceptDroppedObjects = NO;
    
    // set up auto-arranging behavior
    draggableLocation.shouldKeepObjectsArranged = YES;
    draggableLocation.fillHorizontallyFirst = YES; // NO makes it fill rows first
    draggableLocation.allowRows = YES;
    draggableLocation.allowColumns = YES;
    draggableLocation.shouldAnimateObjectAdjustments = YES; // if this is set to NO, objects will simply appear instantaneously at their new positions
    draggableLocation.animationDuration = 0.5f;
    draggableLocation.animationDelay = 0.0f;
    draggableLocation.animationOptions = UIViewAnimationOptionLayoutSubviews ; // UIViewAnimationOptionBeginFromCurrentState;
    
    draggableLocation.shouldAcceptObjectsSnappingBack = YES;
}

- (void) configureDraggableObject:(SEDraggable *)draggable {
    draggable.homeLocation = _homeLocation;
    [_homeLocation addDraggableObject:draggable animated:NO];
}

- (void) draggableObject:(SEDraggable *)object finishedEnteringLocation:(SEDraggableLocation *)location withEntryMethod:(SEDraggableLocationEntryMethod)entryMethod
{
    [object setHidden:NO];
    
    if (entryMethod == SEDraggableLocationEntryMethodWantsToSnapBack)
    {
        if([userDefaultManager isAnonymous] && ![(AppDelegate *)[[UIApplication sharedApplication] delegate] isOpen])
        {
            [AppHelper showAnonymousLoginPopUpView];
        }
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] setIsOpen:NO]; //Update isOpen flag
        if(isFlowerBouncing == false)
        {
            [_flowerButton setImage:[UIImage imageNamed:@"Btn_FlowersTabbar.png"]];
            [_flowerValue setHidden:FALSE];
        }
    }
}

- (void)updateFlowerValue
{
    long long flowerNumber = [userDefaultManager getUserProfileData].your_num_flower;
    if([userDefaultManager isAnonymous])
        flowerNumber = 100;
    NSString *flowerString = @(flowerNumber).stringValue;
    NSString *finalString = @"";
    
    if (flowerNumber > 1000000)
    {
        for (NSInteger i = 0; i < flowerString.length - 6; i++)
        {
            NSString* temp = [NSString stringWithFormat:@"%c", [flowerString characterAtIndex:i]];
            finalString = [finalString stringByAppendingString:temp];
        }
        
        finalString = [finalString stringByAppendingString:@"M"];
        
//        for (NSInteger i = flowerString.length - 6; i < flowerString.length - 6 + 3; i++)
//        {
//            NSString* temp = [NSString stringWithFormat:@"%c", [flowerString characterAtIndex:i]];
//            finalString = [finalString stringByAppendingString:temp];
//        }
    }
    else
    {
        finalString = flowerString;
    }
        
    _flowerValue.text = finalString;
    _stayFlowerValue.text = finalString;
    
    if (flowerNumber == 0)
    {
        [_flowerButton setImage:[UIImage imageNamed:@"Btn_FlowersTabbar_deactive"]];
        _draggableButton.userInteractionEnabled = NO;
    }
    else
    {
        [_flowerButton setImage:[UIImage imageNamed:@"Btn_FlowersTabbar.png"]];
        _draggableButton.userInteractionEnabled = YES;
    }
}

-(void)setFlowerButtonWithDefaultImage
{
    [self.flowerButton setImage:[UIImage imageNamed:@"Btn_FlowersTabbar.png"]];
}

-(void)flowerButtonTap
{
    _flowerButton.highlighted = FALSE;
    
    if ([userDefaultManager isAnonymous])
    {
        [AppHelper showAnonymousLoginPopUpView];
    }
    else
    {
        UINavigationController *mainNavigationController = (UINavigationController*)[UIApplication sharedApplication].delegate.window.rootViewController;
        for (UIViewController* viewController in mainNavigationController.visibleViewController.navigationController.viewControllers)
        {
            if ([viewController isKindOfClass:[TabBarViewController class]])
            {
                TabBarViewController *tabBarViewController = (TabBarViewController*)viewController;
                
                UINavigationController *navigationController = (UINavigationController*)tabBarViewController.viewControllers[tabBarViewController.selectedIndex];
                
                if ([navigationController.visibleViewController isKindOfClass:[RacesViewController class]])
                {
                    if([userDefaultManager isSeenLeaderboardTut]) return;
                    TutorialPopUpView *tutorialPopUpView = [TutorialPopUpView createInView:    [UIApplication sharedApplication].delegate.window tutorialType:Leaderboard];
                    [tutorialPopUpView showWithAnimated:true];
                    
                    return;
                }
                
                if ([navigationController.visibleViewController isKindOfClass:[FriendsUpdateViewController class]])
                {
                    if([userDefaultManager isSeenMyBloomerTut]) return;
                    TutorialPopUpView *tutorialPopUpView = [TutorialPopUpView createInView:    [UIApplication sharedApplication].delegate.window tutorialType:MyBloomer];
                    [tutorialPopUpView showWithAnimated:true];
                    
                    return;
                }
                
                if ([navigationController.visibleViewController isKindOfClass:[UserProfileViewController class]])
                {
                    if([userDefaultManager isSeenUserProfileTut]) return;
                    TutorialPopUpView *tutorialPopUpView = [TutorialPopUpView createInView:    [UIApplication sharedApplication].delegate.window tutorialType:OtherProfile];
                    [tutorialPopUpView showWithAnimated:true];
                    
                    return;
                }
                
                if ([navigationController.visibleViewController isKindOfClass:[DiscoveryViewController class]])
                {
                    if([userDefaultManager isSeenDiscoveryTut]) return;
                    TutorialPopUpView *tutorialPopUpView = [TutorialPopUpView createInView:    [UIApplication sharedApplication].delegate.window tutorialType:Discovery];
                    [tutorialPopUpView showWithAnimated:true];
                    
                    return;
                }
                
            }
        }
    }
}

//-(void) flowerTutorial
//{
//    isFlowerBouncing = true;
//    _FlowerTutorial.alpha = 1.0;
//    [_BouncingView setHidden:NO];
//    [_FlowerTutorial setImage:[UIImage imageNamed:@"Btn_FlowersTabbar.png"]];
//    [_flowerButton setImage:nil];
//    [UIView animateWithDuration:0.5f
//                          delay:0.0f
//                        options:UIViewAnimationOptionBeginFromCurrentState
//                     animations:^{
//                         [_FlowerTutorial setFrame:CGRectMake(0, 0, 50, 50)];
//                     }
//                     completion:^(BOOL finished) {
//                         self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.BouncingView];
//                         self.animator.delegate = self;
//                         
//                         UIGravityBehavior* gravityBehavior =
//                         [[UIGravityBehavior alloc] initWithItems:@[self.FlowerTutorial]];
//                         [self.animator addBehavior:gravityBehavior];
//                         
//                         UICollisionBehavior* collisionBehavior =
//                         [[UICollisionBehavior alloc] initWithItems:@[self.FlowerTutorial]];
//                         collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
//                         [self.animator addBehavior:collisionBehavior];
//                         
//                         UIDynamicItemBehavior *elasticityBehavior =
//                         [[UIDynamicItemBehavior alloc] initWithItems:@[self.FlowerTutorial]];
//                         elasticityBehavior.elasticity = 0.7f;
//                         [self.animator addBehavior:elasticityBehavior];
//                     }];
//}

//- (void) setUpLoading:(BOOL) loaddingState
//{
//    isLoadingTut = loaddingState;
//}
//
//- (BOOL) getLoadingState
//{
//    return isLoadingTut;
//}

//- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
//{
//    [UIView animateWithDuration:0.1 animations:^{
//        _FlowerTutorial.alpha = 0.0;
//    } completion:^(BOOL finished){
//        [_flowerButton setImage:[UIImage imageNamed:@"Btn_FlowersTabbar.png"]];
//        _flowerButton.alpha = 0.0;
//        [UIView animateWithDuration:0.1 animations:^{
//            _flowerButton.alpha = 1.0;
//        } completion:^(BOOL finished){
//            [_BouncingView setHidden:YES];
//            self.animator.delegate = nil;
//            _popupTutorialFlowerGive = [[PopUpTutorial alloc] initWithNibName:@"PopUpTutorial" bundle:nil];
//            [_popupTutorialFlowerGive showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
//            isLoadingTut = false;
//            isFlowerBouncing = false;
//        }];
//    }];
//}

//- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
//{
//}

- (void) draggableObjectDidMove:(SEDraggable *)object
{  
    [_flowerButton setImage:[UIImage imageNamed:@"Icon_Giving_Flowers"]];
    [_flowerValue setHidden:TRUE];
}

- (void)snapbackFlowerIconToTabbar
{    
    if (![self.draggableButton.homeLocation pointIsInsideResponsiveBounds:CGPointMake(self.draggableButton.firstX, self.draggableButton.firstY)])
    {
        [self.draggableButton askToSnapBackToLocation:self.draggableButton.homeLocation animated:YES];
    }
}

@end
