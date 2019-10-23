//
//  SelectionReasonReportViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/9/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "SelectReportTableViewCell.h"
#import "API_ReasonFetch.h"
#import "API_Report.h"
#import "UserDefaultManager.h"
#import "API_ReportUser.h"

@interface SelectionReasonReportViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) NSString *post_id;
@property (assign, nonatomic) NSInteger reason_id;
@property (weak, nonatomic) NSString *reason_other;
@property (assign, nonatomic) BOOL isUser;
@property (assign, nonatomic) NSInteger uid;
@property (weak, nonatomic) IBOutlet UIView *confirmationView;
@property (weak, nonatomic) IBOutlet UILabel *confirmLabel;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *reasonView;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;

@end
