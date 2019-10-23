//
//  DiscoveryPopupViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/21/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "DiscoveryPopupViewController.h"
#import "ChooseLocationViewController.h"

@interface DiscoveryPopupViewController () {
    UserDefaultManager *userDefaultManager;
    DiscoveryViewController *parent;
    city* selectedCity;
    UIColor* highlightColor;
    GENDER selectedGender;
}

@end

@implementation DiscoveryPopupViewController

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
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    _selectionView.layer.cornerRadius = 20;
    _doneButton.layer.cornerRadius = 10;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(closePopup)];
    
    [self.view addGestureRecognizer:tap];
    highlightColor = [_genderButton backgroundColor];
    parent = (DiscoveryViewController *)_parentView;
    selectedGender = parent.gender;
    [self updateLayout];
}

-(void)updateLayout{
    switch (selectedGender) {
        case FEMALE:
            [_femaleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_maleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_genderButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_femaleButton setBackgroundColor:highlightColor];
            [_maleButton setBackgroundColor:[UIColor clearColor]];
            [_genderButton setBackgroundColor:[UIColor clearColor]];
            break;
        case MALE:
            [_femaleButton setBackgroundColor:[UIColor clearColor]];
            [_maleButton setBackgroundColor:highlightColor];
            [_genderButton setBackgroundColor:[UIColor clearColor]];
            [_femaleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_maleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_genderButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            break;
        default:
            [_femaleButton setBackgroundColor:[UIColor clearColor]];
            [_maleButton setBackgroundColor:[UIColor clearColor]];
            [_genderButton setBackgroundColor:highlightColor];
            [_femaleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_maleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_genderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
    }
    
    [_cityLabel setText:parent.filterCity.city_name];
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

- (void)closePopup {
    [self removeAnimate];
}

- (IBAction)touchDone:(id)sender {
    [self removeAnimate];
    parent.isRefresh = TRUE;
    parent.userID = 0;
    parent.loadedItemIndex = 0;
    parent.gender = selectedGender;
    [parent saveFilterOptions];
    [parent pullToRefresh];
}

- (IBAction)touchFemale:(id)sender {
    selectedGender = FEMALE;
    [self updateLayout];
    
}

- (IBAction)touchMale:(id)sender {
    selectedGender = MALE;
    [self updateLayout];
}

- (IBAction)touchGender:(id)sender {
    selectedGender = BOTH_FEMALE_MALE;
    [self updateLayout];

}

- (IBAction)touchChange:(id)sender {
    [self removeAnimate];
//    ChoosingLocationViewController *view = [[ChoosingLocationViewController alloc] initWithNibName:@"ChoosingLocationViewController" bundle:nil];
//    view.parentView = _parentView;
//    [parent.navigationController pushViewController:view animated:YES];
    ChooseLocationViewController *view = [[ChooseLocationViewController alloc] initWithNibName:@"ChooseLocationViewController" bundle:nil];
    view.isSetting = FALSE;
    view.parentView = parent;
    [parent.navigationController pushViewController:view animated:YES];
}

@end
