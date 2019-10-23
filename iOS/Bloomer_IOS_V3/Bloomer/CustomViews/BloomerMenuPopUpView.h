//
//  MenuProfilPopUpView.h
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 11/20/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import "Support.h"
#import "MySettingViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BloomerMenuPopUpView : UIView <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSArray * list;
@property (weak, nonatomic) UIView *ownerView;
@property (weak, nonatomic) UIViewController *parentViewController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContentConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) void (^selectIndex)(NSInteger);

+ (id) createInView:(UIView *)view data: (NSArray*)data selectIndex: (void(^)(NSInteger)) selectIndex;
- (void)show;
- (void)handleDismiss;

@end

NS_ASSUME_NONNULL_END
