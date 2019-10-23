//
//  WelcomeViewController.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 10/16/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "SelectScreenViewController.h"
#import "AppHelper.h"
#import "LoginViewController.h"
@interface SelectScreenViewController () {
    NSTimer *timer;
    BOOL isOutScreen;
    BOOL isFirstLoad;
}
@end

@implementation SelectScreenViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:[AppHelper getScreenNameView: nibNameOrNil] bundle:nibBundleOrNil];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpPageViewController];
    [self.pageControl setCurrentPage:0];
    [self setUpButton];
    isOutScreen = FALSE;
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
    isFirstLoad = true;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    isOutScreen = FALSE;
    [self.navigationController setNavigationBarHidden:TRUE];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setUpTimer];
    if (isFirstLoad) {
        [self.scrollview setDelegateForViews:self pageCurrent:1];
        [self.scrollview setContentOffset:CGPointMake(0, 0) animated:TRUE];
        isFirstLoad = false;
    }

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    isOutScreen = TRUE;
    [self invalidateTimer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) setUpPageViewController {
    
    self.arrPageTitles = @[[AppHelper getLocalizedString:@"selecSceen.titleWelcome1Label"],[AppHelper getLocalizedString:@"selecSceen.titleWelcome2Label"],[AppHelper getLocalizedString:@"selecSceen.titleWelcome3Label"],[AppHelper getLocalizedString:@"selecSceen.titleWelcome4Label"],[AppHelper getLocalizedString:@"selecSceen.titleWelcome5Label"]];
    self.arrPageImages =@[@"welcome1",@"welcome2",@"welcome3",@"welcome4",@"welcome5"];
    self.pageIndex = 0;
    self.scrollview.delegate = self;
}

- (void) setUpButton {
    [self.buttonSignUp setTitle: [AppHelper getLocalizedString:@"Sign Up"] forState:UIControlStateNormal];
    self.buttonSignUp.layer.cornerRadius = 4;
    [self.buttonSignIn setTitle: [AppHelper getLocalizedString:@"Sign In"] forState:UIControlStateNormal];
    self.buttonSignIn.layer.cornerRadius = 4;
    self.buttonSignIn.layer.borderColor = [[UIColor rgb:178 green:34 blue:37] CGColor];
    self.buttonSignIn.layer.borderWidth = 2.0f;
}

- (void) setUpTimer {
    [self invalidateTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(changePage) userInfo:nil repeats:FALSE];
}

- (void) invalidateTimer {
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
}

- (void) changePage {
    if (isOutScreen) {
        return;
    }
    if (self.pageIndex < 4) {
        self.pageIndex ++;
    } else {
        self.pageIndex = 0;
    }
    [self.scrollview setContentOffset:CGPointMake(self.scrollview.contentOffset.x + self.scrollview.frame.size.width, 0) animated:TRUE];
}

- (PageContentViewController *) viewControllerAtIndex:(NSUInteger)index {
    
    PageContentViewController *pageContentViewController = [[PageContentViewController alloc] initWithNibName:[AppHelper getScreenNameView:@"PageContentViewController"] bundle:nil];
    pageContentViewController.imgFile = self.arrPageImages[index];
    pageContentViewController.txtTitle = self.arrPageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
    
}



- (IBAction)signUpTapper:(id)sender {
    SignUpVC * signUpVC = [[SignUpVC alloc] init];
    [self.navigationController pushViewController:signUpVC animated:true];
}

- (IBAction)signInTapper:(id)sender {
    LoginViewController *view = [[LoginViewController alloc] initWithNibName:[AppHelper getScreenNameView:@"LoginViewController"] bundle:nil];
    
    [self.navigationController pushViewController:view animated:TRUE];
}

- (NSUInteger)noOfViews {
    return [self.arrPageImages count];
}

- (UIView*)setupView:(UIView *)reusableView forPosition:(NSUInteger)position{
    UIView* view=reusableView;
    
    if(view==nil) {
        PageContentViewController *viewController = [self viewControllerAtIndex: 0];
        view = viewController.view;
        view.frame = self.scrollview.bounds;
    }
    
    for (UIView* child in [view subviews]) {
        if (child.tag == 111) {
            ((UILabel*)child).text = [self.arrPageTitles objectAtIndex:position];
        } else if (child.tag == 222) {
            ((UIImageView*)child).image = [UIImage imageNamed:[self.arrPageImages objectAtIndex:position]];
        }
    }
    self.pageIndex = [self.scrollview getCurrentPage];
    [self setUpTimer];
    [self.pageControl setCurrentPage:[self.scrollview getCurrentPage]];

    return view;
}

- (void)clearView:(UIView*)reusableView {
    for (UIView* child in [reusableView subviews]) {
        if (child.tag == 111) {
            ((UILabel*)child).text = @"";
        } else if (child.tag == 222) {
            ((UIImageView*)child).image = nil;
        }
    }
}

@end
