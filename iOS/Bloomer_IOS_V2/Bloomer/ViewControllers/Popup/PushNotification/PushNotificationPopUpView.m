//
//  PushNotificationPopUpView.m
//  Bloomer
//
//  Created by Steven on 2/13/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIImageView+AFNetworking.h>
#import <AudioToolbox/AudioServices.h>

#import "TabBarViewController.h"
#import "PushNotificationPopUpView.h"
#import "AppHelper.h"
#import "UIColor+Extension.h"
#import "UIImageView+Extension.h"
#import "UIView+Extension.h"

@implementation PushNotificationType
+ (NSString*)kReceivedChatMessage
{
    return @"RECEIVED_MESSAGE";
}

+ (NSString*)kReceivedComment
{
    return @"RECEIVED_COMMENT";
}

+ (NSString*)kReceivedFlowerAvatarRace
{
    return @"RECEIVED_FLOWER_AVATAR_RACE";
}

+ (NSString*)kReceivedFlowerAvatarProfile
{
    return @"RECEIVED_FLOWER_AVATAR_PROFILE";
}

+ (NSString*)kReceivedFlowerPhoto
{
    return @"RECEIVED_FLOWER_PHOTO";
}

@end

@interface PushNotificationPopUpView ()

@property (strong, nonatomic) NSLayoutConstraint *topMargin;
@property (strong, nonatomic) NSLayoutConstraint *viewHeight;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) CGFloat defaultHeight;

@end

@implementation PushNotificationPopUpView

+ (id)createInView:(UIView*)view message:(NSString*)message title:(NSString*)title avatar:(NSString*)avatar
{
    PushNotificationPopUpView *popUpView = [[NSBundle mainBundle] loadNibNamed:@"PushNotificationPopUpView" owner:view options:nil][0];
    popUpView.translatesAutoresizingMaskIntoConstraints = false;
    popUpView.layer.shadowColor = UIColor.blackColor.CGColor;
    popUpView.layer.shadowOffset = CGSizeMake(0, 1);
    popUpView.layer.shadowRadius = 5;
    popUpView.layer.shadowOpacity = 0.8;
    
    popUpView.ownerView = view;
    [view addSubview:popUpView];
    [view addConstraints:[popUpView getConstraints:view]];
    
    popUpView.viewHeight = [popUpView getViewHeightConstraint];
    [popUpView addConstraint:popUpView.viewHeight];
    
    popUpView.topMargin.constant = -3 * popUpView.mainViewHeight.constant;
    [popUpView layoutIfNeeded];
    [view layoutIfNeeded];
    
    //    popUpView.messageLabel.text = message;
    popUpView.nameLabel.text = title;
    
    if (![avatar isEqualToString:@""])
    {
        NSURL *url = [[NSURL alloc] initWithString:avatar];
        [popUpView.avatar setImageWithAnimationFromURL:url placeHolder:[UIImage imageNamed:@"Icon_Other_Users_Avatar"]];
    }
    
    CGFloat popupViewDefaultHeight = IS_IPHONE_X ? 105 : 68;
    
    //    popUpView.nameLabelHeight.constant = [popUpView calculateMessageLabelHeight:popUpView.nameLabel.font text:popUpView.nameLabel.text width:popUpView.nameLabel.frame.size.width];
    //    popUpView.mainViewHeight.constant = popupViewDefaultHeight - 20 + popUpView.frame.size.height;
    popUpView.viewHeight.constant = popUpView.mainViewHeight.constant;
    
    return popUpView;
}

+ (id)createInView:(UIView *)view message:(NSString *)message name:(NSString*)name avatar:(NSString *)avatar type:(NSString *)type uid:(NSInteger)uid screenName:(NSString *)screenName RoomID:(NSString *) roomID
{
    PushNotificationPopUpView *popUpView = [PushNotificationPopUpView createInView:view message:message title:name avatar:avatar];
    popUpView.type = type;
    popUpView.uid = uid;
    popUpView.screenName = screenName;
    popUpView.roomID = roomID;
    [popUpView animateShowUp];
    
    return popUpView;
}

+ (id)createInView:(UIView *)view message:(NSString *)message name:(NSString*)name avatar:(NSString *)avatar type:(NSString*)type uid:(NSInteger)uid screenName:(NSString*)screenName postID:(NSString*)postID
{
    PushNotificationPopUpView *popUpView = [PushNotificationPopUpView createInView:view message:message title:name avatar:avatar];
    popUpView.type = type;
    popUpView.uid = uid;
    popUpView.screenName = screenName;
    popUpView.postID = postID;
    
    [popUpView animateShowUp];
    
    return popUpView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.mainView.layer.cornerRadius = 8;
    self.mainView.layer.shadowColor = [UIColor colorFromHexString:@"#00000026"].CGColor;
    self.mainView.layer.shadowOpacity = 0.5;
    self.mainView.layer.shadowRadius = 5;
    self.mainView.layer.shadowOffset = CGSizeMake(0, 2);
    
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height / 2;
    self.avatar.layer.borderColor = UIColor.whiteColor.CGColor;
    self.avatar.layer.borderWidth = 1;
    self.avatar.clipsToBounds = true;
    
    self.defaultHeight = 0;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    return hitView == self ? nil : hitView;
}

- (void)animateShowUp
{
    CGFloat top = IS_IPHONE_X ? 44 : 0;

    self.topMargin.constant = top;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
        [self.ownerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self setupTimer:2];
        }
    }];
}

- (void)setupTimer:(NSTimeInterval)time
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(animateDisappear) userInfo:nil repeats:false];
}

- (void)animateDisappear
{
    self.topMargin.constant = -3 * self.mainViewHeight.constant;
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
        [self.ownerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self removeFromSuperview];
        }
    }];
}

- (CGFloat)calculateMessageLabelHeight:(UIFont*)font text:(NSString*)text width:(CGFloat)width
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = font;
    label.text = text;
    [label sizeToFit];
    
    return label.frame.size.height;
}

- (NSLayoutConstraint*)getViewHeightConstraint
{
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.mainViewHeight.constant];
}

// MARK: - Actions
- (IBAction)handlePanGesture:(id)sender
{
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)sender;
    CGPoint translate = [panGesture translationInView:self.mainView];
    CGFloat translateY = translate.y / 4;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.defaultHeight = self.viewHeight.constant;
            //            [self.timer invalidate];
            break;
            
        case UIGestureRecognizerStateChanged:
            if (self.mainViewHeight.constant > self.defaultHeight + 150)
            {
                [self animateDisappear];
            }

            self.viewHeight.constant = self.defaultHeight + translateY;
            self.mainViewHeight.constant = self.defaultHeight + translateY;
            break;
            
        case UIGestureRecognizerStateEnded:
            if (self.mainViewHeight.constant < self.defaultHeight)
            {
                [self animateDisappear];
            }
            else
            {
                //                self.viewHeight.constant = self.defaultHeight;
                //                self.mainViewHeight.constant = self.defaultHeight;
                //
                //                [UIView animateWithDuration:0.25 animations:^{
                //                    [self layoutIfNeeded];
                //                    [self.mainView layoutIfNeeded];
                //                } completion:^(BOOL finished) {
                //                    [self setupTimer:1];
                //                }];
            }
            break;
            
        default:
            break;
    }
}

- (IBAction)touchMainView:(id)sender
{
    UINavigationController *navController = (UINavigationController *)UIApplication.sharedApplication.keyWindow.rootViewController;
    
    for (UIViewController* viewController in navController.visibleViewController.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[TabBarViewController class]])
        {
            TabBarViewController *tabBarViewController = (TabBarViewController*)viewController;
            
            if ([self.type isEqualToString:PushNotificationType.kReceivedChatMessage])
            {
                tabBarViewController.selectedIndex = kTabBarProfileIndex;
                UINavigationController* navigationController = (UINavigationController*)tabBarViewController.viewControllers[kTabBarProfileIndex];
                
                ChatListViewController *chatListViewController = [[ChatListViewController alloc] initWithNibName:@"ChatListViewController" bundle:nil];
                chatListViewController.hidesBottomBarWhenPushed = true;
                
                ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
                chatViewController.uid = self.uid;
                chatViewController.roomID = self.roomID;
                chatViewController.screen_name = self.screenName;
                chatViewController.isChat = true;
                chatViewController.receiverAvatar = self.avatar;
                chatViewController.hidesBottomBarWhenPushed = TRUE;
                
                [navigationController popToRootViewControllerAnimated:false];
                [navigationController pushViewController:chatListViewController animated:false];
                [navigationController pushViewController:chatViewController animated:true];
                
                [self removeAnimate];
                return;
            }
            
            if ([self.type isEqualToString:PushNotificationType.kReceivedComment])
            {
                tabBarViewController.selectedIndex = kTabBarProfileIndex;
                UINavigationController* navigationController = (UINavigationController*)tabBarViewController.viewControllers[kTabBarProfileIndex];
                
                
                FullPictureViewController *commentViewController = [[FullPictureViewController alloc] initWithNibName:@"FullPictureViewController" bundle:nil];
                
                gallery* gallerypost = [[gallery alloc]init];
                gallerypost.post_id = _postID;
                
                commentViewController.post_id = _postID;
                commentViewController.isScrollingEnabled = FALSE;
                commentViewController.galleryData = [[NSMutableArray alloc]initWithObjects:gallerypost, nil];
                commentViewController.currentIndex = 0;
                
                commentViewController.parentView = nil;
                
                [navigationController popToRootViewControllerAnimated:false];
                [navigationController pushViewController:commentViewController animated:true];
            }
            
            if ([self.type isEqualToString:PushNotificationType.kReceivedFlowerAvatarRace]
                || [self.type isEqualToString:PushNotificationType.kReceivedFlowerAvatarProfile]
                || [self.type isEqualToString:PushNotificationType.kReceivedFlowerPhoto])
            {
                UINavigationController* navigationController = (UINavigationController*)tabBarViewController.selectedViewController;
                
                FlowerGiverViewController *flowerGiverViewController = [[FlowerGiverViewController alloc] init];
                
                if ([self.type isEqualToString:PushNotificationType.kReceivedFlowerAvatarRace])
                {
                    flowerGiverViewController.notificationKey = self.postID;
                }
                else if ([self.type isEqualToString:PushNotificationType.kReceivedFlowerAvatarProfile])
                {
                    flowerGiverViewController.notificationKey = @"profile";
                }
                else
                {
                    flowerGiverViewController.notificationKey = @"";
                    flowerGiverViewController.post_id = self.postID;
                    flowerGiverViewController.userID = self.uid;
                }
                
                flowerGiverViewController.hidesBottomBarWhenPushed = true;
                
                [navigationController pushViewController:flowerGiverViewController animated:true];
            }
            
            break;
        }
    }
}

// MARK: - Required Functions
- (void)showAnimate
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    UIApplication.sharedApplication.keyWindow.windowLevel = UIWindowLevelStatusBar + 1;
    
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            UIApplication.sharedApplication.keyWindow.windowLevel = UIWindowLevelNormal;
            [self removeFromSuperview];
        }
    }];
}

- (void)showWithAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (animated)
        {
            [self showAnimate];
        }
    });
}

- (NSArray*)getConstraints:(UIView*)parentView
{
    CGFloat top = IS_IPHONE_X ? 44 : 0;

    NSArray* arrsConstrain = [self getConstraintsWithParent:parentView top:top bottom:0 left:0 right:0];
    
    self.topMargin = arrsConstrain[2];
    
    return arrsConstrain;
}

@end
