//
//  SearchNewFeedTableViewCell.h
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 12/24/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchNewFeedTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *displayNamelbl;
@property (strong, nonatomic) IBOutlet UILabel *usernamelbl;

+ (NSString*) cellIdentifier;
+ (NSString*) nibName;
+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
