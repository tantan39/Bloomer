//
//  FlowerGardenViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/18/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BuyFlowerConfirmViewController.h"
#import "UserDefaultManager.h"

#import <StoreKit/StoreKit.h>

#import "API_Transaction_Check.h"
#import "API_PaymentBuy.h"
#import "API_Payment_PackageFetch.h"

#import "out_profile_update.h"
#import "out_profile_fetch.h"

#import "FlowerItemTableViewCell.h"
#import "UIColor+Extension.h"
#import "AppHelper.h"


@interface FlowerGardenViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,  SKProductsRequestDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblflowerNumber;
@property (weak, nonatomic) IBOutlet UITableView *packageTableView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSecondTitle;
@property (strong, nonatomic) IBOutlet UIImageView *pictureFlowerShop;
@property (weak, nonatomic) IBOutlet UIButton *buyNowButton;
@property (weak, nonatomic) IBOutlet UIImageView *PictureFlowerShop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeightConstraint;

- (IBAction)touchBuyNow:(id)sender;


@end
