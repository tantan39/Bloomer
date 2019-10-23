//
//  ProfileRaceListTableViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/24/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ProfileRaceListTableViewCell.h"
#import "PhotoListViewController.h"
#import "AppHelper.h"

@implementation ProfileRaceListTableViewCell {
    UserDefaultManager *userDefaultManager;
    NSString* photoURL_01;
    NSString* photoURL_02;
    NSString* photoURL_03;
    NSMutableArray* photoList;
}

+ (NSString *)cellIdentifier {
    return @"ProfileRaceList";
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    userDefaultManager = [[UserDefaultManager alloc] init];

    [_thankyouView setHidden:YES];
    [_thankyouView1 setHidden:YES];
    
    [self.labelNoPhoto setText:NSLocalizedString(@"No Photos Yet", )];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    [self initCell];
}

- (void)initCell{
    [_thankyouView removeFromSuperview];
    [_thankyouView1 removeFromSuperview];
    
    _thankyouView = [[ThankYou alloc]initWithStyle:ThankYouStyleForCollectionViewCell atPoint:CGPointMake(self.photo1View.frame.origin.x,self.photo1View.frame.origin.y) frame:self.photo1View.bounds];
    [self addSubview:_thankyouView];
    
    _thankyouView1 = [[ThankYou alloc]initWithStyle:ThankYouStyleForCollectionViewCell atPoint:CGPointMake(self.photo2View.frame.origin.x,self.photo2View.frame.origin.y ) frame:self.photo1View.bounds];
    [self addSubview:_thankyouView1];
    
    _photo1.image = nil;
    _photo2.image = nil;
    _photo3.image = nil;
    [_BlockIcon setHidden:YES];
    [_thankyouView setHidden:YES];
    [_thankyouView1 setHidden:YES];
    _draggableLocation.delegate = nil;
    _draggableLocation1.delegate = nil;
}

-(void) showThankYou:(BOOL)isShow atIndex:(int) index{
//    [_thankyouView setFrame:CGRectMake(_thankyouView.frame.origin.x, _thankyouView.frame.origin.y, self.photo1.bounds.size.width, self.photo1.bounds.size.height)];
    if(index == 0)
    {
        if(isShow == TRUE)
        {
           [_thankyouView setHidden:NO];
        }
        else
        {
            [_thankyouView setHidden:YES];
        }
    }
    else if(index == 1)
    {
        [_thankyouView1 setHidden:!isShow];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    _viewAllButton.layer.cornerRadius = 11.5;
//    _viewAllButton.layer.borderWidth = 1;
//    _viewAllButton.layer.borderColor = [UIColor colorWithRed:0.29 green:0.565 blue:0.886 alpha:1.0].CGColor;
    
    [_LoadMoreImage setImage:[UIImage imageNamed:@"Icon_More_White"]];
    self.clickMoreView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
//    icon_ViewMore_Píc
    [self.BlockIcon setImage:[UIImage imageNamed:@"icon_Key_ClosedLeaderboard"]];
    if(_status == RACE_CLOSED || _status == RACE_LEFT)
    {
        [_BlockIcon setHidden:NO];
    }
    else
    {
        [_BlockIcon setHidden:YES];
    }
    _loadMoreLabel.text = NSLocalizedString(@"imageLoadMoreLabel.title", );
    
    _photo1.clipsToBounds = TRUE;
    _photo2.clipsToBounds = TRUE;
    _photo3.clipsToBounds = TRUE;
    _done = FALSE;
}

-(void)loadPhotoByIndex:(NSInteger)index photoURL:(NSString*)photoURL postID:(NSString *) postId{
    UITapGestureRecognizer *pictureViewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImageCell:)];
    NSURL * url = [NSURL URLWithString:photoURL];
    switch (index) {
        case 0: {
            _photo1View.tag = 0;
            _draggableLocation.tag = 0;
            _postID = postId;
            [_photo1View addGestureRecognizer:pictureViewTapRecognizer];
            if (![photoURL isEqualToString:@""]) {
                [_photo1 setImageWithAnimationFromURL:url placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];
            }
            break;}
        case 1:{
            _photo2View.tag = 1;
            _draggableLocation.tag = 1;
            _postID1 = postId;
            [_photo2View addGestureRecognizer:pictureViewTapRecognizer];
            if (![photoURL isEqualToString:@""]) {
                [_photo2 setImageWithAnimationFromURL:url placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];
            }

            break;}
        case 2:{
            _photo3View.tag = 2;
            [_photo3View addGestureRecognizer:pictureViewTapRecognizer];
            if([photoURL isEqualToString:@""] == false)
            {
                [self.clickMoreView setHidden:false];
            }
            else
            {
                [self.clickMoreView setHidden:TRUE];
            }
            if (![photoURL isEqualToString:@""]) {
                [_photo3 setImageWithAnimationFromURL:url placeHolder:[UIImage imageNamed:@"Banners_mockup.png"]];
            }

            break;}
    }
}

- (void)loadPhotosByArray:(NSMutableArray*) photos{
    for (int i = 0 ; i < 3; i++) {
        if(i < photos.count){
            [self loadPhotoByIndex:i photoURL:((gallery*)photos[i]).photo_url postID:((gallery*)photos[i]).post_id];

        }
        else{
            [self loadPhotoByIndex:i photoURL:@"" postID:@""];
        }
        
    }
    photoList= [photos mutableCopy];
}

- (void)touchImageCell:(UITapGestureRecognizer *)tapRecognizer
{
    if ([userDefaultManager isAnonymous])
    {
        [AppHelper showAnonymousLoginPopUpView];
    }
    else
    {
        if (tapRecognizer.view.tag >= photoList.count)
            return;
        
        PhotoListViewController *viewController = [[PhotoListViewController alloc] initWithNibName:@"PhotoListViewController" bundle:nil];
        viewController.raceName = self.raceName.text;
        viewController.raceKey = self.key;
        viewController.uid = self.uid;
        viewController.status = self.status;
        viewController.currentIndexPath = [NSIndexPath indexPathForRow:tapRecognizer.view.tag inSection:0];
        
        if ([userDefaultManager getUserProfileData].uid == self.uid)
        {
            viewController.hidesBottomBarWhenPushed = true;
        }
        else
        {
            viewController.hidesBottomBarWhenPushed = false;
        }
        
        [self.navigationController pushViewController:viewController animated:true];
    }
}
- (IBAction)touchTopBanner:(id)sender
{
    [self touchAll];
}

- (void) touchAll
{
    if ([userDefaultManager isAnonymous])
    {
        [AppHelper showAnonymousLoginPopUpView];
    }
    else
    {
        PicturesRaceViewController *view = [[PicturesRaceViewController alloc] initWithNibName:@"PicturesRaceViewController" bundle:nil];
        view.key = _key;
        view.uid = _uid;
        view.status = _status;
        view.raceName = _raceName.text;
        
        if (_uid == [userDefaultManager getUserProfileData].uid)
        {
            view.hidesBottomBarWhenPushed = TRUE;
        }
        
        [_navigationController pushViewController:view animated:YES];
    }
}

- (IBAction)touchViewAll:(id)sender
{
    [self touchAll];
}

@end
