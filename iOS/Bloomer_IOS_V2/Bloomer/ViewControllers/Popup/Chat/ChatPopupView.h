//
//  ChatPopupView.h
//  Bloomer
//
//  Created by Steven on 3/7/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChatPopupViewDelegate<NSObject>
- (void) chatPopupView_selectViewProfile;
- (void) chatPopupView_blockConversation;
- (void) chatPopupView_unBlockConversation;
- (void) chatPopupView_deleteConversation;
@end

#import "API_Block_Chat.h"
#import "UserProfileViewController.h"
#import "API_Delete_Conversation.h"
#import "out_account_forget_verifycode.h"



@interface ChatPopupView : UIView< UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonBlock;
@property (strong, nonatomic) IBOutlet UIButton *buttonDelete;
@property (strong, nonatomic) IBOutlet UIButton *buttonViewProfile;

@property (weak, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) UIViewController *parentViewController;
@property (weak, nonatomic) UIView *ownerView;
@property (assign, nonatomic) NSInteger uid;
@property (weak, nonatomic) UIViewController * destinationView;
@property (weak,nonatomic) id<ChatPopupViewDelegate> delegate;

@property (assign, nonatomic) NSInteger block;  

//- (IBAction)touchButtonBackground:(id)sender;
- (IBAction)touchButtonDelete:(id)sender;
- (IBAction)touchButtonViewProfile:(id)sender;

+ (id)createInView:(UIView*)view;
//- (void)showWithAnimated:(BOOL)animated;
-(void)show;

@end
