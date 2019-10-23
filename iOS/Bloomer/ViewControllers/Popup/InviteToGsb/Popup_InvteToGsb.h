//
//  PopupForWinner.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/12/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "UserDefaultManager.h"
#import "UIImageView+AFNetworking.h"

@interface Popup_InvteToGsb : UIViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *CongratsLabel;

@property (weak, nonatomic) IBOutlet UIView *PopUp;
@property (weak, nonatomic) IBOutlet UIImageView *WinnerImage;
@property (weak, nonatomic) IBOutlet UILabel *NameWinner;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
-(void) loadPopupWithImageLink:(NSString*)url message:(NSString*)msg;
@end
