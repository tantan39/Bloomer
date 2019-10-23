//
//  ListOfFlowerGiver.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/17/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Notification_ListUser.h"
//#import "notification_listuser.h"
#import "UserDefaultManager.h"
#import "out_notification_listUser.h"
#import "GiverFlowerCell.h"
#import "UserProfileViewController.h"
#import "notification_user.h"

@interface ListOfFlowerGiver : UIViewController< UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *TableView;

@property (weak, nonatomic) UINavigationController *myNavigationController;

-(void) loadAllUser:(NSString*) noti_key;

@end
