//
//  SuggestedPersonView.h
//  Bloomer
//
//  Created by Steven on 12/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"

@interface SuggestedPersonView : UIView

+ (CGSize)viewSize;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;

@end
