//
//  BaseVC.h
//  Bloomer
//
//  Created by Tan Tan on 11/21/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "AppDelegate.h"
#import "Spinner.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseVC : UIViewController
@property (strong,nonatomic) UserDefaultManager * userDefaultManager;
@property (strong,nonatomic) Spinner * spinner;
@end

NS_ASSUME_NONNULL_END
