//
//  FullScreensViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/17/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "FullScreensViewController.h"
#import "AppDelegate.h"


@interface FullScreensViewController ()
{
    BOOL isRotate;
    NSMutableArray *picture;
    NSMutableArray *images;
    UserDefaultManager *userDefaultManager;
    NSString *postID;
    NSString *lastPostID;
    Spinner *spinner;
    UIImageView *imgvMain;
    UIVisualEffectView *blurEffectView;
}

@end


#define VIEW_FOR_ZOOM_TAG (11)
@implementation FullScreensViewController
- (instancetype)init{
    self = [super initWithNibName:@"FullScreensViewController" bundle:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    picture = [[NSMutableArray alloc] init];
//    images = [[NSMutableArray alloc] init];
//    userDefaultManager = [[UserDefaultManager alloc] init];
//    isRotate = FALSE;
//    lastPostID = @"";
//    spinner = ((AppDelegate*)[UIApplication sharedApplication].delegate).spinner;
//    
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
//    singleTap.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:singleTap];
//    
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
//    doubleTap.numberOfTapsRequired = 2;
//    [self.view addGestureRecognizer:doubleTap];
//    
//    [singleTap requireGestureRecognizerToFail:doubleTap];
//    
//    [_scrollView setScrollEnabled:TRUE];
////    [_scrollView setPagingEnabled:YES];
//    
//    [self initPhotoScrollView];
//    
//    if (_strURL) {
//        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.strURL] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                    [blurEffectView removeFromSuperview];
//                    imgvMain.image = image;
//                } completion:nil];
//            });
//        }];
//    }
    
}


#pragma mark - Zooming handle
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imgvMain;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [_scrollView setScrollEnabled:FALSE];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (_scrollView.zoomScale == 1 ) {
        [_scrollView setScrollEnabled:TRUE];
    }
}

- (IBAction)touchBack:(id)sender
{
    //    FullPictureViewController *parent = (FullPictureViewController *)_fullPictureViewController;
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = YES;
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView {
    CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}


#pragma mark - Rotation handle
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    isRotate = TRUE;
    _scrollView.zoomScale = 1;
    
    if (picture.count > 1) {
        [_scrollView setScrollEnabled:TRUE];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGRect frame;
    frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [imgvMain setFrame:frame];
    
    [_scrollView setFrame:frame];
    [_scrollView setContentSize:CGSizeMake(frame.size.width , frame.size.height)];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    isRotate = FALSE;
}

#pragma mark - Tap Handle
- (void)handleSingleTap {
    _scrollView.zoomScale = 1;
}

- (void)handleDoubleTap
{
    if (_scrollView.zoomScale == 4)
    {
        _scrollView.zoomScale = 1;
    }
    else
    {
        _scrollView.zoomScale = 4;
    }
}

- (void)initPhotoScrollView
{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    NSInteger totalPhoto = self.galerryData.count;
    NSMutableArray *tempGalleryData = [[NSMutableArray alloc] init];
    
    if (!self.isMultiple)
    {
        gallery *data = (gallery*)[self.galerryData objectAtIndex:self.currentIndex];
        [tempGalleryData addObject:data];
        
        totalPhoto = 1;
        self.currentIndex = 0;
    }
    else
    {
        tempGalleryData = self.galerryData;
    }
    

    imgvMain = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    [imgvMain setBackgroundColor:[UIColor blackColor]];
    [imgvMain setImage:self.photo];
    imgvMain.contentMode = UIViewContentModeScaleAspectFit;
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        imgvMain.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [imgvMain addSubview:blurEffectView]; //if you have more UIViews, use an insertSubview API to place it where needed
    } else {
        imgvMain.backgroundColor = [UIColor blackColor];
    }
    
    [_scrollView addSubview:imgvMain];

    
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 4;
    _scrollView.zoomScale = 1.0f;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    [_scrollView setFrame:frame];
    [_scrollView setContentSize:CGSizeMake(frame.size.width, frame.size.height)];
}


#pragma mark - API request handle & Scrollview
- (void)loadPhotoScrollView {
    [spinner startAnimating];
    
    API_FaceUser *userPostsAPI = [[API_FaceUser alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                    device_token:[userDefaultManager getDeviceToken]
                                                                         user_id:[NSString stringWithFormat:@"%ld",[userDefaultManager getUserProfileData].uid]
                                                                             min:0
                                                                             max:12
                                                                          postID:postID
                                                                        order_by:@"desc"];
    [userPostsAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_faces * data = (out_faces *) jsonObject;
        if (response.status)
        {
            if (data.faces.count != 0)
            {
                [_faceData addObjectsFromArray:data.faces];
                [picture removeAllObjects];
                [images removeAllObjects];
                [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self initPhotoScrollView];
            }
        }else{
            [AppHelper showMessageBox:nil message:response.message];
        }
        
        [spinner stopAnimating];
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];

}


@end
