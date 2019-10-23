//
//  PhotoGalleryViewController.h
//  Bloomer
//
//  Created by Steven on 6/4/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoGalleryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewCenterY;

@property (copy, nonatomic) void(^chosePhoto)(UIImage *chosenImage);
@property (copy, nonatomic) void(^cancelChoosePhoto)();

@property (weak, nonatomic) UIViewController *parentView;
@property (assign, nonatomic) BOOL isMultipleChoice;
@property (weak, nonatomic) NSString* key;
@property (weak, nonatomic) NSString* raceName;

@end
