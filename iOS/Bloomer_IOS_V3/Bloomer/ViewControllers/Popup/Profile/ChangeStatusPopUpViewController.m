//
//  ChangeStatusPopUpViewController.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 3/22/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "ChangeStatusPopUpViewController.h"
#import "MyProfileViewController.h"

@interface ChangeStatusPopUpViewController (){
    UserDefaultManager* userDefaultManager;
    CGRect popupFrame;
}

@end

@implementation ChangeStatusPopUpViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setFrame:[[UIScreen mainScreen] bounds]];
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.70];
    userDefaultManager = [[UserDefaultManager alloc] init];
    _popUpView.layer.cornerRadius = 10;
    _popUpView.layer.masksToBounds = true;
    popupFrame = _popUpView.frame;
    [_doneButton setTitle:NSLocalizedString(@"StatusChangeButtonOK.Title", ) forState:UIControlStateNormal];
    [_cancelButton setTitle:NSLocalizedString(@"StatusChangeButtonCancel.Title", ) forState:UIControlStateNormal];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIKeyboardWillHideNotification" object:nil];
}


- (IBAction)TouchDoneButton:(id)sender {
    
    caption_update *params = [[caption_update alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] status:_textData.text];
    if (params) {
        API_Profile_UpdateStatus *api = [[API_Profile_UpdateStatus alloc] initWithParams:params];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status) {
                [self removeAnimate];
            } else {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
}

- (IBAction)TouchCancelButton:(id)sender {
    [UIView animateWithDuration:.4 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1, 1);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

//- (void) keyboardWillShow:(NSNotification *) notification{
//    NSDictionary *userInfo = [notification userInfo];
//    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    CGFloat keyboardHeight = kbSize.height;
//    if (@available(iOS 11.0, *)) {
//        keyboardHeight -= self.view.safeAreaInsets.bottom;
//    }
//    CGFloat yFrame = self.view.bounds.size.height - (_popUpView.frame.origin.y + _popUpView.bounds.size.height + 5);
//
//    CGFloat offSet = yFrame - keyboardHeight;
//    if (offSet < 0) {
//        [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//            self.popUpView.frame = CGRectMake(popupFrame.origin.x, offSet, self.popUpView.bounds.size.width, self.popUpView.bounds.size.height);
//        }];
//    }
//}

//- (void) keyboardWillHide:(NSNotification *) notification{
//    NSDictionary *userInfo = [notification userInfo];
//    CGRect frame = self.popUpView.frame;
//    frame.origin.y = popupFrame.origin.y;
//
//    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        self.popUpView.frame = frame;
//    }];
//}

- (void)showInView:(UIView *)aView andData:(NSString*) stringData animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        if (animated) {
            _textData.text = stringData;
            [self setTheNumberOfText:stringData.length];
            [self showAnimate];
        }
    });
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.4 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1, 1);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
            MyProfileViewController *view = (MyProfileViewController *)_parentView;
            [view pullToRefresh];
        }
    }];
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1, 1);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)setTheNumberOfText:(NSInteger)number {
    _statusName.text = [NSString stringWithFormat:NSLocalizedString(@"StatusChange.Title", ), number];
}

// MARK: - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"])
    {
        return NO;
    }
    
    NSInteger myLength = textView.text.length + (text.length - range.length);
    return myLength <= 140;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self setTheNumberOfText:textView.text.length];
}

- (void) keyboardWillShow:(NSNotification *)note
{
    //    NSDictionary *userInfo = [note userInfo];
    //    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect kbSize = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbSize = [self.view convertRect:kbSize fromView:nil];
    
    CGFloat offSet = self.view.bounds.size.height - (_popUpView.frame.origin.y + _popUpView.bounds.size.height + 10) - kbSize.size.height ;
    
    popupFrame = self.view.frame;
    
    if (offSet < 0) {
        [self.view setFrame:CGRectMake(0, offSet, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
}

- (void) keyboardWillHide:(NSNotification *)note
{

    [UIView animateWithDuration:0.3 animations:^{
        popupFrame.origin.y = 0;
        popupFrame.origin.x = 0;
        self.view.frame = popupFrame;
    }];
}

@end
