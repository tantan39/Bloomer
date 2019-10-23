//
//  SelectionReasonReportViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/9/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "SelectionReasonReportViewController.h"

@interface SelectionReasonReportViewController () {
    NSMutableArray *reasonList;
    UserDefaultManager *userDefaultManager;
    reason* selectedReason;
}

@end

@implementation SelectionReasonReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    reasonList = [[NSMutableArray alloc] init];
    userDefaultManager = [[UserDefaultManager alloc] init];
    _reason_other = @"";
    selectedReason = nil;
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
    self.tableView.layer.cornerRadius = 20;
    self.tableView.delegate = self;
    
    self.confirmLabel.layer.cornerRadius = 20;
    self.confirmLabel.clipsToBounds = YES;
    self.reportButton.layer.cornerRadius = 20;
    self.cancelButton.layer.cornerRadius = 20;
    self.tableView.estimatedRowHeight = 50;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(closePopup)];
    
    [self.backgroundView addGestureRecognizer:tap];
    [self loadReason];
}

-(void) viewDidAppear:(BOOL)animated{
    [_confirmationView setHidden:YES];
    if (_isUser) {
        [self.confirmLabel setText:NSLocalizedString(@"ReportUserLabel.title", )];
    } else {
        [self.confirmLabel setText:NSLocalizedString(@"ReportPictureLabel.title", )];
    }
}

- (void)loadReason {
    NSInteger reasonType;
    if (self.isUser) {
        reasonType = 1;
    } else {
        reasonType = 2;
    }
    
    API_ReasonFetch *api = [[API_ReasonFetch alloc] initWithType:reasonType];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status) {
            JSON_ReasonFetch *data = (JSON_ReasonFetch *)jsonObject;
            reasonList = data.reasonList;
            
            [_tableView reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:response.message
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    } ErrorHandlure:^(NSError *error) {
    }];
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        if (animated) {
            [self showAnimate];
        }
    });
}

- (void)closePopup {
    [self removeAnimate];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return reasonList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"Reason";
    SelectReportTableViewCell *cell = (SelectReportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"SelectReportTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    reason *temp = (reason *)[reasonList objectAtIndex:indexPath.row];
    cell.reason.text = temp.content;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedReason = (reason *)[reasonList objectAtIndex:indexPath.row];
    
    [_reasonView setHidden:YES];
    [_confirmationView setHidden:NO];
}

- (IBAction)touchReport:(id)sender {
    if (!_isUser) {
        report *param = [[report alloc] initWithAccess_Token:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] postID:_post_id reason_id:selectedReason.ids reasonOther:_reason_other];
        if (param) {
            API_Report *api = [[API_Report alloc] initWithParams:param];
            [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                if (response.status) {
                    [self removeAnimate];
                    [AppHelper showMessageBox:nil message:NSLocalizedString(@"ReportPictureMessage.success", )];
                } else {
                    [AppHelper showMessageBox:nil message:response.message];
                }
            } ErrorHandlure:^(NSError *error) {
                
            }];
        }
        
        
    } else {
        reports *param = [[reports alloc] initWithAccess_Token:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:_uid reason_id:selectedReason.ids reasonOther:_reason_other];
        if (param) {
            API_ReportUser *api = [[API_ReportUser alloc] initWithParams:param];
            [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                if (response.status) {
                    [self removeAnimate];
                    [AppHelper showMessageBox:nil message:NSLocalizedString(@"ReportUserMessage.success", )];
                } else {
                    [AppHelper showMessageBox:nil message:response.message];
                }
            } ErrorHandlure:^(NSError *error) {
                
            }];
        }
        

    }
}


- (IBAction)touchCancel:(id)sender {
    [self closePopup];
}

@end
