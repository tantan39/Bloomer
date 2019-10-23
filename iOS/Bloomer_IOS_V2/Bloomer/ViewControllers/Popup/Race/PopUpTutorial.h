//
//  PopUpTutorial.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/18/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import "UserDefaultManager.h"


@interface PopUpTutorial : UIViewController

@property (weak, nonatomic) IBOutlet UIView *PopupContent;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *GifTut;
@property (weak, nonatomic) IBOutlet UIButton *DontRemindButton;
@property (weak, nonatomic) IBOutlet UIButton *OkButton;
- (IBAction)TouchOk:(id)sender;
- (IBAction)TouchDontRemind:(id)sender;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;

@end
