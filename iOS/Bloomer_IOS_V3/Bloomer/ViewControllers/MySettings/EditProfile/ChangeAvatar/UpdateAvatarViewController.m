//
//  ChangeAvatarV3ViewController.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 11/29/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "UpdateAvatarViewController.h"
#import "UIView+Extension.h"

#define widthShadow = 20
#define hightTextTile = 72

@interface UpdateAvatarViewController () {
    UserDefaultManager *userDefaultManager;
    out_profile_fetch *profileData;
    NSSortDescriptor *sortDescriptor;
    NSArray *sortDescriptors;
    UIImage *chosenImage;
}
@property (nonatomic, strong) NSMutableArray *items;
@property (atomic, assign) BOOL isAppear;
@property (atomic, assign) BOOL isFirstLoad;

@end

@implementation UpdateAvatarViewController

@synthesize avatarList = avatarList;

-(void)dealloc {
    self.carousel.delegate = nil;
    self.carousel.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isAppear = FALSE;
    self.isFirstLoad = FALSE;
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    [self initNavigationBar];
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:YES];
    sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    avatarList = [[NSMutableArray alloc] init];
    self.curRaceKey = @"";
    self.items = [NSMutableArray array];
    for (int i = 0; i < 10; i++)
    {
        [self.items addObject:@(i)];
    }
    self.carousel.type = iCarouselTypeRotary;
    [self.carousel setPagingEnabled:TRUE];
    [self loadAvatars];
    [self.view setClipsToBounds:TRUE];
    [self.albumBloomerBtn setShadowRadius:4.0f shadowOffset:CGSizeMake(0, 3.0f)];
    [self.cameraBtn setShadowRadius:4.0f shadowOffset:CGSizeMake(0, 3.0f)];
    [self.galleryBtn setShadowRadius:4.0f shadowOffset:CGSizeMake(0, 3.0f)];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    self.isAppear = TRUE;
    if (self.avatarList.count > 0 && !self.isFirstLoad) {
        [self.carousel reloadData];
        self.isFirstLoad = TRUE;
    }
}

- (void)initNavigationBar {
    self.navigationItem.title = [AppHelper getLocalizedString:@"UpdateAvatarViewController.title"];
}

- (IBAction)touchCamera:(id)sender {
    [self showBloomerAlbum];
}

- (IBAction)touchGallery:(id)sender {
    [self openCamera];
}

- (IBAction)touchAlbumBloomer:(id)sender {
    [self showPhotoGallery];

}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[avatarList count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    UIImageView *image = nil;
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.carousel.frame.size.width / 2, self.carousel.frame.size.width / 2 + 72)];
        image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon_Default_Avatar"]];
        image.image = nil;
        image.contentMode = UIViewContentModeScaleToFill;
        [image setClipsToBounds:TRUE];
        image.translatesAutoresizingMaskIntoConstraints = false;
        image.tag = 2;

        label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"SFProText-Semibold" size: 16];
        label.tag = 1;
        label.numberOfLines = 2;
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        UIView* viewImage = [[UIView alloc] init];
        viewImage.tag = 3;
        [viewImage setTranslatesAutoresizingMaskIntoConstraints:NO];

        [viewImage addSubview:image];
        [AppHelper setupFullStretchConstraintsForView:image parentView:viewImage];
        [view addSubview:viewImage];
        [view addSubview:label];
        [self addConstraintImage:view image:viewImage width:view.frame.size.width -  20];
        [self addConstraintlabel:view image:viewImage lable:label];
        image.layer.cornerRadius = (view.frame.size.width -  20)/2;

    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
        image = (UIImageView *)[view viewWithTag:2];
    }
    avatar *temp = [avatarList objectAtIndex:index];
    label.text = temp.name;
    if (temp.photo_url != nil) {
        [image setImageWithURL:[NSURL URLWithString:temp.photo_url]];
    } else {
        image.image = [UIImage imageNamed:@"Icon_Default_Avatar"];
    }

    [view layoutIfNeeded];
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 0;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil) {
        view = [[UIView alloc] init];
    }
    return view;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return false;
        }
        case iCarouselOptionArc:{
            return 2 * M_PI * 0.01f;
        }
            
        case iCarouselOptionSpacing:
        {
            return value * 1.0;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    for (UIView* view in carousel.visibleItemViews) {
        UILabel* label = (UILabel *)[view viewWithTag:1];
        UIView *image = (UIView *) [view viewWithTag:2];
        UIView *viewImage = (UIView *) [view viewWithTag:3];
        if (view != carousel.currentItemView) {
            [UIView animateWithDuration:0.2 animations:^{
                [self addConstraintImage: view image:viewImage width:view.frame.size.width/1.6];
                [self addConstraintlabel: view image:viewImage lable:label];
                [AppHelper setupFullStretchConstraintsForView:image parentView:viewImage];
                label.font = [UIFont fontWithName:@"SFProText-Medium" size:18];
                label.textColor = [UIColor rgb:119 green:119 blue:119];
                image.layer.cornerRadius = view.frame.size.width/1.6/2;
                [view layoutIfNeeded];
            }];
            
        } else {
  
            [UIView animateWithDuration:0.2 animations:^{
                [self addConstraintImage:view image:viewImage width:view.frame.size.width - 15];
                [self addConstraintlabel:view image:viewImage lable:label];
                [AppHelper setupFullStretchConstraintsForView:image parentView:viewImage];
                label.font = [UIFont fontWithName:@"SFProText-Bold" size:20];
                label.textColor = [UIColor rgb:68 green:68 blue:68];
                image.layer.cornerRadius = (view.frame.size.width - 15)/2;
                [view layoutIfNeeded];
            }];
        }
    }
    
    if (avatarList.count > 0) {
        avatar *temp = [avatarList objectAtIndex:carousel.currentItemIndex];
        self.curRaceKey = temp.key;
    }

}

- (void) addConstraintImage: (UIView*) viewParent image: (UIView*) image  width: (CGFloat) width {
    
    [viewParent removeConstraints: [viewParent constraints]];
    
    [viewParent addConstraint:[NSLayoutConstraint constraintWithItem:image
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:viewParent
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0 constant:0]];
    
    [viewParent addConstraint:[NSLayoutConstraint constraintWithItem:image
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:viewParent
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0 constant:0]];
    
    [viewParent addConstraint:[NSLayoutConstraint constraintWithItem:image
                                                           attribute: NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:0.0 constant:width]];
    
    [viewParent addConstraint:[NSLayoutConstraint constraintWithItem:image
                                                           attribute: NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:0.0 constant:width]];
    [self setShadowUIview:image radius: 4.0f shadowOffset:CGSizeMake(0.0, 5.0)];
}

- (void) setShadowUIview: (UIView*) view radius: (CGFloat) radius shadowOffset: (CGSize) size  {
    [view.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [view.layer setShadowRadius:4.0f];
    [view.layer setShadowOffset:CGSizeMake(0, 7)];
    [view.layer setShadowOpacity:0.4f];
}

- (void) addConstraintlabel: (UIView*) viewParent image: (UIView*) image lable: (UILabel*) label{
    
    [viewParent addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:image
                                                           attribute: NSLayoutAttributeBottom
                                                          multiplier:1
                                                            constant:16]];
    
    
    [viewParent addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:image
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0 constant:0]];
    
    
    [viewParent addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute: NSLayoutAttributeNotAnAttribute
                                                          multiplier: 0.0
                                                            constant:viewParent.frame.size.width - 16]];
    
}

#pragma mark - Show Photo Gallery
- (void) showPhotoGallery
{
        PhotoGalleryViewController *photoGalleryViewController = [[PhotoGalleryViewController alloc] initWithNibName:@"PhotoGalleryViewController" bundle:nil];
        photoGalleryViewController.hidesBottomBarWhenPushed = true;
        photoGalleryViewController.parentView = self;
        photoGalleryViewController.isMultipleChoice = false;
        [self.navigationController pushViewController:photoGalleryViewController animated:true];
}



- (void)loadAvatars {
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_Profile_AvatarsFetches *api = [[API_Profile_AvatarsFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_avatars_fetches * data = (out_avatars_fetches *) jsonObject;
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        if (response.status) {
            //re-order avatar list by category
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:YES];
            sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            //        avatarList = [data avatarList];
            avatarList = [[[data avatarList] sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
            if([avatarList count] == 0) {
                avatar *avatarRace = [[avatar alloc] initWithName:profileData.location_name key:profileData.city.city_short_name phptoURL:nil category:RACECATEGORY_LOCATION];
                [avatarList addObject:avatarRace];
            }
            
            if (self.isAppear) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.carousel reloadData];
                });
            }
           
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];

    }];
    
}

#pragma mark - Open Camera
- (void) openCamera
{
    __weak __typeof(self)weakSelf = self;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.cropMode = DZNPhotoEditorViewControllerCropModeCircular;
    picker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        // Dismiss when the crop mode was disabled
        if (picker.cropMode == DZNPhotoEditorViewControllerCropModeNone) {
            [weakSelf handleImagePicker:picker withMediaInfo:info];
        }
    };
    
    picker.cancellationBlock = ^(UIImagePickerController *picker) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)showBloomerAlbum
{
    [self loadGallery];
}

- (void)loadGallery {
    
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_Profile_Gallery_Fetches *API = [[API_Profile_Gallery_Fetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:[userDefaultManager getUserProfileData].uid];
    [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        out_profile_gallery_fetches * data = (out_profile_gallery_fetches *) jsonObject;
        if (response.status) {
            BloomerAlbumViewController *viewController = [[BloomerAlbumViewController alloc] initWithNibName:@"BloomerAlbumViewController" bundle:nil];
            viewController.raceIndex = 0;
            viewController.galleryList = [data galleryList];
            viewController.hidesBottomBarWhenPushed = true;
            viewController.parentView = self;
            [self.navigationController pushViewController:viewController animated:true];
        } else {
            [Support addErrorMessage:response.message intoView:self.view];
        }
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)handleImagePicker:(UIImagePickerController *)picker withMediaInfo:(NSDictionary *)info
{
    chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
            self.isUploadFromBloomer = false;
            [self updateAvatarForRaceByIndex:0 andImage:chosenImage];
        
    }];
}

- (void)photoPickerControllerDidCancel {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7"))
    {
        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    }
}

- (void)updateAvatarForRaceByIndex:(NSInteger)index andImage:(UIImage*) chosenImg
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_Avatar_RaceAttached *avatarAPI = [[API_Avatar_RaceAttached alloc] initWithAccessToken:[userDefaultManager  getAccessToken]  device_token:[userDefaultManager getDeviceToken] image:chosenImg key:self.curRaceKey];
    [avatarAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_avatar_attached * data = (out_avatar_attached *) jsonObject;
        if (response.status)
        {
            for (avatar* raceAvatar in avatarList) {
                if([raceAvatar.key isEqualToString:self.curRaceKey])
                {
                    raceAvatar.photo_url = data.photo_url;
                }
            }
            [self.carousel reloadData];
            
        } else {
            
        }
        
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        self.curRaceKey = @"";
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self.navigationController setNavigationBarHidden:false animated:false];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
    
}

@end
