//
//  FriendsUpdatesRaceTableViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/16/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON_ClosedRaceFeed.h"
#import "AppDelegate.h"
#import "UILabel+Extension.h"
#import "UserDefaultManager.h"

@interface FriendsUpdatesRaceTableViewCell : UITableViewCell

// MARK: - Static variables
+ (CGFloat) cellHeight;
+ (NSString*) cellIdentifier;
+ (NSString*) nibName;

// MARK: - Variables

@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIImageView *firstRankAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *secondAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *thirdAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *fourthAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *fifthAvatar;
@property (weak, nonatomic) IBOutlet UILabel *firstRankCircle;
@property (weak, nonatomic) IBOutlet UILabel *secondRankCircle;
@property (weak, nonatomic) IBOutlet UILabel *thirdRankCircle;
@property (weak, nonatomic) IBOutlet UILabel *fourthRankCircle;
@property (weak, nonatomic) IBOutlet UILabel *fifthRankCircle;
@property (weak, nonatomic) IBOutlet UILabel *lblRaceName;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *rankViews;
@property (weak, nonatomic) IBOutlet UIView *animatedLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animatedLineLeftMargin;
@property (weak, nonatomic) IBOutlet UILabel *labelWinnerTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonViewMoreResults;

- (IBAction)touchButtonAvatar:(id)sender;

@property (weak, nonatomic) UINavigationController *navigationController;

-(void)reloadRaceFeedByList:(NSMutableArray*)winnerList;

-(GENDER)getCurrentRaceGender;

@property (strong, nonatomic) JSON_ClosedRaceFeed *maleRace;
@property (strong, nonatomic) JSON_ClosedRaceFeed *femaleRace;
@property (strong,nonatomic) NSString *feed_id;

@end
