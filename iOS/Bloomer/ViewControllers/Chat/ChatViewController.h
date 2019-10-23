//
//  ChatViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/1/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "message.h"

@protocol ChatViewControllerDelegate <NSObject>
- (void) chatViewController_UpdateListMessageWith:(message *) message;
- (void) chatViewController_DeleteRoomWithID:(NSString *) roomID;
@end

//#import "API_Message_Pull.h"
//#import "out_message_pull.h"
#import "UserDefaultManager.h"
#import "APIDefine.h"
//#import "API_Message_Presence.h"
//#import "out_message_presence.h"
#import "ChatTableViewCellLeft.h"
#import "ChatTableViewCellRight.h"
#import "ChatTableViewCellFlower.h"
#import "out_profile_fetch.h"
#import "TabBarView.h"
#import "message_send.h"
#import "API_Message_Send.h"
#import "out_message_send.h"
#import "API_Message_RefreshToken.h"
#import "out_message_refresh_token.h"
#import "MKNumberBadgeView.h"
#import "ReportChatPopUpViewController.h"
#import "UIImageView+AFNetworking.h"
#import "image_photo.h"
#import "SEDraggable.h"
#import "SEDraggableLocation.h"
#import "AwesomeMenu.h"
#import "FlowerMenuPostPopupViewController.h"
#import "EmojiView.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"
//#import "SMPageControl.h"
#import "API_ProfileFetch.h"
#import "API_Notification_Pull.h"
#import "API_Flower_GiveProfile.h"
#import "SocketManager.h"
#import "ChatPopupView.h"


@interface ChatViewController : UIViewController<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, AwesomeMenuDelegate, SEDraggableEventResponder, SEDraggableLocationEventResponder, UIGestureRecognizerDelegate, UITextFieldDelegate, UITextInput,ChatPopupViewDelegate>

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *pendingMessages;
@property (strong, nonatomic) UIImageView *receiverAvatar;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *chatView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIView *activeSideView;
@property (weak, nonatomic) IBOutlet SEDraggableLocation *draggableLocation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatViewBottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stickerViewBottomMargin;

@property (weak, nonatomic) IBOutlet UIButton *buttonFlowerStatic;
@property (weak, nonatomic) IBOutlet UIView *chatBoxView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatViewHeight;

@property (strong, nonatomic) IBOutlet EmojiView *emojiKeyboard;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@property (weak, nonatomic) IBOutlet UIScrollView *tabScrollView;
@property (weak, nonatomic) IBOutlet UIView *tabContentView;
@property (weak, nonatomic) IBOutlet UIView *animatedLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animatedLineLeftMargin;
@property (weak, nonatomic) IBOutlet UIView *stickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stickerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flowerChatLimitViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleFlowerChatLimitView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleEmptyView;
@property (weak, nonatomic) IBOutlet UILabel *labelDescriptionEmptyView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleActiveSideView;
@property (weak, nonatomic) IBOutlet UIView *emptyViewDescriptionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activeSideViewHeight;
@property (weak, nonatomic) IBOutlet UIView *flowerChatLimitView;

@property (strong, nonatomic) TabBarView *tabbar;
@property (assign, nonatomic) NSInteger uid;
@property (weak, nonatomic) NSString *screen_name;
//@property (strong, nonatomic) API_Message_Pull *messagePullAPI;
@property (assign, nonatomic) BOOL isChat;
@property (assign, nonatomic) NSInteger blocker;
@property (strong, nonatomic) NSMutableArray *listDraggableLocation;
@property (strong, nonatomic) AwesomeMenu *circularMenu;
@property (weak, nonatomic) NSString* blockMessage;
@property (strong, nonatomic) NSString *roomID;

@property (weak, nonatomic) UIViewController * destinationView;
@property (weak,nonatomic) id<ChatViewControllerDelegate> delegate;


- (IBAction)touchSendButton:(id)sender;
- (IBAction)handleSingletap:(id)sender;
- (void)giveFlower:(long long)flower;
- (void)checkBlockState;
- (void)loadProfileUsingAPI;

@end
