//
//  FlowerGardenViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/18/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "FlowerGardenViewController.h"
#import "NSNumber+Extension.h"

@interface FlowerGardenViewController () {
    BuyFlowerConfirmViewController *popupBuyFlowerConfirm;
    UserDefaultManager *userDefaultManager;
    NSInteger selectedIndex;
    NSMutableArray *packageData;
    NSString* productId;
    IAPHelper *helper;
    BOOL packSelected;
}

@property (strong, nonatomic) SKProductsRequest *storeRequest;
@property (weak, nonatomic) IBOutlet UIImageView *bgFlowerNumber;

@end
static NSString *identifier = @"FlowerPackage";
@implementation FlowerGardenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    packSelected = NO;
    
    self.buyNowButton.layer.cornerRadius = self.buyNowButton.frame.size.height / 2;
    self.buyNowButton.layer.borderWidth = 2;
    self.buyNowButton.layer.borderColor = [UIColor colorFromHexString:@"#202021"].CGColor;
    self.buyNowButton.clipsToBounds = true;
    
    [self initNavigationBar];
    
    [self updateFlowerValue];
    
//    [self.pictureFlowerShop setHidden:false];
//    [self.labelTitle setHidden:true];
//    [self.labelSecondTitle setHidden:true];
    
    self.pictureFlowerShop.contentMode = UIViewContentModeScaleAspectFit;
    __weak typeof(self) weakSelf = self;
    [[IAPHelper sharedInstance] setPaymentSuccess_callback:^{
        [weakSelf updateFlowerValue];
    }];
    
    [self.packageTableView registerNib:[UINib nibWithNibName:@"FlowerItemTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupLanguage];
    [self initPackages];
}

- (void)setupLanguage {
    [self.buyNowButton setTitle:[AppHelper getLocalizedString:@"FlowerShop.buttonBuyNow"] forState:UIControlStateNormal];
}

- (void)initNavigationBar {
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Flower Shop", nil)];
}

- (void)initPackages {
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    //request to get package info
    API_Payment_PackageFetch *packageAPI = [[API_Payment_PackageFetch alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                                          device_token:[userDefaultManager getDeviceToken]];
    [packageAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_payment_package_fetch * data = (out_payment_package_fetch *) jsonObject;
        if (response.status)
        {
            packageData = [data.payments mutableCopy];
            if(data.imageUrl.length) {
                [self.pictureFlowerShop setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:data.imageUrl]]]];
                /* WTF hardcode again >.< */
//                self.bannerHeightConstraint.constant = 1.0 * UIScreen.mainScreen.bounds.size.width / 290 * 93;
                [self.view layoutIfNeeded];
            }
            if(data.isActiveEvent) {
                //Get HTML string
                NSString *eventTitleHTML = data.titleEvent;
                //HTML string to attributed string
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[eventTitleHTML dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                //Separate 2 lines
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\n" options:0 error:nil];
                NSArray *results = [regex matchesInString:attributedString.string options:0 range:NSMakeRange(0, attributedString.length)];
                //Set font style according to design
                UIFont *eventTitleFont = [UIFont fontWithName:@"System Font Regular" size:18];
                UIFont *eventDescFont = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:14];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setAlignment:NSTextAlignmentCenter];
                [paragraphStyle setLineSpacing:10];
                NSRange range =((NSTextCheckingResult*)[results objectAtIndex:0]).range;
                [attributedString addAttribute:NSFontAttributeName value:eventTitleFont range:NSMakeRange(0, range.location)];
                [attributedString addAttribute:NSFontAttributeName value:eventDescFont range:NSMakeRange(range.location, attributedString.length - range.location)];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
                self.labelTitle.attributedText = attributedString;
            }
            
            [_packageTableView reloadData];
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];

}

- (void)setPackageData:(NSMutableArray* )data {
    packageData = data;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchBuyNow:(id)sender {
    if(!packSelected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[[NSString alloc] initWithString:NSLocalizedString(@"Please choose an item", )] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    NSString *transID = [userDefaultManager getTransactionID];
    
    transaction_check *param = [[transaction_check alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                  device_token:[userDefaultManager getDeviceToken]
                                                         transactionIdentifier:transID];
    if (param) {
        API_Transaction_Check *checkTransactionAPI = [[API_Transaction_Check alloc] initWithParam:param];
        [checkTransactionAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_transaction_check * data = (out_transaction_check *) jsonObject;
            if (response.status)
            {
                if (data.isDel) //No transaction in queue
                {
                    NSDate *today = [NSDate date];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
                    NSString *currentTime = [dateFormatter stringFromDate:today];
                    
                    payment_buy *param = [[payment_buy alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                     device_token:[userDefaultManager getDeviceToken]
                                                            transactionIdentifier:@""
                                                       transactionIdentifierStore:@""
                                                                            state:@"purchasing_start"
                                                                productIdentifier:productId
                                                                  transactionDate:currentTime
                                                                     receipt_data:@""
                                                                transactionFailBy:@""];
                    if (param) {
                        API_PaymentBuy *paymentAPI = [[API_PaymentBuy alloc] initWithParam:param];
                        [paymentAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                            out_payment_buy * data = (out_payment_buy *)jsonObject;
                            if (response.status)
                            {
                                if ([data.state isEqualToString:@"purchasing_start"]) {
                                    [userDefaultManager saveTransactionID:data.transactionIdentifier];
                                    _storeRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productId]];
                                    _storeRequest.delegate = self;
                                    [_storeRequest start];
                                    
                                    NSLog(@"->Request %@", productId);
                                    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
                                }
                            }
                            else
                            {
                                NSLog(@"%@", response.message);
                                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                                [AppHelper showMessageBox:nil message:response.message];
                            }
                        } ErrorHandlure:^(NSError *error) {
                            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                        }];
                    }
                }
                else
                {
                    payment_buy *param = [[payment_buy alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                     device_token:[userDefaultManager getDeviceToken]
                                                            transactionIdentifier:transID
                                                       transactionIdentifierStore:[userDefaultManager getTransactionStoreID]
                                                                            state:[userDefaultManager getState]
                                                                productIdentifier:[userDefaultManager getProductID]
                                                                  transactionDate:[userDefaultManager getTransactionDate]
                                                                     receipt_data:[userDefaultManager getReceipt]
                                                                transactionFailBy:@"Failed"];
                    if (param) {
                        API_PaymentBuy *paymentAPI = [[API_PaymentBuy alloc] initWithParam:param];
                        [paymentAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                            out_payment_buy * data = (out_payment_buy *) jsonObject;
                            if (response.status)
                            {
                                if ([data.state isEqualToString:@"purchasing_start"]) {
                                    [userDefaultManager saveTransactionID:data.transactionIdentifier];
                                } else {
                                    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                                    [userDefaultManager saveReceipt:@""];
                                    [userDefaultManager saveState:@""];
                                    [userDefaultManager saveTransactionID:@""];
                                    
                                    if ([data.state isEqualToString:@"purchased_success"]) {
                                        NSMutableArray * listTrans = [[BloomerManager shareInstance] listIAPTransaction];
                                        if (listTrans && listTrans.count > 0) {
                                            [listTrans enumerateObjectsUsingBlock:^(IAPTransaction* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                if ([transID isEqualToString:obj.transactionID]) {
                                                    [[SKPaymentQueue defaultQueue] finishTransaction:obj.skPaymentTransaction];
                                                    [listTrans removeObject:obj];
                                                    [[BloomerManager shareInstance] setListIAPTransaction:listTrans];
                                                }
                                            }];
                                        }
                                        out_profile_fetch *profileData = [userDefaultManager getUserProfileData];
                                        profileData.your_num_flower = data.num_flower;
                                        [userDefaultManager saveUserProfileData:profileData];
                                        [self updateFlowerValue];
                                    }
                                }
                            }
                            else
                            {
                                NSLog(@"%@", response.message);
                                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                                [AppHelper showMessageBox:nil message:response.message];
                            }
                        } ErrorHandlure:^(NSError *error) {
                            [_packageTableView setUserInteractionEnabled:TRUE];
                            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                        }];
                    }
                    
                }
            }
            else
            {
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            }
        } ErrorHandlure:^(NSError *error) {
            
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
    }
   
    
}

- (void)updateFlowerValue {
    NSNumber *nFlower = [NSNumber numberWithDouble:[userDefaultManager getUserProfileData].your_num_flower];
    NSString *sFlower = [nFlower formatWithLocale:[NSLocale currentLocale]];
    
    _lblflowerNumber.text = [NSString stringWithFormat: NSLocalizedString(@"%@ flowers",nil),sFlower] ;
    _lblflowerNumber.text = [NSString stringWithFormat:@"%@ %@", [AppHelper getLocalizedString:@"FlowerShop.labelFlowers"], _lblflowerNumber.text];

    if([[AppHelper getLocalizedString:@"EN"] isEqualToString:@"EN"])
    {
        NSMutableAttributedString *text =
        [[NSMutableAttributedString alloc]
         initWithAttributedString: _lblflowerNumber.attributedText];
        
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorFromHexString:@"ACACAC"]
                     range:NSMakeRange(8, 1)];
        [_lblflowerNumber setAttributedText: text];
    }
    else
    {
        NSMutableAttributedString *text =
        [[NSMutableAttributedString alloc]
         initWithAttributedString: _lblflowerNumber.attributedText];
        
        [text addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorFromHexString:@"ACACAC"]
                     range:NSMakeRange(11, 1)];
        [_lblflowerNumber setAttributedText: text];
    }
    
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return packageData==nil?0:packageData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FlowerItemTableViewCell *cell = (FlowerItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setIsEvent:[userDefaultManager getIsEventPayment]];
    
    payment_package *temp = [packageData objectAtIndex:indexPath.row];
    [cell initItemWithPaymentPackage:temp];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    packSelected = YES;
    productId = ((payment_package*)[packageData objectAtIndex:indexPath.row]).productIdentifier;
}

#pragma mark - STORE REQUEST
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"->request: didFailWithError %ld", (long)[error code]);
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSLog(@"->productsRequest: didReceiveResponse");
    SKProduct *validProduct = nil;
    
    if([response.products count] > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"->Products Available!");
        [self purchase:validProduct];
    }
    else {
        NSLog(@"->No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }
}

- (void)purchase:(SKProduct*)product {
    NSLog(@"->purchase");
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//This callback is called everytime transaction changes it state (Purchasing -> Purchased/Restored or Fail)
//-(void)paymentbuy_callback:(out_payment_buy*) data {
//
//}

@end
