//
//  RaceListCell.h
//  Bloomer
//
//  Created by Steven on 12/17/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "races_list.h"

typedef enum {
    Joined,
    Switch,
    NotJoined,
    Closed
} RaceListState;

@interface RaceListCell : UICollectionViewCell

// MARK: - Static variables
+ (CGFloat) cellHeight;
+ (NSString*) cellIdentifier;
+ (NSString*) nibName;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIImageView *iconJoinedRace;
@property (weak, nonatomic) IBOutlet UIButton *buttonJoin;
@property (weak, nonatomic) IBOutlet UIButton *buttonSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionViewWidth;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewRightMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTimeHeight;
@property (weak, nonatomic) IBOutlet UIButton *buttonGift;
@property (strong, nonatomic) IBOutlet UIView *mainView;

- (IBAction)touchButtonJoin:(id)sender;
- (IBAction)TouchButtonGift:(id)sender;

@property (assign, nonatomic) NSInteger gender;
@property (weak, nonatomic) races_list *raceData;

- (void)switchActionView:(RaceListState)state;

@end
