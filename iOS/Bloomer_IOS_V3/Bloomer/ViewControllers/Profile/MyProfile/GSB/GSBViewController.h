//
//  PopupForGBS.h
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 8/7/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIDefine.h"
#import "BlueRoundButton.h"

@interface GSBViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) NSString *gsbType;

@end
