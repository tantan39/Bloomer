//
//  PaymentViewController.h
//  Xinh
//
//  Created by Nguyen Thanh Tu on 12/18/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "payment_buy_using.h"
#import "UserDefaultManager.h"
#import "out_profile_update.h"
#import "out_profile_fetch.h"
#import "APIDefine.h"
#import "TabBarView.h"
#import "SettingsViewController.h"
#import "NotificationViewController.h"
#import "payment_package_fetch_using.h"
#import <StoreKit/StoreKit.h>
#import "transaction_check_using.h"
#import "AppDelegate.h"
#import "PaymentTableViewCell.h"
#import "hImage.h"

@interface PaymentViewController : UIViewController<payment_BuyDelegate, payment_package_fetchDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, transaction_checkDelegate, UITableViewDataSource, UITableViewDelegate, himageDelegate>
@property (weak, nonatomic) IBOutlet UIButton *BuyFlower;
@property (weak, nonatomic) IBOutlet UILabel *numberFlower;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (strong ,nonatomic) hImage* avatarImageAPI;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIView *informationView;
@property (weak, nonatomic) IBOutlet UILabel *flowersLabel;
@property (weak, nonatomic) IBOutlet UIButton *butButton;

@property (strong, nonatomic) payment_buy_using *buyAPI;
@property (strong, nonatomic) NSString *access_token;
@property (weak, nonatomic) TabBarView *tabbar;
@property (weak, nonatomic) NSMutableArray *packageData;
@property (strong, nonatomic) SKProductsRequest *storeRequest;
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

- (IBAction)touchBuyButton:(id)sender;
- (void)initNavigationBar;

@end
