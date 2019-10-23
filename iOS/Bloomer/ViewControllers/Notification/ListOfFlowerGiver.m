//
//  ListOfFlowerGiver.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/17/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ListOfFlowerGiver.h"

@interface ListOfFlowerGiver ()
{
    UserDefaultManager* userDefaultManager;
    NSMutableArray* listData;
}

@end

@implementation ListOfFlowerGiver

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self initNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadAllUser:(NSString*) noti_key
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    userDefaultManager = [[UserDefaultManager alloc] init];
    notification_listuser* input = [[notification_listuser alloc] initWithAccessToken:[userDefaultManager getAccessToken] deviceId:[userDefaultManager getDeviceToken] andNoti_key:noti_key index:0];
    if (input) {
        API_Notification_ListUser* api = [[API_Notification_ListUser alloc] initWithParam:input];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_notification_listUser * data = (out_notification_listUser *) jsonObject;
            if(response.status)
            {
                listData = (NSMutableArray*) [data listUser];
                [self.TableView reloadData];
            }
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
    }
    

}

- (void) initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Notifications", nil)];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"GiverFlowerNoti";
    GiverFlowerCell *cell = (GiverFlowerCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"GiverFlowerCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    notification_user* temp = (notification_user*)[listData objectAtIndex:indexPath.row];
    
    [cell setDataForCell:[temp avatar] userName:[temp name] nameId:[temp userName] floweGiver:[temp gaveNumber]];
    
    cell.navigationController = self.navigationController;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    notification_user* temp = (notification_user*)[listData objectAtIndex:indexPath.row];
    UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    view.uid = [temp userID];
    view.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:view animated:YES];
    
//    UserProfileViewController *view;
//    view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
//    
//    view.uid = [temp userID];
//    view.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:view animated:YES];
}

@end
