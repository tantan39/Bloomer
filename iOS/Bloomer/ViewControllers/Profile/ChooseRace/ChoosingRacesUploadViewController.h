//
//  ChoosingRacesUploadViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/7/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_RaceTagFetch.h"
#import "childs.h"
#import "UserDefaultManager.h"
#import "ChoosingRacesTableViewCell.h"
#import "UploadingPicturesTableViewController.h"
#import "UploadingPicturesViewController.h"

@interface ChoosingRacesUploadViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSMutableArray *uploadPhotos;
@property (weak, nonatomic) NSMutableArray *locationIndex;
@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) UIImage *chosenImage;
@property (assign, nonatomic) BOOL isCamera;


@end
