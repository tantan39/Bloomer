//
//  ChangeAvatarViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/21/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ChangeAvatarViewController.h"
#import "AppHelper.h"
#import "EditProfileViewController.h"
#import "AppDelegate.h"

@interface ChangeAvatarViewController () {
    ImagePickerPopUpViewController *popup;
    UserDefaultManager *userDefaultManager;
    NSMutableDictionary *btnRacesDict;
    NSSortDescriptor *sortDescriptor;
    NSArray *sortDescriptors;
    NSMutableArray *payloads;
}

@end

@implementation ChangeAvatarViewController

@synthesize curRaceKey = curRaceKey;

- (void)viewDidLoad {
    [super viewDidLoad];

    userDefaultManager = [[UserDefaultManager alloc] init];
    btnRacesDict = [[NSMutableDictionary alloc]init];
    _avatarListUpdate = [[NSMutableArray alloc] init];
    payloads = [[NSMutableArray alloc] init];
    
    [self initNavigationBar];
    
    [_avatarCollectionView allowsSelection];
    _avatarCollectionView.layer.cornerRadius = 20;
    
    UINib *leftNib = [UINib nibWithNibName:@"AvatarCollectionViewCell" bundle: nil];
    [_avatarCollectionView registerNib:leftNib forCellWithReuseIdentifier:@"AvatarCollectionCell"];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:YES];
    sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AppHelper changeNavigationBarToRed:self.navigationController];
    
    _avatarList = [[_avatarList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Update Profile Pictures", nil)];
}

- (void)touchDoneButton
{
    EditProfileViewController *view = (EditProfileViewController *)_parentView;
    [view loadAvatars];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initAvatar
{
    for (int i = 0; i < _avatarList.count; i++) {
        avatar *temp = (avatar *)[_avatarList objectAtIndex:i];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:temp.photo_url]]];
        ((UIImageView *)[self.view viewWithTag:i+1]).clipsToBounds = TRUE;
        ((UIImageView *)[self.view viewWithTag:i+1]).layer.cornerRadius = ((UIImageView *)[self.view viewWithTag:i+1]).frame.size.width / 2;
        ((UIImageView *)[self.view viewWithTag:i+1]).layer.borderWidth = 1.5;
        ((UIImageView *)[self.view viewWithTag:i+1]).layer.borderColor = [UIColor blackColor].CGColor;
        [((UIImageView *)[self.view viewWithTag:i+1]) setImage:image];//setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:temp.photo_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10] placeholderImage:nil success:nil failure:nil];
        ((UILabel *)[self.view viewWithTag:(i+8)]).text = temp.name;
        [btnRacesDict setObject:_racesButtons[i] forKey:temp.key];
    }
}

- (IBAction)touchAvatar:(UIButton *)sender
{
    popup = [[ImagePickerPopUpViewController alloc] initWithNibName:@"ImagePickerPopUpViewController" bundle:nil];
    popup.parentView = self;
    popup.isUploadAvatar = true;
    
    popup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
    [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
    
    curRaceKey = [btnRacesDict allKeysForObject:sender][0];
}


- (void)updateAvatarForRaceByIndex:(NSInteger)index andImage:(UIImage*) chosenImg
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_Avatar_RaceAttached *avatarAPI = [[API_Avatar_RaceAttached alloc] initWithAccessToken:[userDefaultManager  getAccessToken]  device_token:[userDefaultManager getDeviceToken] image:chosenImg key:curRaceKey];
    [avatarAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_avatar_attached * data = (out_avatar_attached *) jsonObject;
        if (response.status)
        {
            for (avatar* raceAvatar in _avatarList) {
                if([raceAvatar.key isEqualToString:curRaceKey])
                {
                    raceAvatar.photo_url = data.photo_url;
                }
            }
            [_avatarCollectionView reloadData];
            [NotificationHelper postNotificationUpdateNumberPhone];
        } else {
            
        }
        
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        curRaceKey = @"";
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self.navigationController setNavigationBarHidden:false animated:false];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];

}


#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return _avatarList.count + 2;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    return CGSizeMake(screenSize.width * 0.28, screenSize.width * 0.28);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"AvatarCollectionCell";
    
    AvatarCollectionViewCell *cell = (AvatarCollectionViewCell *)[_avatarCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSInteger curIndex = indexPath.row == 1 ? 0 : indexPath.row - 2;
    
    if(curIndex > 0 || indexPath.row==1)
    {
        avatar *temp = (avatar *)[_avatarList objectAtIndex:curIndex];
        UIImage *image = nil;
        if (temp.photo_url == nil) {
            image = [UIImage imageNamed:@"Icon_Default_Avatar"];
        }
        else {
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:temp.photo_url]]];
        }
        cell.avatarImg.clipsToBounds = TRUE;
        cell.avatarImg.layer.cornerRadius = cell.avatarImg.frame.size.width / 2;
        cell.avatarImg.layer.borderWidth = 1.5;
        cell.avatarImg.layer.borderColor = [UIColor blackColor].CGColor;
        [cell.avatarImg setImage:image];
        [cell.lblraceName setText: temp.name];
        cell.raceKey = temp.key;
    }else
    {
        cell.avatarImg.layer.borderColor = [UIColor clearColor].CGColor;
        cell.avatarImg.image = [[UIImage alloc]init];
        [cell.lblraceName setText: @""];
        cell.raceKey = @"";
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
     AvatarCollectionViewCell *datasetCell =(AvatarCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if([datasetCell.raceKey isEqualToString:@""])
        return;
    //add image to array
//    avatar *temp = (avatar *)[_avatarList objectAtIndex:indexPath.row];
    NSLog(@"selected - avatar of race key : %@",datasetCell.raceKey);
    popup = [[ImagePickerPopUpViewController alloc] initWithNibName:@"ImagePickerPopUpViewController" bundle:nil];
    popup.parentView = self;
    popup.isUploadAvatar = true;
    
    popup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
    [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
    curRaceKey = datasetCell.raceKey;
    
}

@end
