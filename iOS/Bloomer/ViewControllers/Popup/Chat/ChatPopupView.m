//
//  ChatPopupView.m
//  Bloomer
//
//  Created by Steven on 3/7/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "ChatPopupView.h"
#import "UserDefaultManager.h"
#import "ChatViewController.h"
#import "AppHelper.h"

@implementation ChatPopupView
{
    UserDefaultManager *userDefaultManager;
    UIAlertView *deleteAlert;
}

+ (id)createInView:(UIView*)view
{
//    ChatPopupView *popupView = [[NSBundle mainBundle] loadNibNamed:@"ChatPopupView" owner:view options:nil][0];
    ChatPopupView *popupView = [[ChatPopupView alloc] initWithFrame:view.bounds];
    popupView.translatesAutoresizingMaskIntoConstraints = false;
    popupView.ownerView = view;
    return popupView;
}

- (void)show {
    userDefaultManager = [[UserDefaultManager alloc] init];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Chat.viewProfile", ) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.delegate respondsToSelector:@selector(chatPopupView_selectViewProfile)]) {
            [self.delegate chatPopupView_selectViewProfile];
        }
    }]];
    
    switch (self.block) {
        case 1:{         //Block
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Chat.buttonUnblock", ) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self touchButtonUnblock];
            }]];
        }
            
        break;
            
        case 2:{        //Blocked
//            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Chat.buttonBlock", ) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self touchButtonBlock];
//            }]];
        }
        break;
            
        default:
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Chat.buttonBlock", ) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self touchButtonBlock];
            }]];
            break;
    }

    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Chat.deleteConversation", ) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self touchButtonDelete:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Chat.buttonCancel", ) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self removeFromSuperview];
    }]];
    
    [self.parentViewController presentViewController:alert animated:YES completion:nil];
}


//- (NSArray*)getConstraints:(UIView*)parentView
//{
//    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
//    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
//    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
//
//    return @[leading, trailing, top, bottom];
//}

- (IBAction)touchButtonBlock
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[AppHelper getLocalizedString:@"Chat.buttonBlockMessage"] preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[AppHelper getLocalizedString:@"Chat.buttonNo"] style:UIAlertActionStyleDefault handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[AppHelper getLocalizedString:@"Chat.buttonYes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.delegate respondsToSelector:@selector(chatPopupView_blockConversation)]) {
            [self.delegate chatPopupView_blockConversation];
        }
    }]];
    
    [self.parentViewController presentViewController:alert animated:YES completion:nil];
}

- (void) touchButtonUnblock{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[AppHelper getLocalizedString:@"Chat.buttonUnblockMessage"] preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[AppHelper getLocalizedString:@"Chat.buttonNo"] style:UIAlertActionStyleDefault handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[AppHelper getLocalizedString:@"Chat.buttonYes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.delegate respondsToSelector:@selector(chatPopupView_unBlockConversation)]) {
            [self.delegate chatPopupView_unBlockConversation];
        }
    }]];
    
    [self.parentViewController presentViewController:alert animated:YES completion:nil];
}

- (IBAction)touchButtonDelete:(id)sender {

     UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[AppHelper getLocalizedString:@"Chat.buttonDeleteMessage"] preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:[AppHelper getLocalizedString:@"Chat.buttonNo"] style:UIAlertActionStyleDefault handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[AppHelper getLocalizedString:@"Chat.buttonYes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.delegate respondsToSelector:@selector(chatPopupView_deleteConversation)]) {
            [self.delegate chatPopupView_deleteConversation];
        }
    }]];
    
    [self.parentViewController presentViewController:alert animated:YES completion:nil];
    
}

//-(void)deleteConversation {
//    deleteConversionData *params = [[deleteConversionData alloc] initWithAccessToken:[userDefaultManager getAccessToken] deviceId:[userDefaultManager getDeviceToken] rosterId:_uid];
//    if (params) {
//        API_Delete_Conversation *api = [[API_Delete_Conversation alloc] initWithParams:params];
//        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
//            if(response.status) {
//                [self.parentViewController.navigationController popViewControllerAnimated:YES];
//            }
//        } ErrorHandlure:^(NSError *error) {
//
//        }];
//    }
//}


- (IBAction)touchButtonViewProfile:(id)sender {
    UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    view.uid = self.uid;
    view.hidesBottomBarWhenPushed = false;
    view.destinationView = _destinationView;
//    [self removeAnimate];
    self.navigationController.viewControllers = @[self.navigationController.viewControllers.firstObject, view];
}

// MARK: - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == deleteAlert) {
        if(buttonIndex == 1) {
//            [self deleteConversation];
        }
    }
    else if (buttonIndex == 1)
    {
//        API_Block_Chat* api = [[API_Block_Chat alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_id:[userDefaultManager getDeviceToken] block_id:_uid addBlock:!_is_block];
//        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
//            if (response.status)
//            {
//                //        [self removeAnimate];
//                _is_block = !_is_block;
//                [AppHelper showMessageBox:@"" message:[AppHelper getLocalizedString:_is_block ? @"Chat.blockSuccessfulMessage" : @"Chat.unblockSuccessfulMessage"]];
//                
//                ChatViewController *view = (ChatViewController*)self.parentViewController;
////                view.isBlock = _is_block;
//                view.blocker = [userDefaultManager getUserProfileData].uid;
//                view.blockMessage = [AppHelper getLocalizedString:@"Chat.labelTitleActiveSideView"];
//                [view loadProfileUsingAPI];
//            }
//            else
//            {
//                [AppHelper showMessageBox:nil message:response.message];
//            }
//        } ErrorHandlure:^(NSError *error) {
//            
//        }];

    }
}


@end
