//
//  UpdatePopupViewController.h
//  Bloomer
//
//  Created by Le Chau Tu on 3/25/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePopupViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *popupFrame;
@property (strong, nonatomic) IBOutlet UIButton *buttonUpdate;
- (IBAction)buttonUpdate:(id)sender;

@end
