//
//  RaceListsTableViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/26/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaceListsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *leaveButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
- (IBAction)touchLeave:(id)sender;
- (IBAction)touchInfo:(id)sender;
- (IBAction)touchJoin:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *timeEnd;

@property (weak, nonatomic) NSString *key;
@property (weak, nonatomic) NSString *raceInfo;
@property (weak, nonatomic) NSString *joinInfo;
@property (weak, nonatomic) NSString *leaveInfo;
@property (assign, nonatomic) NSInteger locationID;
@property (assign, nonatomic) NSInteger categoryType;

@property (weak, nonatomic) UIViewController *parentView;

@end
