//
//  FlowerMenuPostPopupViewController.m
//  Xinh
//
//  Created by Truong Thuan Tai on 12/19/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "FlowerMenuPostPopupViewController.h"
#import "FullPictureViewController.h"
#import "PhotoListViewController.h"

@interface FlowerMenuPostPopupViewController ()
{
    UserDefaultManager *userDefaultManager;
    CGFloat backUpY;
}
@end

@implementation FlowerMenuPostPopupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        userDefaultManager = [[UserDefaultManager alloc] init];
        
        if (SYSTEM_VERSION_LESS_THAN(@"7"))
        {
            CGRect frame = self.view.frame;
            frame.size.height += 20;
            self.view.frame = frame;
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    _editorField.layer.cornerRadius = _editorField.frame.size.height / 2;
    _buttonCancel.layer.cornerRadius = 20;
    _buttonSend.layer.cornerRadius = 20;
    CGRect cancelFrame =  _buttonCancel.frame;
    cancelFrame.origin.y = 342;
    [_buttonCancel setFrame:cancelFrame];
    CGRect okFrame = _buttonSend.frame;
    okFrame.origin.y = 342;
    [_buttonSend setFrame:okFrame];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:@"UIKeyboardWillHideNotification"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIKeyboardWillHideNotification" object:nil];
    
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [self.view setFrame:aView.bounds];
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        if (animated) {
            [self showAnimate];
        }
    });
}

- (IBAction)closePopup:(id)sender {
    [self removeAnimate];
    [self.view endEditing:YES];
    [self.delegate didEndEditing:[_editorField.text integerValue] isCanel:YES];
}

- (IBAction)touchBackground:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)touchSendButton:(id)sender {
    if (![_editorField.text isEqualToString:@""] && [_editorField.text integerValue] > 0)
    {
        [self.delegate didEndEditing:[_editorField.text integerValue] isCanel:NO];
        
        if ([_parentView isKindOfClass:[RacesViewController class]]) {
            RacesViewController *view = (RacesViewController *)_parentView;
            [view giveFlower:_editorField.text.integerValue];
        } else if ([_parentView isKindOfClass:[PhotosTaggedInRacesViewController class]]) {
            PhotosTaggedInRacesViewController *view = (PhotosTaggedInRacesViewController *)_parentView;
            [view giveFlower:_editorField.text.integerValue];
        } else if ([_parentView isKindOfClass:[FriendsUpdateViewController class]]) {
            FriendsUpdateViewController *view = (FriendsUpdateViewController *)self.parentView;
            
            if (self.isProfile) {
                [view giveFlowerProfile:self.editorField.text.integerValue];
            } else {
                [view giveFlowerPost:self.editorField.text.integerValue];
            }
        } else if ([_parentView isKindOfClass:[FullPictureViewController class]]) {
            FullPictureViewController *view = (FullPictureViewController *)_parentView;
            [view giveFlowerPost:_editorField.text.integerValue];
        } else if ([_parentView isKindOfClass:[DiscoveryViewController class]]) {
            DiscoveryViewController *view = (DiscoveryViewController *)_parentView;
            
            if (_isProfile) {
                [view giveFlowerProfile:_editorField.text.integerValue];
            } else {
                [view giveFlowerPost:_editorField.text.integerValue];
            }
        } else if ([_parentView isKindOfClass:[UserProfileViewController class]]) {
            UserProfileViewController *view = (UserProfileViewController *)_parentView;
            [view giveFlower:_editorField.text.integerValue];
        } else if ([_parentView isKindOfClass:[ChatViewController class]]) {
//            [self.delegate didEndEditing:[_editorField.text integerValue]];
        } else if ([_parentView isKindOfClass:[PicturesRaceViewController class]]) {
            PicturesRaceViewController *view = (PicturesRaceViewController*)_parentView;
            [view giveFlowerPost:_editorField.text.integerValue];
        }
        else if([_parentView isKindOfClass:[PhotoListViewController class]])
        {
            PhotoListViewController *view = (PhotoListViewController*)_parentView;
            [view giveFlowerPost:_editorField.text.integerValue postID:_postID receiverID:_uid];
        }
        
        [self removeAnimate];
    }
    else
    {
        [_warningLabel setHidden:FALSE];
        [_warningLabel setTextColor:[UIColor whiteColor]];
        _warningLabel.text =NSLocalizedString(@"This number is invalid", @"This number is invalid") ;
        
        /*[UIView animateWithDuration:.25 animations:^{
            [_popupView setFrame:CGRectMake(_popupView.frame.origin.x, backUpY - 20, _popupView.frame.size.width, _popupView.frame.size.height)];
            [_editorField setFrame:CGRectMake(_editorField.frame.origin.x, _warningLabel.frame.origin.y + _warningLabel.frame.size.height, _editorField.frame.size.width, _editorField.frame.size.height)];
            [_buttonCancel setFrame:CGRectMake(_buttonCancel.frame.origin.x, _editorField.frame.origin.y + _editorField.frame.size.height + 10, _buttonCancel.frame.size.width, _buttonCancel.frame.size.height)];
            [_buttonOK setFrame:CGRectMake(_buttonOK.frame.origin.x, _editorField.frame.origin.y + _editorField.frame.size.height + 10, _buttonOK.frame.size.width, _buttonOK.frame.size.height)];
        } completion:^(BOOL finished) {
            if (finished) {
            }
        }];
        */
        [_editorField setBackgroundColor:[UIColor colorWithRed:0.89 green:0.31 blue:0.31 alpha:1.0]];
    }
}

//- (void)getDataFlower_give:(out_flower_give *)data
//{
//    if ([data getStt])
//    {
//        [userDefaultManager didTutorialGiveFlowerRace:TRUE];
//        [self removeAnimate];
//        
//        _faceData.num_flower = data.num_flower;
//        
//        out_profile_fetch *profileData = [userDefaultManager getUserProfileData];
//        profileData.your_num_flower = data.my_nFlower;
//        
//        if (profileData.uid == data.receiver)
//        {
//            profileData.num_received_flower = data.model_nflower;
//        }
//        
//        [userDefaultManager saveUserProfileData:profileData];
//        
//        if ([_parentView isKindOfClass:[MyProfileViewController class]])
//        {
//            MyProfileViewController *view = (MyProfileViewController*)_parentView;
//            
//            //[view.tabbar updateFlowerValue];
//            [view AddThankYouView];
////            view.flowerValue.text = @(data.model_nflower).stringValue;
//            [view.tableView reloadData];
//            
//            [view initProfile];
//        }
//        else
//            if ([_parentView isKindOfClass:[UserProfileViewController class]])
//            {
//                UserProfileViewController *view = (UserProfileViewController*)_parentView;
//                
//                [view.tabbar updateFlowerValue];
//                /* VL
//                [view AddThankYouView];
//                view.flowerValue.text = @(data.model_nflower).stringValue;
//                [view.tableView reloadData];
//                
//                [view updateFlowerInProfileData:data.model_nflower];
//                [view initProfile];*/
//            }
//            else
//                if ([_parentView isKindOfClass:[FullPictureViewController class]])
//                {
//                    FullPictureViewController* view = (FullPictureViewController*)_parentView;
//                    
//                    [view.tabbar updateFlowerValue];
//                    view.labelFlower.text = @(_faceData.num_flower).stringValue;
//                    [view AddThankYouView];
//                }
//        
//        _editorField.text = @"";
//    }
//    else
//    {
//        if ([data getCode] == 479)
//        {
//            [_warningLabel setHidden:FALSE];
//            _warningLabel.text = NSLocalizedString(@"This number is invalid",@"This number is invalid");
//            /*
//            [UIView animateWithDuration:.25 animations:^{
//                [_popupView setFrame:CGRectMake(_popupView.frame.origin.x, backUpY - 20, _popupView.frame.size.width, _popupView.frame.size.height)];
//                [_editorField setFrame:CGRectMake(_editorField.frame.origin.x, _warningLabel.frame.origin.y + _warningLabel.frame.size.height, _editorField.frame.size.width, _editorField.frame.size.height)];
//                [_buttonCancel setFrame:CGRectMake(_buttonCancel.frame.origin.x, _editorField.frame.origin.y + _editorField.frame.size.height + 10, _buttonCancel.frame.size.width, _buttonCancel.frame.size.height)];
//                [_buttonOK setFrame:CGRectMake(_buttonOK.frame.origin.x, _editorField.frame.origin.y + _editorField.frame.size.height + 10, _buttonOK.frame.size.width, _buttonOK.frame.size.height)];
//            } completion:^(BOOL finished) {
//                if (finished) {
//                }
//            }]; */
//        }
//        else
//            if ([data getCode] == 412)
//            {
//                [_warningLabel setHidden:FALSE];
//                _warningLabel.text = NSLocalizedString(@"This exceeds the number of flowers you currently have!",nil);
//                /*
//                [UIView animateWithDuration:.25 animations:^{
//                    [_popupView setFrame:CGRectMake(_popupView.frame.origin.x, backUpY - 20, _popupView.frame.size.width, _popupView.frame.size.height)];
//                    [_editorField setFrame:CGRectMake(_editorField.frame.origin.x, _warningLabel.frame.origin.y + _warningLabel.frame.size.height + 10, _editorField.frame.size.width, _editorField.frame.size.height)];
//                    [_buttonCancel setFrame:CGRectMake(_buttonCancel.frame.origin.x, _editorField.frame.origin.y + _editorField.frame.size.height + 10, _buttonCancel.frame.size.width, _buttonCancel.frame.size.height)];
//                    [_buttonOK setFrame:CGRectMake(_buttonOK.frame.origin.x, _editorField.frame.origin.y + _editorField.frame.size.height + 10, _buttonOK.frame.size.width, _buttonOK.frame.size.height)];
//                } completion:^(BOOL finished) {
//                    if (finished) {
//                    }
//                }]; */
//            }
//            else
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[data getTitle]
//                                                                message:[data getMegs]
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
//                
//            }
//        
//        [_editorField setBackgroundColor:[UIColor colorWithRed:0.89 green:0.31 blue:0.31 alpha:1.0]];
//    }
//}

- (void) keyboardWillShow:(NSNotification *)note
{
//    NSDictionary *userInfo = [note userInfo];
//    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect kbSize = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbSize = [self.view convertRect:kbSize fromView:nil];

    CGFloat offSet = self.view.bounds.size.height - (_buttonCancel.frame.origin.y + _buttonCancel.bounds.size.height + 10) - kbSize.size.height ;
    
    if (offSet < 0) {
        [self.view setFrame:CGRectMake(0, offSet, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
}

- (void) keyboardWillHide:(NSNotification *)note
{
    //    NSDictionary *userInfo = [note userInfo];
    //    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect frame = _popupView.frame;
    if (IS_IPHONE_5)
    {
        frame.origin.y = 160;
    }
    else
        if (IS_IPHONE_4)
        {
            frame.origin.y = 125;
        }
    
    [UIView animateWithDuration:0.3 animations:^{
        _popupView.frame = frame;
    }];
}


@end
