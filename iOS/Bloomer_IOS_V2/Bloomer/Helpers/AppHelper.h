//
//  AppHelper.h
//  Bloomer
//
//  Created by Steven on 1/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "message.h"
#import "SEDraggable.h"
#import "SEDraggableLocation.h"
#import "AwesomeMenu.h"
#import "ThankYou.h"
#import "PushNotificationPopUpView.h"
#define kSpotlightSearchUser @"BloomerUsers"
#define kSpotlightSearchLeaderboard @"BloomerLeaderboards"

typedef enum TabBarIndex {
    kTabBarRaceIndex=0,
    kTabBarMyBloomerIndex=1,
    kTabBarFlowerButtonIndex=2,
    kTabBarDiscoverIndex=3,
    kTabBarProfileIndex=4
} TabBarIndex;

@interface AppHelper : NSObject

+ (NSString*)getLocalizedString:(NSString*)string;
+ (void)configureDraggableLocation:(SEDraggableLocation *)draggableLocation objectSize:(CGSize)objectSize;
+ (void)configureDraggableObject:(SEDraggable *)draggable draggableLocation:(SEDraggableLocation*)draggableLocation;
+ (void)configureDraggableLocation:(SEDraggableLocation *)draggableLocation objectSize:(CGSize)objectSize isCircle:(BOOL)isCircle hightlight:(BOOL)highlight highlightColor:(UIColor*)highlightColor;
+ (AwesomeMenu *)createCircularMenuWithFrame:(CGRect)frame startPoint:(CGPoint)startPoint delegate:(id)delegate;
+ (void)createThankYouView:(ThankYou*)thankYouView point:(CGPoint)point frame:(CGRect)frame;
+ (void)setTitleViewForNavigationBar:(UINavigationItem*)navigationItem title:(NSString*)title;
+ (void)setTitleViewForNavigationBar:(UINavigationItem*)navigationItem title:(NSString*)title color:(UIColor*)color;
+ (void)showMessageBox:(NSString*)title message:(NSString*)message;
+ (void)showMessageUnderNavBar:(UIViewController *) viewcontroller message:(NSString*)message timer:(BOOL) timer;
+ (void)setupConstraintsForHorizontalView:(UIView*)view previousView:(UIView*)previousView isFirstView:(BOOL)isFirstView parentView:(UIView*)parentView width:(CGFloat)width spacing:(CGFloat)spacing;
+ (void)setupFullStretchConstraintsForView:(UIView*)view parentView:(UIView*)parentView;
+ (UIImage*)cropToBounds:(UIImage*)image rect:(CGRect)rect;
+ (void)showPopUpMarketing;
+ (void)showAnonymousLoginPopUpView;
+ (void)showMatchingFlowerPopUp:(NSInteger)flowers;

+ (void)changeNavigationBarToRed:(UINavigationController*)navigationController;
+ (void)changeNavigationBarToWhite:(UINavigationController*)navigationController;
+ (void)FBLogCompletedRegistration:(NSString*)registrationMethod;
+ (void)setButtonWithUnderlineTitle:(UIButton *)button textColor:(UIColor *)color fontSize:(CGFloat)fontSize;

+ (void)handleDeeplink;
+ (void) handlePushNotificationWithUserInfo:(NSDictionary *) userInfo;
+ (void) handleMessageIncoming:(message *) msg;
+ (NSMutableAttributedString*)makeBoldText:(NSString*)text inString:(NSString*)string font:(UIFont*)font color:(UIColor*)color;
+ (void) configFirebase;
+ (NSString*) getScreenNameView:(NSString*) nameXib;
+ (BOOL) isIP5AndIP4;

@end
