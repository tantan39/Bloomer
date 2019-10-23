//
//  TutorialViewController.m
//  Bloomer
//
//  Created by VanLuu on 6/28/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()
{
    NSInteger currentIndex;
}
@property (strong, nonatomic) IBOutletCollection(FLAnimatedImageView) NSArray *tutorialCollection;
@property (weak, nonatomic) IBOutlet UIScrollView *tutorialScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_tutorialScrollView setContentSize:CGSizeMake(320*3, 450)];
    for (int i =0; i < 3; i++) {
        NSString *sTut = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"tutorial_0%d",i+1] ofType: @"gif"];
        NSData *dataTut = [NSData dataWithContentsOfFile: sTut];
        FLAnimatedImage *imgTut = [FLAnimatedImage animatedImageWithGIFData:dataTut];
        
//        UILabel* turText1= [[UILabel alloc]init];
        [imgTut setLoopCount:0];
        
        [_tutorialCollection[i] setAnimatedImage:imgTut];
        [_tutorialCollection[i] setFrame:CGRectMake(10 + i*320, 59, 300, 450)];
        ((FLAnimatedImageView*)_tutorialCollection[i]).debug_delegate = self;
    }
    [_tutorialCollection[0] addSubview:[self createTutorialTitleWithText:@"Join the leaderboards with the themes you love\nCreate picture albums for each theme"]];
    [_tutorialCollection[1] addSubview:[self createTutorialTitleWithText:@"Connect and support othres by giving flowers\nto their pictures!"]];
    [_tutorialCollection[2] addSubview:[self createTutorialTitleWithText:@"Leaderboards come in a variety of themes.\nReceive flowers to improve your ranking\non the leaderboards and become a top Bloomer!"]];
}

-(UILabel*)createTutorialTitleWithText:(NSString*) text{
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, -40, 320, 50)];
    lblTitle.text = text;
    lblTitle.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:11];
    lblTitle.numberOfLines = 3;
//    lblTitle.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
//    lblTitle.adjustsFontSizeToFitWidth = YES;
//    lblTitle.adjustsLetterSpacingToFitWidth = YES;
//    lblTitle.minimumScaleFactor = 10.0f/12.0f;
    lblTitle.clipsToBounds = YES;
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    
    return lblTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Srcollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    if ((NSInteger)sender.contentOffset.x % (NSInteger)[UIScreen mainScreen].bounds.size.width == 0) {
        currentIndex = sender.contentOffset.x / ((NSInteger)[UIScreen mainScreen].bounds.size.width);
        _pageControl.currentPage = currentIndex;
        [((FLAnimatedImageView*)_tutorialCollection[currentIndex]) stopAnimating];
        [((FLAnimatedImageView*)_tutorialCollection[currentIndex]) startAnimating];
        
    }
}

bool startToEnd = false;

- (void)debug_animatedImageView:(FLAnimatedImageView *)animatedImageView waitingForFrame:(NSUInteger)index duration:(NSTimeInterval)duration
{
    
    if([animatedImageView isEqual:_tutorialCollection[2]] && currentIndex == 2)
    {
        if (index == animatedImageView.animatedImage.frameCount - 1 )
        {
            startToEnd = true;
        }
        if (startToEnd && index ==1) {
            [animatedImageView stopAnimating];
            if (_tutorialScrollView.scrollEnabled) {
                [_tutorialScrollView setScrollEnabled:FALSE];
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                UserDefaultManager *userManager = [appDelegate getUserManager];
                [userManager didTutorial:TRUE];
                SelectScreenViewController *view = [[SelectScreenViewController alloc] initWithNibName:@"SelectScreenViewController" bundle:nil];
                [self.navigationController pushViewController:view animated:YES];
            }
        }
    }
    
    
}

@end
