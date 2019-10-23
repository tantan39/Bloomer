//
//  AccountSettingsCell.h
//  Bloomer
//
//  Created by Steven on 10/18/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSettingsCell : UITableViewCell

// MARK: - Static variables
+ (CGFloat)cellHeight;
+ (NSString*)cellIdentifier;
+ (NSString*)nibName;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelValue;

- (void)changeStyle:(BOOL)isPlaceholderStyle;

@end
