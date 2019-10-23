//
//  PushNotificationPopUpView.h
//  Bloomer
//
//  Created by Steven on 2/13/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushNotificationType: NSObject
+ (NSString*)kReceivedChatMessage;
+ (NSString*)kReceivedComment;
+ (NSString*)kReceivedFlowerAvatarRace;
+ (NSString*)kReceivedFlowerAvatarProfile;
+ (NSString*)kReceivedFlowerPhoto;
@end

@interface PushNotificationPopUpView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;

@property (weak, nonatomic) UIView *ownerView;

@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* screenName;
@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *postID;
@property (strong, nonatomic) NSString *roomID;
@property (assign, nonatomic) BOOL isChat;

+ (id)createInView:(UIView *)view message:(NSString *)message name:(NSString*)name avatar:(NSString *)avatar type:(NSString*)type uid:(NSInteger)uid screenName:(NSString*)screenName RoomID:(NSString *) roomID;
+ (id)createInView:(UIView *)view message:(NSString *)message name:(NSString*)name avatar:(NSString *)avatar type:(NSString*)type uid:(NSInteger)uid screenName:(NSString*)screenName postID:(NSString*)postID;

- (void)showWithAnimated:(BOOL)animated;

@end
