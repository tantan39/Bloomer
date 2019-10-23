//
//  ChooseLocationViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/3/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ChooseLocationViewController.h"
#import "UISearchBar+Extension.h"
#import "Spinner.h"
#import "DiscoveryViewController.h"
#import "AppDelegate.h"

@interface ChooseLocationViewController () {
    NSMutableArray *cityList;
    NSMutableArray * searchResults;
    UserDefaultManager * userDefaultManager;
    Spinner * spinner;
}

@end

@implementation ChooseLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationID = 0;
    spinner = [(AppDelegate *)[[UIApplication sharedApplication] delegate] spinner];
    userDefaultManager = [[UserDefaultManager alloc] init];
    [self.tfRegion setUnderlineColor:[UIColor colorFromHexString:@"#545454"]];
    self.btnNext.layer.cornerRadius = self.btnNext.frame.size.height/2;
    [self.btnNext setStatusEnable:NO];
    if ([_parentView isKindOfClass:[DiscoveryViewController class]])
    {
        DiscoveryViewController *parent = (DiscoveryViewController *)_parentView;
        cityList = parent.cityList;
    }
    
    if (cityList == nil)
    {
        cityList = [[NSMutableArray alloc] init];
        API_LoadLocation *API = [[API_LoadLocation alloc] init];
        [spinner startAnimating];
        [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_location_load * data = (out_location_load *) jsonObject;
            [spinner stopAnimating];
            if (response.status) {
                [self bindingToTextfield:data];
            } else {
                [AppHelper showMessageBox:NSLocalizedString(@"Alert.Title.ErrorMessage", nil) message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [spinner stopAnimating];
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:TRUE];
}

- (void) bindingToTextfield:(out_location_load *) data{
    for (city * city in data.citys) {
        [cityList addObject:city.city_name];
    }
    [self.tfRegion setDatasource:cityList inView:self.view];
}

//#pragma mark - Init SearchController
//- (void) InitSearchBar
//{
//    self.tbvSearchResult = [[SearchLocationVC alloc] initWithViewController:self];
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.tbvSearchResult];
//    self.searchController.searchResultsUpdater = self;
//    [self.searchController.searchBar sizeToFit];
//    CGRect searchBarFrame = CGRectMake(0, 0, self.searchController.searchBar.bounds.size.width, self.searchController.searchBar.bounds.size.height);
//    [self.searchController.searchBar setFrame:searchBarFrame];
//    [self.view addSubview:self.searchController.searchBar];
//    [self.searchController.searchBar setHidden:YES];
//    self.searchController.delegate = self;
//    self.searchController.dimsBackgroundDuringPresentation = YES;
//    self.searchController.searchBar.delegate = self;
//
//    [self.searchController.searchBar customizeSearchbar];
//    [self.searchController.searchBar setupSearchBar];
//}

- (void)textFieldSelectedIndex:(NSInteger)index textfield:(TTTextField *)sender{
    index++;
    self.locationID = index;
    [self.btnNext setStatusEnable:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.tfRegion resignFirstResponder];
    return NO;
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    if (SYSTEM_VERSION_LESS_THAN(@"10.0")) {
        return UIBarPositionTopAttached;
    }
    return UIBarPositionTop;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Datasource/Delegateß
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if ([_searchController isActive] && ![_searchController.searchBar.text isEqualToString:@""]) {
//        return searchResults.count;
//    }
//    return cityList.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 40;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    static NSString *identifier = @"ChooseLocation";
//    static NSString * cellResultID = @"SearchLocationResultCell";
//
//    if ([_searchController isActive] && ![_searchController.searchBar.text isEqualToString:@""]) {
//
//        SearchLocationResultCell * cell = [tableView dequeueReusableCellWithIdentifier:cellResultID forIndexPath:indexPath];
//        city * temp = [searchResults objectAtIndex:indexPath.row];
//        cell.lblLocationName.text = temp.city_name;
//        return cell;
//
//    }else{
//
//        ChooseLocationTableViewCell *cell = (ChooseLocationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//
//        if (cell == nil) {
//            [tableView registerNib:[UINib nibWithNibName:@"ChooseLocationTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
//            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        }
//
//        city *temp = [cityList objectAtIndex:indexPath.row];
//
//        if (temp) {
//            cell.locationName.text = temp.city_name;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        return cell;
//
//    }
//
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([_searchController isActive] && ![_searchController.searchBar.text isEqualToString:@""]) {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        [_searchController setActive:NO];
//        city * itemSelected = [searchResults objectAtIndex:indexPath.row];
//        [self selectedCellWithCity:itemSelected];
//        self.locationID = itemSelected.city_id;
//
//    }else{
//        city *city = [cityList objectAtIndex:indexPath.row];
//        [self selectedCellWithCity:city];
//        self.locationID = city.city_id;
//    }
//
//}
//
//
//- (void) selectedCellWithCity:(city *) selectedCity{
//
//    for (int i = 0; i < cityList.count; i++) {
//        NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
//        city *temp = [cityList objectAtIndex:index.row];
//        ChooseLocationTableViewCell * cell = [self.tableView cellForRowAtIndexPath:index];
//        if (temp.city_id == selectedCity.city_id) {
//
//            [cell updateStatusSelected];
//        }else{
//            [cell updateStatusDeSelected];
//        }
//
//    }
//}

#pragma mark - Event
- (IBAction)touchBack:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

//- (IBAction)btnSearch_Pressed:(id)sender {
//    [self activeSearchBar];
//}

- (IBAction)btnNext_Pressed:(id)sender {
    Auth_FBRegisterParams * auth_FBResgister = [[BloomerManager shareInstance] auth_FBRegister];
    NSString *secretClient = [userDefaultManager generateSecretClient];
    NSString *userPass = [userDefaultManager getUserPass];
    NSString *encryptedSecretClient = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:secretClient iv:[userDefaultManager getAppSecret]];
    NSString *encryptedCridential = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:userPass iv:secretClient];
    
    [auth_FBResgister setSecret_client:encryptedSecretClient];
    [auth_FBResgister setCredential:encryptedCridential];
    [auth_FBResgister setDevice_id:[userDefaultManager getDeviceToken]];
    [auth_FBResgister setAccess_token:[userDefaultManager getAccessToken]];
//    [auth_FBResgister setLocation_id:self.locationID];
//    [auth_FBResgister setFb_birthday:@""];
    [spinner startAnimating];
    API_Auth_FBRegister * api = [[API_Auth_FBRegister alloc] initWithParams:auth_FBResgister];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_auth_authorize * object = (out_auth_authorize *) jsonObject;
        if (response.status)
        {
            [userDefaultManager getUserProfileData].gender = object.gender;
            [userDefaultManager saveAccessToken:object.access_token];
            [userDefaultManager saveRefresh_Token:object.refresh_token];
            [userDefaultManager saveCredentialEjab:[userDefaultManager decryptDESByKey:[userDefaultManager getAppKey] data:object.cridential_ejab iv:[userDefaultManager getAppSecret]]];
            [userDefaultManager setDidPostDailyLocalNotification:false];
            [LocalNotificationHelper removeAllLocalNotifications];
            
            [self requestGetProfileMeWith:object.access_token DeviceToken:[userDefaultManager getDeviceToken]];
            
            
        }else{
            [spinner stopAnimating];
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];
    
}

- (void) requestGetProfileMeWith:(NSString *) accessToken DeviceToken:(NSString *) deviceToken{
    if (accessToken && deviceToken) {
        API_Profile_Me * api = [[API_Profile_Me alloc] initWithAccessToken:accessToken
                                                              device_token:deviceToken];
        [api getRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
            out_profile_fetch * data = (out_profile_fetch *) json;
            [spinner stopAnimating];
            if (objStatus.status)
            {
                [userDefaultManager saveUserProfileData:data];
                [userDefaultManager removeM_ID];
//                profileData = data;
                TabBarViewController *view = [[TabBarViewController alloc] initWithNibName:@"TabBarViewController" bundle:nil];
                [self.navigationController pushViewController:view animated:TRUE];
            }else{
                [AppHelper showMessageBox:[AppHelper getLocalizedString:@"Alert.Title.ErrorMessage"] message:objStatus.message];
            }
        } ErrorHandlure:^(NSError * error) {
            [spinner stopAnimating];
        }];
    }
    
}

#pragma mark - Handle Show/Hide Keyboard
- (void)keyboardWillShow:(NSNotification *) notif
{
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat yFrame = self.view.bounds.size.height - (_btnNext.frame.origin.y + _btnNext.bounds.size.height + 5);
    CGFloat offSet = yFrame - kbSize.height;
    
    if (offSet < 0) {
        [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.frame = CGRectMake(0, offSet, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *) notif
{
    NSDictionary *userInfo = [notif userInfo];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = frame;
    }];
}


//- (void) activeSearchBar{
//    [self.searchController.searchBar setHidden:NO];
//    [self.searchController.searchBar becomeFirstResponder];
//}
//
//- (void) deActiveSearchBar{
//    [self.searchController.searchBar setHidden:YES];
//}

//#pragma mark - Search function
//- (void)filterContentForSearchText:(NSString*)searchText
//{
//    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"city_name BEGINSWITH[cd] %@", searchText];
//    NSArray * citys = [[NSArray alloc] initWithArray:cityList];
//    NSArray * results = [citys filteredArrayUsingPredicate:resultPredicate];
//    searchResults = [[NSMutableArray alloc] initWithArray:results];
//    [_tbvSearchResult reloadDataWithDataSource:searchResults];
//}
//
//#pragma mark - Search Display Controller
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
//
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    [self filterContentForSearchText:searchText];
//}
//
//- (void)didPresentSearchController:(UISearchController *)searchController{
//    if (SYSTEM_VERSION_LESS_THAN(@"10.0")){
//        [searchController.searchBar setFrame:CGRectMake(0, 20, searchController.searchBar.bounds.size.width, searchController.searchBar.bounds.size.height)];
//    }
//
//}
//
//- (void)didDismissSearchController:(UISearchController *)searchController{
//    if (SYSTEM_VERSION_LESS_THAN(@"10.0")){
//        [searchController.searchBar setFrame:CGRectMake(0, 0, searchController.searchBar.bounds.size.width, searchController.searchBar.bounds.size.height)];
//    }
//    [self deActiveSearchBar];
//}

@end
