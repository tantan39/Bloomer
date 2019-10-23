//
//  MessagePopupRacesViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/9/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "MessagePopupRacesViewController.h"
#import "AnonymousUserProfileViewController.h"
#import "AppHelper.h"

@interface MessagePopupRacesViewController ()

@end

@implementation MessagePopupRacesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        if (SYSTEM_VERSION_LESS_THAN(@"7"))
        {
            CGRect frame = self.view.frame;
            frame.size.height += 20;
            self.view.frame = frame;
        }
        if(IS_IPHONE_4)
        {
            CGRect frame = self.view.frame;
            frame.size.height -= DELTA_IPHONE_4;
            self.view.frame = frame;
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _isTour = false;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    _cellView.layer.cornerRadius = 8;
    _avatar.layer.cornerRadius = _avatar.frame.size.height / 2;
    _avatar.layer.borderWidth = 2;
    _avatar.layer.borderColor = [UIColor colorWithRed:0.125 green:0.125 blue:0.129 alpha:1.0].CGColor;
    _avatar.clipsToBounds = TRUE;
    _numberLabel.text = _number;
    _messageLabel.text = _message;
    [_avatar setImageWithURL:[NSURL URLWithString:_avatarString]];
    _nameLabel.text = _name;
    _usernameLabel.text = _username;
    _numberFlowerLabel.text = _numberFlower;
    
    if(_isSurpriseFunc == true)
    {
        [_BubbleBlueMessage setHidden:true];
        [_TriangularBubblePart setHidden:true];
        [_StatusIcon setHidden:true];
        [_InfoLabel setHidden:true];
    }
    
    CGRect frame = _popupView.frame;
    frame.origin.y = _distance + 20 + 44;
    [_popupView setFrame:frame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        if (animated) {
            [self showAnimate];
        }
    });
}


- (IBAction)handleSingleTap:(id)sender {
    
    RacesViewController* view = (RacesViewController*)_parentView;
    
    [view hideSearchBar];
    
    [self removeAnimate];
    
}
- (IBAction)ClickCell:(id)sender
{
    [self removeAnimate];
    
    UserDefaultManager *userDefaultManager = [[UserDefaultManager alloc] init];
    
    if ([userDefaultManager isAnonymous])
    {
        AnonymousUserProfileViewController *view = [[AnonymousUserProfileViewController alloc] initWithNibName:@"AnonymousUserProfileViewController" bundle:nil];
        view.uid = _uid;
        
        [self.MyNavigationController pushViewController:view animated:YES];
    }
    else
    {
        UserProfileViewController *view;
        view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
        
        view.uid = _uid;
        
        [self.MyNavigationController pushViewController:view animated:YES];
    }
}
@end
