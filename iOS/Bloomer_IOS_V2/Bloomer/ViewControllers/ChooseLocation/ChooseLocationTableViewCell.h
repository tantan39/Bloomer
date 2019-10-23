//
//  ChooseLocationTableViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/3/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
@interface ChooseLocationTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) IBOutlet UIImageView *imgvSelected;

- (void) updateStatusSelected;
- (void) updateStatusDeSelected;

@end
