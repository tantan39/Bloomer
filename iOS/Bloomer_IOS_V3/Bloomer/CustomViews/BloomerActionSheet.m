//
//  ImagePickerPopUpViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 6/15/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "BloomerActionSheet.h"
#import "UserDefaultManager.h"
#import "AppHelper.h"

@interface BloomerActionSheet ()
{
    UIAlertController *alertController;
}
@end

@implementation BloomerActionSheet

+ (id) createInView:(UIView *)view data: (NSArray*)data selectIndex: (void(^)(NSInteger)) selectIndex {
    BloomerActionSheet * menu = [[BloomerActionSheet alloc] initWithNibName:@"BloomerActionSheet" bundle:nil];
    menu.ownerView = view;
    menu.list = data;
    menu.selectIndex = selectIndex;
    menu.isShowCanel = TRUE;
    menu.view.frame = [UIScreen mainScreen].bounds;
    return menu;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        
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
    self.view.backgroundColor = [UIColor clearColor];
    if (self.list == nil) {
        self.list = [[NSArray alloc] init];
    }
    
    if (self.textCancel == nil) {
        self.textCancel = [AppHelper getLocalizedString: @"BloomerActionSheet.cancel"];
    }
    
    alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    for (int i = 0; i < self.list.count; i ++) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:self.list[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.selectIndex(i);
            [self touchBackground:nil];
        }];
        [alertController addAction:alertAction];
    }
    if (self.isShowCanel) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:self.textCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self touchBackground:nil];
        }];
        [alertController addAction:cancelAction];
    }
 

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

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
    [self.view removeFromSuperview];
}

- (IBAction)touchBackground:(id)sender {
    [self removeAnimate];
}

- (void)showWithAnimation: (BOOL)animated
{
    if (self.ownerView == nil) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ownerView addSubview:self.view];
        if (animated) {
            [self showAnimate];
        }
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

@end
