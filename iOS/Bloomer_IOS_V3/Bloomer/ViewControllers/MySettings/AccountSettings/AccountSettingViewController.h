//
//  AccountSettingViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/26/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "out_profile_fetch.h"
#import "ChangesGenderViewController.h"
#import "out_profile_setting.h"
#import "EdittingAccountViewController.h"
#import "UserDefaultManager.h"
#import "SetPasswordViewController.h"

@interface AccountSettingsObject: NSObject

@property(strong, nonatomic) NSString* title;
@property(strong, nonatomic) NSString* placeHolder;
@property(strong, nonatomic) NSString* value;

- (id)initWithTitle:(NSString*)title placeHolder:(NSString*)placeHolder value:(NSString*)value;

@end

///////////////////////////////////////////////////

@interface AccountSettingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, EdittingAccountViewControllerDelegate>

+ (NSArray<AccountSettingsObject*>*)cellPrototypes;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) out_profile_setting* profileSettings;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *mobile;

- (void)setEmail;
- (void)setMobile;

@end
