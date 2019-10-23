//
//  SelectCityViewController.h
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 3/9/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Add_Location.h"
#import "UserDefaultManager.h"
#import "AppHelper.h"
#import "TTMessageView.h"

@interface SelectCityViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *tittleSelectCity;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel1;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel2;

@property (strong, nonatomic) void (^complete)();

//@property (assign, nonatomic) bool isInsideProfile;

@end
