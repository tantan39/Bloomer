//
//  PaymentViewController.m
//  Xinh
//
//  Created by Nguyen Thanh Tu on 12/18/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()
{
    UserDefaultManager *userDefaultManager;
    NSString *transactionID;
    BOOL isDeleted;
    NSInteger selectedIndex;
}
@end

@implementation PaymentViewController

@synthesize buyAPI, access_token;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];

    transactionID = @"";
    
    buyAPI = [[payment_buy_using alloc] init];
    buyAPI.myDelegate = self;
    
    for (UIView *view in [[[UIApplication sharedApplication] delegate] window].subviews) {
        if ([view isKindOfClass:[TabBarView class]])
        {
            _tabbar = (TabBarView *)view;
            break;
        }
    }
    
    [self updateFlowerValue];
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    _avatarImageAPI = [[hImage alloc] initWithUserId:[NSString stringWithFormat:@"%ld",(long)[userDefaultManager getUserProfileData].uid] andSize:@"m"];
    _avatarImageAPI.myDelegate = self;
    [_avatarImageAPI connect];
    
    _avatar.layer.borderWidth = 2.5f;
    _avatar.layer.borderColor = [userDefaultManager colorFromHexString:[userDefaultManager getUserProfileData].color_code].CGColor;
    _avatar.backgroundColor = [userDefaultManager colorFromHexString:[userDefaultManager getUserProfileData].color_code];
    _avatar.layer.cornerRadius = _avatar.frame.size.width / 2;
    _avatar.clipsToBounds = YES;
    
    _name.text = [userDefaultManager getUserProfileData].name;
    
    UIImage *img = [UIImage imageNamed:@"informationFrame.png"];
    UIImageView *background = [[UIImageView alloc] initWithImage:img];
    [background setFrame:CGRectMake(0, 0, _informationView.frame.size.width, _informationView.frame.size.height)];
    [_informationView addSubview:background];
    
    NSString *flowerValue = [NSString stringWithFormat: @"Have %lld Flowers", [userDefaultManager getUserProfileData].your_num_flower];
    _flowersLabel.text = flowerValue;
    
    access_token = [userDefaultManager getAccessToken];
    
    payment_package_fetch_using *packageAPI = [[payment_package_fetch_using alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                                          device_token:[userDefaultManager getDeviceToken]];
    packageAPI.myDelegate = self;
    [packageAPI connect];
}

- (void)getUIImage_hImage:(UIImage *)data {
    _avatar.image = data;
}

- (void)viewWillAppear:(BOOL)animated {
   
}

- (IBAction)touchBuyButton:(id)sender {
    
    //    [_BuyFlower setEnabled:FALSE];
    
    //    payment_buy *input = [[payment_buy alloc] initWithAccessToken:access_token device_token:[userDefaultManager getDeviceToken] money:0.99];
    //    [buyAPI selectInput:input];
    //    [buyAPI connect];
    
    
    
    //    payment_package *temp = [_packageData objectAtIndex:2];
    //
    //    _storeRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:temp.productIdentifier]];
    //    _storeRequest.delegate = self;
    //    [_storeRequest start];
    //
    //    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    NSString *transID = @"";
    
    if ([userDefaultManager getTransactionID] != nil)
    {
        transID = [userDefaultManager getTransactionID];
    }
    
    transaction_check *params = [[transaction_check alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                  device_token:[userDefaultManager getDeviceToken]
                                                         transactionIdentifier:transID];
    transaction_check_using *checkTransactionAPI = [[transaction_check_using alloc] init];
    [checkTransactionAPI selectInput:params];
    checkTransactionAPI.myDelegate = self;
    [checkTransactionAPI connect];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Errorrrrr");
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    NSUInteger count = [response.products count];
    
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)purchase:(SKProduct*)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)restore
{
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    
    for(SKPaymentTransaction *transaction in transactions){
        
        NSString *state = @"";
        NSString *transID = @"";
        NSString *transactionFail = @"";
        NSString *receiptData = @"";
        
        payment_package *temp = [_packageData objectAtIndex:selectedIndex];
        
        switch(transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                
                state = @"purchasing_start";
                
                break;
                
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                
                NSLog(@"Transaction state -> Purchased");
                
                state = @"purchased_success";
                transID = transaction.transactionIdentifier;
                receiptData = [transaction.transactionReceipt base64EncodedStringWithOptions:0];
                
                [userDefaultManager saveReceipt:receiptData];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                transID = transaction.transactionIdentifier;
                
                break;
                
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                
                state = @"purchased_failed";
                transactionFail = @"Fail";
                transID = transaction.transactionIdentifier;
                
                if(transaction.error.code == SKErrorPaymentCancelled)
                {
                    NSLog(@"Transaction state -> Cancelled");
                    transactionFail = @"Cancel";
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Failed"
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
                
                break;
        }
        
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
        NSString *currentTime = [dateFormatter stringFromDate:today];
        
        [userDefaultManager saveState:state];
        
        if ([state  isEqual: @"purchasing_start"])
        {
            [userDefaultManager saveProductID:temp.productIdentifier];
            [userDefaultManager saveTransactionDate:currentTime];
        }
        else
            if ([state  isEqual: @"purchased_failed"] && [transactionFail isEqualToString:@"Cancel"])
            {
                [userDefaultManager saveState:@"Cancel"];
            }
        
        payment_buy *params = [[payment_buy alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] transactionIdentifier:transactionID transactionIdentifierStore:transID state:state productIdentifier:temp.productIdentifier transactionDate:currentTime receipt_data:receiptData transactionFailBy:transactionFail];
        payment_buy_using *paymentAPI = [[payment_buy_using alloc] init];
        paymentAPI.myDelegate = self;
        [paymentAPI selectInput:params];
        [paymentAPI connect];
        
        //        if ([state  isEqual: @"purchasing_start"])
        //        {
        //            payment_buy *param1 = [[payment_buy alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] transactionIdentifier:@"" transactionIdentifierStore:transID state:@"purchasing_success" productIdentifier:temp.productIdentifier transactionDate:currentTime];
        //            [paymentAPI selectInput:param1];
        //            [paymentAPI connect];
        //
        //            payment_buy *param2 = [[payment_buy alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] transactionIdentifier:@"" transactionIdentifierStore:transID state:@"purchased_start" productIdentifier:temp.productIdentifier transactionDate:currentTime];
        //            [paymentAPI selectInput:param2];
        //            [paymentAPI connect];
        //        }
    }
}

- (void)initNavigationBar
{
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Btn_Settings_Normal.png"] style:UIBarButtonItemStylePlain target:self action:@selector(touchSettingsButton)];
    settingsButton.tintColor = [UIColor whiteColor];
    
//    UIBarButtonItem *notificationButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Btn_Notification_Normal.png"] style:UIBarButtonItemStylePlain target:self action:@selector(touchNotificationButton)];
//    notificationButton.tintColor = [UIColor whiteColor];

    UIButton *noti = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *notiB = [UIImage imageNamed:@"Btn_Notification_Normal.png"];
    [noti setBackgroundImage:notiB forState:UIControlStateNormal];
    [noti addTarget:self action:@selector(touchNotificationButton) forControlEvents:UIControlEventTouchUpInside];
    noti.frame = CGRectMake(0, 0, 21, 25);
    UIView *notiButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 21, 25)];
    [notiButtonView addSubview:noti];
    UIBarButtonItem *notificationButton = [[UIBarButtonItem alloc] initWithCustomView:notiButtonView];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:settingsButton, notificationButton, nil]];
    //[self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:notificationButton, nil]];
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:NAVIGATION_TITLE_FONT_NAME size:NAVIGATION_TITLE_FONT_SIZE];
    titleView.textColor = [UIColor whiteColor]; // Your color here
    titleView.text = @"Store";
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    /*
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7"))
    {
        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"Btn_Back_Normal.png"]];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"Btn_Back_Normal.png"]];
    }*/
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void) touchNotificationButton
{
    NotificationViewController *view;
    
//    if (IS_IPHONE_5)
//    {
        view = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
//    }
//    else
//        if (IS_IPHONE_4)
//        {
//            view = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController_ip4" bundle:nil];
//        }
    
    view.hidesBottomBarWhenPushed = TRUE;
    [self.navigationController pushViewController:view animated:TRUE];
}

- (void)touchSettingsButton
{
    SettingsViewController *view;
//    if (IS_IPHONE_5)
//    {
        view = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
//    }
//    else
//        if (IS_IPHONE_4)
//        {
//            view = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController_ip4" bundle:nil];
//        }
    
    view.hidesBottomBarWhenPushed = TRUE;
    [self.navigationController pushViewController:view animated:TRUE];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_tabbar updateFlowerValue];
    [self updateFlowerValue];
}

- (void)getDatapayment_Buy:(out_payment_buy *)data
{
    if ([data getStt])
    {
        if (isDeleted)
        {
            if ([data.state  isEqual: @"purchasing_start"])
            {
                transactionID = data.transactionIdentifier;
                [userDefaultManager saveTransactionID:transactionID];
            }
            else
            {
                transactionID = @"";
                [userDefaultManager saveTransactionID:@""];
                
                if (data.num_flower != 0)
                {
                    out_profile_fetch *profileData = [userDefaultManager getUserProfileData];
                    profileData.your_num_flower = data.num_flower;
                    [userDefaultManager saveUserProfileData:profileData];
                    [_tabbar updateFlowerValue];
                    [self updateFlowerValue];
                    
                    [userDefaultManager saveReceipt:@""];
                    [userDefaultManager saveState:@""];
                }
                
                [_tableView setUserInteractionEnabled:TRUE];
            }
        }
        else
        {
            if ([data.state isEqualToString:@"purchasing_start"])
            {
                transactionID = data.transactionIdentifier;
                [userDefaultManager saveTransactionID:transactionID];
            }
            else
                if ([data.state isEqualToString:@"purchased_success"]) {
                    transactionID = @"";
                    [userDefaultManager saveTransactionID:transactionID];
                    out_profile_fetch *profileData = [userDefaultManager getUserProfileData];
                    profileData.your_num_flower = data.num_flower;
                    [userDefaultManager saveUserProfileData:profileData];
                    [_tabbar updateFlowerValue];
                    [self updateFlowerValue];
                    
                    [userDefaultManager saveReceipt:@""];
                    [userDefaultManager saveState:@""];
                }
                else
                {
                    transactionID = @"";
                    [userDefaultManager saveTransactionID:transactionID];
                    [userDefaultManager saveReceipt:@""];
                    [userDefaultManager saveState:@""];
                }
            
            isDeleted = TRUE;
            payment_package *temp = [_packageData objectAtIndex:selectedIndex];
            
            _storeRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:temp.productIdentifier]];
            _storeRequest.delegate = self;
            [_storeRequest start];
            
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
        }
    }
    else
    {
        NSLog(@"%@", data.getMegs);
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
        //                                                        message:data.getMegs
        //                                                       delegate:self
        //                                              cancelButtonTitle:@"OK"
        //                                              otherButtonTitles:nil];
        //        [alert show];
    }
    
    //    [_BuyFlower setEnabled:TRUE];
}

- (void)requestFailed_Payment_Buy
{
    [_tableView setUserInteractionEnabled:TRUE];
}

- (void)updateFlowerValue
{
    NSString *string = [NSString stringWithFormat:@"%@ flowers to give away", _tabbar.flowerValue.text];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.341 green:0.392 blue:0.471 alpha:1.0] range:[string rangeOfString:@"to give away"]];
    _numberFlower.attributedText = attributedString;
}

- (void)getDataPayment_Package_Fetch:(out_payment_package_fetch *)data
{
    if ([data getStt])
    {
        _packageData = data.payments;
        [_tableView reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[data getTitle]
                                                        message:data.getMegs
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)getDataTransaction_Check:(out_transaction_check *)data
{
    if ([data getStt])
    {
        if (data.isDel)
        {
            isDeleted = TRUE;
            payment_package *temp = [_packageData objectAtIndex:selectedIndex];
            
            _storeRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:temp.productIdentifier]];
            _storeRequest.delegate = self;
            [_storeRequest start];
            
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
        }
        else
        {
            isDeleted = FALSE;
            NSString* state = [userDefaultManager getState];
            NSString* failState = @"";
            
            if ([state isEqualToString:@"Cancel"])
            {
                state = @"purchased_failed";
                failState = @"Cancel";
            }
            else
                if ([state isEqualToString:@"purchased_failed"])
                {
                    failState = @"Fail";
                }
            
            payment_buy *params = [[payment_buy alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                              device_token:[userDefaultManager getDeviceToken]
                                                     transactionIdentifier:[userDefaultManager getTransactionID]
                                                transactionIdentifierStore:@""
                                                                     state:state
                                                         productIdentifier:[userDefaultManager getProductID]
                                                           transactionDate:[userDefaultManager getTransactionDate]
                                                              receipt_data:[userDefaultManager getReceipt]
                                                         transactionFailBy:failState];
            
            payment_buy_using *paymentAPI = [[payment_buy_using alloc] init];
            paymentAPI.myDelegate = self;
            [paymentAPI selectInput:params];
            [paymentAPI connect];
        }
    }
    else
    {
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _packageData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Payment";
    PaymentTableViewCell *cell = (PaymentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"PaymentTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    payment_package *temp = [_packageData objectAtIndex:indexPath.row];
    cell.flower.text = [NSString stringWithFormat:@"%ld flowers", (long)temp.flower];
    cell.money.text = [NSString stringWithFormat:@"%.0f", temp.money];

//    cell.textLabel.text = [NSString stringWithFormat:@"%.0f VND - %ld flowers", temp.money, (long)temp.flower];
//    cell.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:20];
//    cell.textLabel.textColor = [UIColor redColor];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    if (indexPath.row == 0) {
        [cell.star2 setHidden:TRUE];
        [cell.star3 setHidden:TRUE];
        [cell.star4 setHidden:TRUE];
    } else if (indexPath.row == 1) {
        [cell.star2 setHidden:FALSE];
        [cell.star3 setHidden:TRUE];
        [cell.star4 setHidden:TRUE];
    } else if (indexPath.row == 2) {
        [cell.star2 setHidden:FALSE];
        [cell.star3 setHidden:FALSE];
        [cell.star4 setHidden:TRUE];
    } else {
        [cell.star2 setHidden:FALSE];
        [cell.star3 setHidden:FALSE];
        [cell.star4 setHidden:FALSE];
    }
    
    cell.normalBackground.layer.cornerRadius = 5;
    //cell.normalBackground.layer.borderColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1.0].CGColor;
    //cell.normalBackground.layer.borderWidth = 0.2;
    cell.normalBackground.clipsToBounds = TRUE;
    
    cell.selectedBackground.layer.cornerRadius = 5;
    //cell.selectedBackground.layer.borderColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1.0].CGColor;
    //cell.selectedBackground.layer.borderWidth = 0.2;
    cell.selectedBackground.clipsToBounds = TRUE;
    
    if (self.selectedItemIndexPath != nil && [indexPath compare:self.selectedItemIndexPath] == NSOrderedSame) {
        [cell.selectedBackground setHidden:FALSE];
        cell.money.textColor = [UIColor whiteColor];
        cell.vnd.textColor = [UIColor whiteColor];
        
    } else {
        [cell.selectedBackground setHidden:TRUE];
        cell.money.textColor = [UIColor blackColor];
        cell.vnd.textColor = [UIColor blackColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    PaymentTableViewCell *cell = (PaymentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [self setCellColor:[UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1.0] ForCell:cell];
//}
//
//- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
//    cell.contentView.backgroundColor = color;
//    cell.backgroundColor = color;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_butButton setEnabled:TRUE];
    selectedIndex = indexPath.row;
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    
    if (self.selectedItemIndexPath)
    {
        if ([indexPath compare:self.selectedItemIndexPath] != NSOrderedSame)
        {
            [indexPaths addObject:self.selectedItemIndexPath];
            self.selectedItemIndexPath = indexPath;
        }
    }
    else
    {
        self.selectedItemIndexPath = indexPath;
    }
    
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}


@end
