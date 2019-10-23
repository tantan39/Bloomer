//
//  ChooseLocationViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/3/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseLocationTableViewCell.h"
#import "API_LoadLocation.h"
#import "city.h"
#import "ChangeLocationViewController.h"
#import "API_Auth_FBRegister.h"
#import "TTTextField.h"

@interface ChooseLocationViewController : UIViewController <TTTextfieldDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet TTTextField *tfRegion;


@property (assign, nonatomic) BOOL isSetting;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightNavigationView;

@property (nonatomic, strong) UISearchController * searchController;
//@property (nonatomic, strong) SearchLocationVC * tbvSearchResult;

//@property auth_register * authRegister;

@property NSInteger locationID;

- (IBAction)touchBack:(id)sender;

@end
