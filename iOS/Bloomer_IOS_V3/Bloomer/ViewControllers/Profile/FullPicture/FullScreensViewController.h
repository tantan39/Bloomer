//
//  FullScreensViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/17/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreensViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) UIImage *photo;
@property (strong,nonatomic) NSString * strURL;

@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) BOOL isScrollingEnabled;
@property (strong, nonatomic) NSMutableArray *faceData;
@property (strong, nonatomic) NSMutableArray *galerryData;

@property (weak, nonatomic) UIViewController *parentView;
@property (assign, nonatomic) BOOL isMultiple;

- (IBAction)touchBack:(id)sender;

@end
