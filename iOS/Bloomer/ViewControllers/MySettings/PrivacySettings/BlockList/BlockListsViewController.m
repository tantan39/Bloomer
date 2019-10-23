//
//  BlockListsViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "BlockListsViewController.h"

@interface BlockListsViewController () {
    UserDefaultManager *userDefaultManager;
    NSMutableArray *blockerList;
}

@end

@implementation BlockListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    blockerList = [[NSMutableArray alloc] init];
    
    [self initNavigationBar];
    [self loadBlocker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBar {
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:TITLE_FONT_NAME size:TITLE_FONT_SIZE];
    titleView.textColor = [UIColor whiteColor];
    titleView.text =NSLocalizedString( @"Block List",nil);
    [titleView sizeToFit];
    
    self.navigationItem.titleView = titleView;

}

- (void)loadBlocker {
    API_BlockLists_Fetches *api = [[API_BlockLists_Fetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_blocklists_fetches * data = (out_blocklists_fetches *) jsonObject;
        if (response.status)
        {
            blockerList = [data blockList];
            
            [_tableView reloadData];
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return blockerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"BlockLists";
    BlockListsTableViewCell *cell = (BlockListsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"BlockListsTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    blockers *temp = (blockers *)[blockerList objectAtIndex:indexPath.row];
    [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];

    cell.name.text = temp.name;
    cell.username.text = temp.username;
    cell.uid = temp.uid;
    cell.parentView = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


@end
