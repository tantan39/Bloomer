//
//  AnonymousTabBarController.h
//  Bloomer
//
//  Created by Steven on 5/4/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarView.h"

@interface AnonymousTabBarController : UITabBarController<UITabBarControllerDelegate>

@property (strong, nonatomic) TabBarView *tabbar;

@end
