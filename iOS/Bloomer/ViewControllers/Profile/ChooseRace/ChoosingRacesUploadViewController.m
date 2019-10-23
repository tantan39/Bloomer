//
//  ChoosingRacesUploadViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/7/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ChoosingRacesUploadViewController.h"
#import "AppHelper.h"

//#define MULTIPLE_TAG
@interface ChoosingRacesUploadViewController () {
    UserDefaultManager *userDefaultManager;
    NSMutableArray *tag;
    NSMutableArray *tagSend;
    NSMutableArray *name;
    NSMutableArray *selectedIndexes;
}

@property (strong, nonatomic) UIBarButtonItem *buttonNext;

@end

@implementation ChoosingRacesUploadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    selectedIndexes = [[NSMutableArray alloc] init];
    tag = [[NSMutableArray alloc] init];
    tagSend = [[NSMutableArray alloc] init];
    name = [[NSMutableArray alloc] init];
    
    [self loadRaceNames];
    [self initNavigationController];
    [self.buttonNext setEnabled:FALSE];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [AppHelper changeNavigationBarToWhite:self.navigationController];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [AppHelper changeNavigationBarToRed:self.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationController
{
    self.buttonNext = [[UIBarButtonItem alloc] initWithTitle:[AppHelper getLocalizedString:@"common.buttonNext"] style:UIBarButtonItemStylePlain target:self action:@selector(touchButtonNext:)];
    self.navigationItem.rightBarButtonItem = self.buttonNext;
}

- (void)loadRaceNames {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_RaceTagFetch *api = [[API_RaceTagFetch alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                             device_token:[userDefaultManager getDeviceToken]];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status) {
            JSON_RaceTagsFetch *data = (JSON_RaceTagsFetch *)jsonObject;
            for (int i = 0; i < data.tagList.count; i++) {
                childs *temp = data.tagList[i];
                [tag addObject:temp.key];
                [name addObject:temp.name];
            }
            
            [_tableView reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:response.message
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tag.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"ChoosingRaces";
    
    ChoosingRacesTableViewCell *cell = (ChoosingRacesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ChoosingRacesTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    cell.name.text = [name objectAtIndex:indexPath.row];
    [cell.tick setHidden:TRUE];
    
    for (int i = 0; i < selectedIndexes.count; i++) {
        NSIndexPath *idx = (NSIndexPath *)[selectedIndexes objectAtIndex:i];
        
        if (idx.row == indexPath.row) {
            [cell.tick setHidden:FALSE];
            break;
        }
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    ChoosingRacesTableViewCell* cell = (ChoosingRacesTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
#ifdef MULTIPLE_TAG
    NSString *key = tag[indexPath.row];
    
    BOOL containt = FALSE;
    int deleteIndex = 0;
    
    for (int i = 0; i < locationIndex.count; i++) {
        NSIndexPath *idx = (NSIndexPath *)[locationIndex objectAtIndex:i];
        
        if (idx.row == indexPath.row) {
            containt = TRUE;
            deleteIndex = i;
            break;
        }
    }
    
    if (!containt) {
        [tagSend addObject:key];
        [locationIndex addObject:indexPath];
    } else {
        [tagSend removeObjectAtIndex:deleteIndex];
        [locationIndex removeObjectAtIndex:deleteIndex];
    }
    
    [tableView reloadData];
#else
    NSString *key = tag[indexPath.row];
    if ([tagSend count]==0 && [selectedIndexes count]==0) {
        [tagSend addObject:key];
        [selectedIndexes addObject:indexPath];
    } else {
        [tagSend replaceObjectAtIndex:0 withObject:key];
        [selectedIndexes replaceObjectAtIndex:0 withObject:indexPath];
    }
    [tableView reloadData];
    [self.buttonNext setEnabled:TRUE];
#endif
}

// MARK: - Selectors
- (void)touchButtonNext:(UIBarButtonItem*)button
{
    UploadingPicturesTableViewController *view = [[UploadingPicturesTableViewController alloc] init];
    
    if (!self.isCamera)
    {
        view.uploadPhotos = _uploadPhotos;
        view.locationIndex = _locationIndex;
    }
    else
    {
        view.uploadPhotos = [[NSMutableArray alloc]initWithObjects:_chosenImage, nil];
    }
    
    view.parentView = _parentView;
    view.tag = tagSend;
    view.key = [tagSend objectAtIndex:0];
    view.name = [name objectAtIndex:[(NSIndexPath*)[selectedIndexes objectAtIndex:0] row]];
    [self.navigationController pushViewController:view animated:TRUE];
}

@end
