//
//  FlowerGiversListViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 6/1/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "FlowerGiversListViewController.h"


#define FOLLOWER_LIMIT 8

@interface FlowerGiversListViewController () {
    NSMutableArray *followerList;
    UserDefaultManager *userDefaultManager;
    NSInteger lastUserID;
    BOOL isFinal;
    BOOL isLoading;
}

@end

@implementation FlowerGiversListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    followerList = [[NSMutableArray alloc] init];
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    [self initNavigationBar];
    
    [self loadFollowerWithLoadMore:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(void)viewDidDisappear:(BOOL)animated{
 self.mainView.hidesBottomBarWhenPushed = TRUE;
}


- (void)initNavigationBar
{
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:NAVIGATION_TITLE_FONT_NAME size:16];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = NSLocalizedString(@"Flower Givers", nil) ;
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];

}


- (void)loadFollowerWithLoadMore:(BOOL)isMore {
    API_Profile_FollowerFetches *api = [[API_Profile_FollowerFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] userID:lastUserID limit:12 isLoadMore:isMore];
    
    isLoading = TRUE;
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_follower_fetches * data = (out_follower_fetches *) jsonObject;
        isLoading = FALSE;
        if (response.status) {
            isFinal = [data isFinal];
            if(api.isLoadMore){
                [followerList addObjectsFromArray:data.followerList];
            } else {
                followerList = data.followerList;
            }
            if(followerList.count>0)
                lastUserID = ((follower*)followerList[followerList.count-1]).uid;
            
            [_collectionView reloadData];
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /*float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge > scrollView.contentSize.height && !isFinal)
        [self loadFollowerWithLoadMore:YES];
     */
    if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) && !isLoading && !isFinal) {
        //reach bottom
         [self loadFollowerWithLoadMore:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return followerList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return CGSizeMake(160, 160);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"FlowerGivers";
    
    UINib *nib = [UINib nibWithNibName:@"FlowerGiversCollectionViewCell" bundle: nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    
    FlowerGiversCollectionViewCell *cell = (FlowerGiversCollectionViewCell *)[_collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    follower *temp = (follower *)[followerList objectAtIndex:indexPath.row];
    cell.name.text = temp.name;
    cell.profileID = temp.uid;
    cell.mainView = self.mainView;
    [cell.flower setHidden:NO];
    if (temp.flower > 1) {
        cell.flower.text = [NSString stringWithFormat:NSLocalizedString(@"Gave you %lld flowers",), temp.flower];
    } else if(temp.flower>0){
        cell.flower.text = [NSString stringWithFormat:NSLocalizedString(@"Gave you %lld flower",), temp.flower];
    } else {
        [cell.flower setHidden:YES];
    }
        
    
    [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
    
    return cell;
}

@end
