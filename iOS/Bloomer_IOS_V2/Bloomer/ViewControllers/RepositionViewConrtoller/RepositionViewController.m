//
//  RepositionViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/15/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "RepositionViewController.h"
#import "MyProfileViewController.h"
#import "AppDelegate.h"
#import "AppHelper.h"

@interface RepositionViewController ()
{
    UserDefaultManager *userDefaultManager;
}

@property (assign, nonatomic) CGFloat rootPositionY;
@property (assign, nonatomic) BOOL dragging;
@property (assign, nonatomic) CGFloat lastDraggedPointY;
@property (assign, nonatomic) CGSize imageFitSize;

@end

@implementation RepositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    userDefaultManager = [[UserDefaultManager alloc] init];
    self.imagePhotoAPI = [[image_photo alloc] init];
    
    self.gridView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.gridView.layer.borderWidth = 1;
    
//    [self.photo setImageWithURL:[NSURL URLWithString:self.photoURL]];
    
    [self.photo setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.photoURL]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        self.photo.image = image;
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat height = ceil(screenSize.width * image.size.height / image.size.width);
        CGFloat viewHeight = (screenSize.height - 64);
        
        self.imageFitSize = CGSizeMake(screenSize.width, height);
                
        self.rootPositionY = viewHeight / 2 - height / 2;
        self.topViewHeight.constant = self.rootPositionY;
        
    } failure: nil];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.badgeNumber removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:appDelegate.badgeNumber];
}

- (void) initNavigationBar
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(touchDoneButton)];
    doneButton.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Repositioning", nil)];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:self.gridView];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.dragging = true;
//            self.lastDraggedPointY = self.rootPositionY + translation.y;
            break;
            
        case UIGestureRecognizerStateChanged:
            
            if (self.dragging)
            {
                CGFloat positionY = 0;
                
//                if (translation.y <= 0)
//                {
//                    positionY = self.gridView.frame.origin.y - translation.y;
//                }
//                else
//                {
//                    positionY = self.lastDraggedPointY + translation.y;
//                }
                
                positionY = self.rootPositionY + translation.y;
                
                if (positionY >= self.rootPositionY && positionY <= self.rootPositionY + self.imageFitSize.height - self.gridView.frame.size.height)
                {
                    self.topViewHeight.constant = positionY;
                }
                else
                {
                    if (positionY > self.rootPositionY + self.imageFitSize.height - self.gridView.frame.size.height)
                    {
                        self.topViewHeight.constant = self.rootPositionY + self.imageFitSize.height - self.gridView.frame.size.height;
                    }
                    else
                    {
                        self.topViewHeight.constant = self.rootPositionY;
                    }
                }
                
//                self.lastDraggedPointY = positionY;
            }
            
            break;
            
        case UIGestureRecognizerStateEnded:
            self.dragging = false;
            
        default:
            break;
    }
}

- (void)touchDoneButton
{
    CGFloat x1 = self.gridView.frame.origin.x;
    CGFloat y1 = self.gridView.frame.origin.y - self.rootPositionY;
    CGFloat x2 = x1 + self.photo.image.size.width;
    CGFloat y2 = y1 + self.gridView.frame.size.height;
    NSLog(@"%f - %f", x1, y1);
    NSLog(@"%f - %f", x2, y2);
    NSLog(@"Image Scale : %f", self.photo.image.scale);
    
    [self.croppedRects replaceObjectAtIndex:self.currentIndex withObject:[NSValue valueWithCGRect:CGRectMake(x1, y1, x2, y2)]];
    
    UIImage *croppedImage = [AppHelper cropToBounds:self.photo.image rect:CGRectMake(self.gridView.frame.origin.x, self.gridView.frame.origin.y - self.rootPositionY, self.photo.image.size.width, self.gridView.frame.size.height)];
    self.needRepositionPhoto.image = croppedImage;
    [self.navigationController popViewControllerAnimated:true];

}


@end
