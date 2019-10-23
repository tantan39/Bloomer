//
//  FlowerGiverViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/27/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "FlowerGiverViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "FlowerGiverCell.h"
#import "AppHelper.h"
#import "UILabel+Extension.h"
#import "UserProfileViewController.h"
#import "NSDate+TimeAgo.h"

@interface FlowerGiverViewController () {
    UserDefaultManager *userDefaultManager;
    out_profile_fetch *profileData;
    NSMutableArray *giverList;
    NSInteger index;
}

@end

@implementation FlowerGiverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView registerNib:[UINib nibWithNibName:[FlowerGiverCell nibName]bundle:nil] forCellReuseIdentifier:[FlowerGiverCell cellIdentifier]];
    
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"FlowerGiverViewControllerTopBar.Title", nil)];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    giverList = [[NSMutableArray alloc] init];
    index = 0;
    
    if ([self.notificationKey isEqualToString:@""])
    {
        [self loadGiverWithLastId];
    }
    else
    {
        [self loadAllUser:self.notificationKey];
    }
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self refreshGiverList];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self loadmore];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadGiverWithLastId {
    if (self.post_id) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
        API_Post_FollowerFetches *api = [[API_Post_FollowerFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] postID:_post_id index:index];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_follower_fetches * data = (out_follower_fetches *) jsonObject;
            if (response.status)
            {
                index = data.index;
                if(data.followerList.count > 0)
                {
                    //            if(data.followerList.count < 10)
                    //            {
                    //                _tableView.showsInfiniteScrolling = NO;
                    //            }
                    
                    [giverList addObjectsFromArray:data.followerList];
                    [_tableView reloadData];
                } else {
                    _tableView.showsInfiniteScrolling = NO;
                }
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
    }

}

- (void)loadAllUser:(NSString*)notificationKey
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    notification_listuser* input = [[notification_listuser alloc] initWithAccessToken:[userDefaultManager getAccessToken]  deviceId:[userDefaultManager getDeviceToken] andNoti_key:notificationKey index:index];
    if (input) {
        API_Notification_ListUser* api = [[API_Notification_ListUser alloc] initWithParam:input];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_notification_listUser * data = (out_notification_listUser *) jsonObject;
            if(response.status)
            {
                if (data.listUser.count > 0)
                {
                    //            if(data.listUser.count < 10)
                    //            {
                    //                _tableView.showsInfiniteScrolling = NO;
                    //            }
                    
                    [giverList addObjectsFromArray:data.listUser];
                    [_tableView reloadData];
                    index = data.index;
                } else {
                    _tableView.showsInfiniteScrolling = NO;
                }
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
    }
    

}

-(void)loadmore
{
    if ([self.notificationKey isEqualToString:@""])
    {
        [self loadGiverWithLastId];
    }
    else
    {
        [self loadAllUser:self.notificationKey];
    }
    [_tableView.infiniteScrollingView stopAnimating];
}

- (void) refreshGiverList{
    index = 0;
    if ([self.notificationKey isEqualToString:@""])
    {
        [self refreshGiverListWithPostID:self.post_id];
    }else{
        [self refreshGiverListWithNotificationKey:self.notificationKey];
    }
}

- (void) refreshGiverListWithPostID:(NSString *) postID{

    if (postID) {
        API_Post_FollowerFetches *api = [[API_Post_FollowerFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] postID:postID index:index];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [self.tableView.pullToRefreshView stopAnimating];
            out_follower_fetches * data = (out_follower_fetches *) jsonObject;
            if (response.status)
            {
                index = data.index;
                if(data.followerList.count > 0)
                {
                    giverList = data.followerList;
                    [_tableView reloadData];
                }
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
    
}

- (void) refreshGiverListWithNotificationKey:(NSString *) notifKey{
    notification_listuser* input = [[notification_listuser alloc] initWithAccessToken:[userDefaultManager getAccessToken]  deviceId:[userDefaultManager getDeviceToken] andNoti_key:notifKey index:index];
    if (input) {
        API_Notification_ListUser* api = [[API_Notification_ListUser alloc] initWithParam:input];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [self.tableView.pullToRefreshView stopAnimating];
            out_notification_listUser * data = (out_notification_listUser *) jsonObject;
            if(response.status)
            {
                if (data.listUser.count > 0)
                {
                    giverList = data.listUser;
                    [_tableView reloadData];
                    index = data.index;
                }
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return giverList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlowerGiverCell *cell = (FlowerGiverCell *)[tableView dequeueReusableCellWithIdentifier:[FlowerGiverCell cellIdentifier] forIndexPath:indexPath];
    
    follower *temp = (follower *)[giverList objectAtIndex:indexPath.row];
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:temp.avatar]];
    cell.labelName.text = temp.name;
    cell.labelUsername.text = temp.username;
    cell.labelBloomerMatched.hidden = !temp.matchingFlower;

    if(temp.timestamp == 0)
    {
        cell.labelTime.text = NSLocalizedString(@"PhotoFlowerGiver.longtimeago", );
    }
    else
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:temp.timestamp];
        cell.labelTime.text = [date timeAgo];
    }
    
    [cell.labelFlower setFlowers:temp.flower imageString:@"Icon_Flower_Black"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FlowerGiverCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    follower *temp = (follower *)[giverList objectAtIndex:indexPath.row];

    UserProfileViewController *viewController = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    viewController.uid = temp.uid;
    
    self.navigationController.viewControllers = @[self.navigationController.viewControllers.firstObject, viewController];
}

@end
