//
//  PopUpTopWinners.m
//  Bloomer
//
//  Created by Steven on 1/3/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "PopUpTopWinners.h"
#import "TopWinnerView.h"
#import "TopWinner.h"
#import "AppHelper.h"
#import "UIView+Extension.h"

@interface PopUpTopWinners ()

@property (strong, nonatomic) NSMutableArray *topWinnerViews;

@end

@implementation PopUpTopWinners

+ (id)createInView:(UIView*)view topWinners:(NSMutableArray*)topWinners flowers:(NSInteger)flowers navigation:(UINavigationController*) navigationController
{
    PopUpTopWinners *popupView = [[NSBundle mainBundle] loadNibNamed:@"PopUpTopWinners" owner:view options:nil][0];
    popupView.translatesAutoresizingMaskIntoConstraints = false;
    popupView.ownerView = view;
    popupView.navigationController = navigationController;
    [popupView setupScrollViewWithTopWinners:topWinners flowers:flowers];
    return popupView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.scrollView.delegate = self;
}

- (void)setupScrollViewWithTopWinners:(NSMutableArray*)topWinners flowers:(NSInteger)flowers
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.topWinnerViews = [[NSMutableArray alloc] init];
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = topWinners.count;
    self.contentViewWidth.constant = [UIScreen mainScreen].bounds.size.width * topWinners.count;
    
    __weak PopUpTopWinners *weakSelf = self;
    
    for (NSInteger i = 0; i < topWinners.count; i++)
    {
        TopWinner *topWinner = (TopWinner*)topWinners[i];
        TopWinnerView *topWinnerView = [[NSBundle mainBundle] loadNibNamed:@"TopWinnerView" owner:self.contentView options:nil][0];
        topWinnerView.translatesAutoresizingMaskIntoConstraints = false;
        topWinnerView.navigationController = self.navigationController;
        topWinnerView.parentView = self;
        [topWinnerView bindData:topWinner flowers:flowers];
        
        [self.contentView addSubview:topWinnerView];
        
        if (i == 0)
        {
            [AppHelper setupConstraintsForHorizontalView:topWinnerView previousView:nil isFirstView:true parentView:self.contentView width:screenWidth spacing:0];
        }
        else
        {
            UIView* previousView = self.topWinnerViews[i - 1];
            [AppHelper setupConstraintsForHorizontalView:topWinnerView previousView:previousView isFirstView:false parentView:self.contentView width:screenWidth spacing:0];
        }
        
        topWinnerView.didCompleteShareFacebook = ^{
            [weakSelf removeAnimate];
        };
        
        [self.topWinnerViews addObject:topWinnerView];
    }
}

// MARK: - Actions
- (IBAction)touchCloseButton:(id)sender
{
    [self removeAnimate];
}

// MARK: - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / UIScreen.mainScreen.bounds.size.width;
    self.pageControl.currentPage = index;
}

// MARK: - Required Functions
- (void)showAnimate
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    UIApplication.sharedApplication.keyWindow.windowLevel = UIWindowLevelStatusBar + 1;

    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            UIApplication.sharedApplication.keyWindow.windowLevel = UIWindowLevelNormal;
            [self removeFromSuperview];
        }
    }];
}

- (void)showWithAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ownerView addSubview:self];
        [self.ownerView addConstraints:[self getConstraintsWithParent:self.ownerView top:0 bottom:0 left:0 right:0]];
        [self.ownerView layoutIfNeeded];
        
        if (animated)
        {
            [self showAnimate];
        }
    });
}

@end
