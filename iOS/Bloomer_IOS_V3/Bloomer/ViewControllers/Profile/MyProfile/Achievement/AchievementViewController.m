//
//  AchievementViewController.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 3/22/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "AchievementViewController.h"

@interface AchievementViewController ()
{
    UserDefaultManager* userDefaultManager;
    NSString* keyEnd;
    BOOL isLoadingMore;
    NSMutableDictionary* rankDictionary;
    NSMutableDictionary* showItemDictionary;

}

@end

@implementation AchievementViewController

@synthesize activeRaces = activeRaces;

// MARK: - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"AchievementName.title", );
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    rankDictionary = [[NSMutableDictionary alloc] init];
    showItemDictionary = [[NSMutableDictionary alloc] init];
    
    [self setupEmptyDataView];
    self.tableView.allowsSelection = TRUE;
    __weak AchievementViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf infiniteScrolling];
    }];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
    self.tableView.tableHeaderView = header;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"Achievements Data count: %ld", self.achievementsData.count);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)infiniteScrolling {
    [self.tableView.infiniteScrollingView stopAnimating];
    isLoadingMore = true;
    if (keyEnd != nil && ![keyEnd isEqual: @""]) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
        if (activeRaces) {
            [self loadActiveAchievements];
        } else {
            [self loadClosedAchievements];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - Load Achievements API

- (void)loadAchievements {
    userDefaultManager = [[UserDefaultManager alloc] init];
    if (activeRaces) {
        [self loadActiveAchievements];
    } else {
        [self loadClosedAchievements];
    }
}

- (void)loadActiveAchievements {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_GetActiveAchievement* getActiveAchievementsAPI = [[API_GetActiveAchievement alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                                                  device_token:[userDefaultManager getDeviceToken]
                                                                                                       user_id:_uid];
    if (isLoadingMore) {
        getActiveAchievementsAPI = [[API_GetActiveAchievement alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                            device_token:[userDefaultManager getDeviceToken]
                                                                                 user_id:_uid
                                                                                  andKey:keyEnd];
    }
    
    __weak typeof(self) weakSelf = self;
    [getActiveAchievementsAPI getRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
        if (weakSelf) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (objStatus.status && activeRaces) {
                JSON_Achievement *achievementsJSON = (JSON_Achievement *)json;
                keyEnd = achievementsJSON.keyEnd;
                if (isLoadingMore) {
                    NSMutableArray *extraData = [strongSelf extractAchievementsData:achievementsJSON.achievements
                                                                           cellType:(int)@(ActiveRaceWithFlowerCell)];
                    [strongSelf.achievementsData addObjectsFromArray:extraData];
                } else {
                    strongSelf.achievementsData = [strongSelf extractAchievementsData:achievementsJSON.achievements
                                                                            cellType:(int)@(ActiveRaceWithFlowerCell)];
                }
                
                for (int i = 0; i < rankDictionary.allKeys.count; i++) {
//                    [showItemDictionary setObject:@(i) forKey: @(i)];
                }
                
                [strongSelf.tableView reloadData];
                
                if (rankDictionary.allKeys.count == 0) {
                    self.tableView.hidden = true;
                } else {
                    self.tableView.hidden = false;
                }
                
            } else {
                [AppHelper showMessageBox:nil message:objStatus.message];
            }
            isLoadingMore = false;
        }
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
    } ErrorHandlure:^(NSError * error) {
        [AppHelper showMessageBox:nil message:error.description];
        isLoadingMore = false;
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)loadClosedAchievements {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_GetCloseAchievement* getClosedAchievementsAPI = [[API_GetCloseAchievement alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                                                device_token:[userDefaultManager getDeviceToken]
                                                                                                     user_id:_uid];
    if (isLoadingMore) {
        getClosedAchievementsAPI = [[API_GetCloseAchievement alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                           device_token:[userDefaultManager getDeviceToken]
                                                                                user_id:_uid
                                                                                 andKey:keyEnd];
    }
    
    __weak typeof(self) weakSelf = self;
    [getClosedAchievementsAPI getRequest:^(BaseJSON *json, RestfulResponse *objStatus) {
        if (weakSelf) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (objStatus.status && !activeRaces) {
                JSON_Achievement *achievementsJSON = (JSON_Achievement *)json;
                keyEnd = achievementsJSON.keyEnd;
                if (isLoadingMore) {
                    NSMutableArray *extraData = [strongSelf extractAchievementsData:achievementsJSON.achievements
                                                                           cellType:(int)@(ActiveRaceCell)];
                    [strongSelf.achievementsData addObjectsFromArray:extraData];
                } else {
                    strongSelf.achievementsData = [strongSelf extractAchievementsData:achievementsJSON.achievements
                                                                             cellType:(int)@(ActiveRaceCell)];
                }
                
                for (int i = 0; i < rankDictionary.allKeys.count; i++) {
//                    [showItemDictionary setObject:@(i) forKey: @(i)];
                }
                
                [strongSelf.tableView reloadData];
                
                if (rankDictionary.allKeys.count == 0) {
                    self.tableView.hidden = true;
                } else {
                    self.tableView.hidden = false;
                }
                
            } else {
                [AppHelper showMessageBox:nil message:objStatus.message];
            }
            isLoadingMore = false;
        }
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
    } ErrorHandlure:^(NSError * error) {
        [AppHelper showMessageBox:nil message:error.description];
        isLoadingMore = false;
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (NSMutableArray*)extractAchievementsData:(NSMutableArray*)data cellType:(int)cellType {
    for (NSUInteger i = 0; i < data.count; i++) {
        AchievementModel* achievementInfo = (AchievementModel *)data[i];
        NSMutableArray *result = [[NSMutableArray alloc] init];
        if (achievementInfo.childs != nil) {
            [self extractAchievementWithTimelines:achievementInfo result:result section:i cellType:cellType];
        } else {
            [self extractAchievementsWithBestRank:achievementInfo result:result section:i cellType:cellType];
        }
    }
    return [[NSMutableArray alloc] init];
}

- (void)extractAchievementWithTimelines:(AchievementModel *)achievementInfo
                                 result:(NSMutableArray *)result section: (NSInteger) section
                               cellType:(int)cellType {
    achievementObject* tempAchivement = [[achievementObject alloc] initWithName:achievementInfo.raceName
                                                                        content:@(achievementInfo.num_flower).stringValue
                                                                         andKey:(int)@(ActiveRaceWithFlowerCell)];
    if (cellType == (int)@(ActiveRaceCell)) {
        [tempAchivement setNumber:(int)@(ActiveRaceCell)];
    }
    [result addObject:tempAchivement];
    
    achievementObject* tempChildYesterday;
    achievementObject* tempChildWeek;
    achievementObject* tempChildMonth;
    achievementObject* tempChildYear;
    
    for (NSUInteger j = 0; j < achievementInfo.childs.count; j++) {
        AchievementModel* childAchievement = (AchievementModel *)achievementInfo.childs[j];
        if([childAchievement.raceKey isEqualToString:@"d"]) {
            tempChildYesterday = [[achievementObject alloc] initWithName:childAchievement.raceName
                                                                 content:[NSString stringWithFormat: @"%ld", (long)childAchievement.rank]
                                                                  andKey:(int)@(RaceResultCell)];
            
        } else if ([childAchievement.raceKey isEqualToString:@"w"]) {
            tempChildWeek = [[achievementObject alloc] initWithName:childAchievement.raceName
                                                            content:[NSString stringWithFormat: @"%ld", (long)childAchievement.rank]
                                                             andKey:(int)@(RaceResultCell)];
            
        } else if([childAchievement.raceKey isEqualToString:@"m"]) {
            tempChildMonth = [[achievementObject alloc] initWithName:childAchievement.raceName
                                                             content:[NSString stringWithFormat: @"%ld", (long)childAchievement.rank]
                                                              andKey:(int)@(RaceResultCell)];
            
        } else if([childAchievement.raceKey isEqualToString:@"y"]) {
            tempChildYear = [[achievementObject alloc] initWithName:childAchievement.raceName
                                                            content:[NSString stringWithFormat: @"%ld", (long)childAchievement.rank]
                                                             andKey:(int)@(RaceResultCell)];
        }
    }
    if (tempChildYesterday != nil) {
        [result addObject:tempChildYesterday];
    }
    if (tempChildWeek != nil) {
        [result addObject:tempChildWeek];
    }
    if (tempChildMonth != nil) {
        [result addObject:tempChildMonth];
    }
    if (tempChildYear != nil) {
        [result addObject:tempChildYear];
    }
    [rankDictionary setObject: result forKey:@(section)];
}

- (void)extractAchievementsWithBestRank:(AchievementModel *)achievementInfo
                                 result:(NSMutableArray *)result section: (NSInteger) section
                              cellType:(int)cellType {
    achievementObject* tempAchivement = [[achievementObject alloc] initWithName:achievementInfo.raceName
                                                                        content:@""
                                                                         andKey:(int)@(ActiveRaceWithFlowerCell)];
    if (cellType == (int)@(ActiveRaceCell)) {
        [tempAchivement setNumber:(int)@(ClosedRaceCell)];
    } else if(cellType == (int)@(ActiveRaceWithFlowerCell)) {
        [tempAchivement setData: [NSString stringWithFormat:@"%lld", achievementInfo.num_flower]];
    }
    [result addObject:tempAchivement];
    achievementObject* tempBestRank = [[achievementObject alloc] initWithName:NSLocalizedString(@"AchievementBestRank.title",)
                                                                      content:[NSString stringWithFormat: @"%ld", (long)achievementInfo.rank]
                                                                       andKey:(int)@(RaceResultCell)];
    [result addObject:tempBestRank];
    [rankDictionary setObject: result forKey:@(section)];
}

- (void)setupEmptyDataView {
    NSString *emptyDataTxtValue = @"";
    if (activeRaces) {
        emptyDataTxtValue = NSLocalizedString(@"AchievementNoRank",);
    } else {
        emptyDataTxtValue = NSLocalizedString(@"AchievementNoResult",);
    }
    self.emptyDataText.text = emptyDataTxtValue;
    [self.emptyDataText setTextColor:[UIColor rgb:188 green:189 blue:190]];
    self.emptyDataText.font = [UIFont fontWithName:@"SFUIDisplay-Semibold" size:14];
    [self.emptyDataImageView setImage:[UIImage imageNamed:@"Icon_No_Rank"]];
}

// MARK: - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return rankDictionary.allKeys.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 && [showItemDictionary objectForKey: @(indexPath.section)] == nil) {
        return  10;
    }
    
    return indexPath.row == 0 ? 80 : 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [showItemDictionary objectForKey:@(section)] != nil ? ((NSMutableArray*)[rankDictionary objectForKey:@(section)]).count : (((NSMutableArray*)[rankDictionary objectForKey:@(section)]).count > 1 ? 2 : 0);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 && [showItemDictionary objectForKey: @(indexPath.section)] == nil) {
        return  [[UITableViewCell alloc] init];
    }
    
    NSString *identifier = @"ProfileAchievementList";
    ProfileAchievementsListTableViewCell *cell = (ProfileAchievementsListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ProfileAchievementsListTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.preservesSuperviewLayoutMargins = false;
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    achievementObject* rankInfo = ((NSMutableArray*)[rankDictionary objectForKey:@(indexPath.section)])[indexPath.row];
    if ([rankInfo getKey] == (int)@(RaceResultCell)) {
        [cell setUpType0:[rankInfo getName] rank:[rankInfo getData]];
    } else if([rankInfo getKey] == (int)@(ActiveRaceWithFlowerCell)) {
        [cell setUpType1:[rankInfo getName] flowers:[rankInfo getData]];
    } else if([rankInfo getKey] == (int)@(ActiveRaceCell)) {
        [cell setUpType2:[rankInfo getName]];
    } else if([rankInfo getKey] == (int)@(ClosedRaceCell)) {
        [cell setUpType3:[rankInfo getName]];
    }
    
    if ([rankInfo getKey] != (int)@(RaceResultCell)) {
        cell.headerImageView.image = ([showItemDictionary objectForKey:@(indexPath.section)] == nil) ? [UIImage imageNamed: @"ic_chievement_collap"] : [UIImage imageNamed: @"ic_chievement_expand"];
    }
    
    [cell setClipsToBounds:FALSE];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.row == 0) {
            if ([showItemDictionary objectForKey:@(indexPath.section)] == nil) {
                [showItemDictionary setObject: @(indexPath.section) forKey: @(indexPath.section)];
            } else {
                [showItemDictionary removeObjectForKey:@(indexPath.section)];
            }
            [self.tableView reloadData];
        }
}

@end
