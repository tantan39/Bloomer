//
//  AnonymousMyBloomerViewController.m
//  Bloomer
//
//  Created by Steven on 5/4/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "AnonymousMyBloomerViewController.h"

@interface AnonymousMyBloomerViewController () {
    UserDefaultManager *userDefaultManager;
    NSMutableArray *feedList;
    NSString *feedID;
    BOOL loaded;
    NSInteger model;
    NSMutableDictionary* raceFeeds;
}

@end

@implementation AnonymousMyBloomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    feedList = [[NSMutableArray alloc] init];
    raceFeeds = [[NSMutableDictionary alloc]init];
    feedID = @"";
    loaded = FALSE;
    
    __weak AnonymousMyBloomerViewController *weakSelf = self;
    
    [_updatesTableView addPullToRefreshWithActionHandler:^{
        AnonymousMyBloomerViewController *strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf pullToRefresh];
        }
    }];
    
    [_updatesTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf infiniteScrolling];
    }];
    
    [self.updatesTableView registerNib:[UINib nibWithNibName:FriendsUpdatesRaceTableViewCell.nibName bundle:nil] forCellReuseIdentifier:FriendsUpdatesRaceTableViewCell.cellIdentifier];
    
    [self loadUserFeed];
    [self initNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_tabbar updateFlowerValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pullToRefresh {
    feedID = @"";
    loaded = FALSE;
    
    [self loadUserFeed];
    [_updatesTableView.pullToRefreshView stopAnimating];
}

- (void)infiniteScrolling {
    if (feedList.count != 0) {
        feedID = [(feed_list *)([feedList objectAtIndex:feedList.count - 1]) feed_id];
    } else {
        feedID = @"";
    }
    
    [self loadUserFeed];
    [_updatesTableView.infiniteScrollingView stopAnimating];
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"My Bloomers",nil)];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - APIs

- (void)loadUserFeed
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_Feeds *feedRequest = [[API_Feeds alloc] initWithFeedId:feedID];
    [feedRequest request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if(response.status) {
            JSON_FeedList *data = (JSON_FeedList*)jsonObject;
            if (!loaded) {
                feedList = [data feeds];
                
                if (feedList.count == 0) {
                    self.emptyView.hidden = false;
                } else {
                    self.emptyView.hidden = true;
                    [_updatesTableView reloadData];
                    [self loadRaceFeed];
                    loaded = TRUE;
                }
            } else {
                if ([data feeds].count != 0)
                {
                    [feedList addObjectsFromArray:[data feeds]];
                    [_updatesTableView reloadData];
                    [self loadRaceFeed];
                }
            }
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)loadRaceFeed
{
    for (Feed* feedItem in feedList)
    {
        if ([feedItem.content_type isEqualToString:@"race"])
        {
            API_ClosedRaceFeed *apiMaleFeedRaceClose = [[API_ClosedRaceFeed alloc] initWithKey:feedItem.racekey gender:1];
            [apiMaleFeedRaceClose request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                if(response.status) {
                    JSON_ClosedRaceFeed *data = (JSON_ClosedRaceFeed*)jsonObject;
                    [raceFeeds setObject:data forKey:[NSString stringWithFormat:@"%@_%d", feedItem.racekey, 1]];
                }
            } ErrorHandlure:^(NSError *error) {
                
            }];
            
            API_ClosedRaceFeed *apiFemaleFeedRaceClose = [[API_ClosedRaceFeed alloc] initWithKey:feedItem.racekey gender:0];
            [apiFemaleFeedRaceClose request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                if(response.status) {
                    JSON_ClosedRaceFeed *data = (JSON_ClosedRaceFeed*)jsonObject;
                    [raceFeeds setObject:data forKey:[NSString stringWithFormat:@"%@_%d", feedItem.racekey, 0]];
                }
            } ErrorHandlure:^(NSError *error) {
                
            }];
        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return feedList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FriendsUpdatesRaceTableViewCell.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feed *temp = (Feed *)[feedList objectAtIndex:indexPath.row];

    // Race cell
    FriendsUpdatesRaceTableViewCell *cellRace = (FriendsUpdatesRaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:FriendsUpdatesRaceTableViewCell.cellIdentifier];
    
    //init value for Race cell
    cellRace.lblRaceName.text = temp.racename;
    cellRace.maleRace = [raceFeeds objectForKey:[NSString stringWithFormat:@"%@_%d",temp.racekey,1]];
    cellRace.femaleRace = [raceFeeds objectForKey:[NSString stringWithFormat:@"%@_%d",temp.racekey,0]];
    cellRace.navigationController = self.navigationController;
    
    [cellRace reloadRaceFeedByList:cellRace.femaleRace.winnerList];
    
    return cellRace;
}

@end
