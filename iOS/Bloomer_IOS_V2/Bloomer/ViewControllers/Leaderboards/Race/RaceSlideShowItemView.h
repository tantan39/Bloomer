//
//  RaceSlideShowItemView.h
//  Bloomer
//
//  Created by Steven on 4/7/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaceSlideShowItemView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIView *viewAllView;
@property (weak, nonatomic) IBOutlet UILabel *viewAllLabel;
@property (strong, nonatomic) void (^touchItemView)(void);

- (IBAction)touchItemView:(id)sender;

@end
