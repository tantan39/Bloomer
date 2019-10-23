//
//  DiscoveryTableViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "DiscoveryTableViewCell.h"

@implementation DiscoveryTableViewCell {
    UserDefaultManager *userDefaultManager;
    
//    ThankYou* thankyouView;
//    BOOL showingThankyou;
    DiscoveryViewController* parent;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    userDefaultManager = [[UserDefaultManager alloc] init];
    _postList = [[NSMutableArray alloc] init];
    _draggableLocation = [[NSMutableArray alloc] init];
    _postID = [[NSMutableArray alloc] init];
    
    _avatar.clipsToBounds = TRUE;
    _avatar.layer.cornerRadius = _avatar.frame.size.width / 2;
    _avatar.layer.borderWidth = 2;
    _avatar.layer.borderColor = [UIColor colorWithRed:0.725 green:0.725 blue:0.725 alpha:1.0].CGColor;
    _iconView.layer.cornerRadius = _iconView.frame.size.width / 2;
    _iconView.layer.borderWidth = 1;
    _iconView.layer.borderColor = [UIColor colorWithRed:0.725 green:0.725 blue:0.725 alpha:1.0].CGColor;
    _done = FALSE;
//    showingThankyou = NO;
    
}
- (void)prepareForReuse {
    [super prepareForReuse];
    // Reset contentView
    _avatar.image = nil;
    [self refreshSlideshow];
//    if (!showingThankyou) {
//        [self hideThankYou];
//    }
//    showingThankyou = NO;
}

- (IBAction)touchAvatar:(id)sender {
    UserProfileViewController *view;
    view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    view.uid = _userID;
    
    [_navigationController pushViewController:view animated:YES];
}

- (void)loadPosts {
    API_PostUserFetches *api = [[API_PostUserFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                   device_token:[userDefaultManager getDeviceToken]
                                                                         postID:@""
                                                                            uid:_userID];
    __weak typeof(self) weakSelf = self;
    [api getRequest:^(BaseJSON *json, RestfulResponse *response) {
        if (weakSelf) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (response.status) {
                JSON_PostUserFetches *model = (JSON_PostUserFetches *)json;
                strongSelf.postList = model.postUserList;
                parent = (DiscoveryViewController *)strongSelf.parentView;
                [parent.postsPerUserID setObject:strongSelf.postList forKey:@(strongSelf.userID).stringValue];
                [self initSlideShow];
            } else {
                parent = (DiscoveryViewController *)strongSelf.parentView;
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:response.message
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil]];
                [parent presentViewController:alert animated:true completion:nil];
            }
        }
        
    } ErrorHandlure:^(NSError *err) {
        NSLog(@"API_PostUserFetches failed");
    }];
}

- (void)refreshSlideshow {
    for (UIView* subview in [_slideShow subviews]) {
        [subview removeFromSuperview];
    }
}

- (void)initSlideShow {
    [parent removeAllowedDropLocationsInList:_draggableLocation];
    [_draggableLocation removeAllObjects];
    [_postID removeAllObjects];
    
    
    for (int i = 0; i < _postList.count; i++)
    {
        PostUserObj *temp = (PostUserObj *)[_postList objectAtIndex:i];
        UIView* cellView = [[UIView alloc]initWithFrame:CGRectMake(88 * i, 0, 84, _slideShow.frame.size.height)];
        UITapGestureRecognizer *pictureViewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImageCell:)];
        cellView.tag = i;
        [cellView addGestureRecognizer:pictureViewTapRecognizer];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 84, _slideShow.frame.size.height)];
        [image setBackgroundColor:[UIColor lightGrayColor]];
        [image setImageWithURL:[NSURL URLWithString:temp.photo_url]];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = TRUE;
        
        SEDraggableLocation *location = [[SEDraggableLocation alloc] initWithFrame:cellView.frame];
        location.thankyouStyle = ThankYouStyleForCollectionViewCell;
        location.highlightColor = (__bridge CGColorRef)([UIColor redColor]);
        [cellView addSubview:image];
        
        [_slideShow addSubview:location];
        [_slideShow addSubview:cellView];
        
//        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(88 * i, 0, 84, _slideShow.frame.size.height)];
//        [image setImageWithURL:[NSURL URLWithString:temp.photo_url]];
//        image.contentMode = UIViewContentModeScaleAspectFill;
//        image.clipsToBounds = TRUE;
//        
//        SEDraggableLocation *location = [[SEDraggableLocation alloc] initWithFrame:image.frame];
//        location.thankyouStyle = ThankYouStyleForCollectionViewCell;
//        location.highlightColor = (__bridge CGColorRef)([UIColor redColor]);
//        [_slideShow addSubview:image];
//        [_slideShow addSubview:location];

        location.index = _draggableLocationTop.index;
        [_draggableLocation addObject:location];
        [_postID addObject:temp.post_id];
        
        _slideShow.contentSize = CGSizeMake(_postList.count * 88, _slideShow.frame.size.height);
    }
    
    if (_postList.count <= 3) {
        _slideShow.scrollEnabled = FALSE;
    } else {
        _slideShow.scrollEnabled = TRUE;
    }
    
//    if (!_done) {
//        //NSLog(@"InitDone");
//        [parent.tableView reloadData];
//        
//    }
    _done = TRUE;
    [parent addAllowedDropLocationsInList:_draggableLocation];
}

- (void)touchImageCell:(UITapGestureRecognizer *)tapRecognizer {
    PostUserObj *temp = (PostUserObj *)[_postList objectAtIndex:tapRecognizer.view.tag];
    FullPictureViewController *view = [[FullPictureViewController alloc] initWithNibName:@"FullPictureViewController" bundle:nil];
    
    gallery* gallerypost = [[gallery alloc]init];
    gallerypost.post_id = temp.post_id;
    gallerypost.photo_url = temp.photo_url;
    
    view.post_id = temp.post_id;
    view.isScrollingEnabled = FALSE;
    view.galleryData = [[NSMutableArray alloc]initWithObjects:gallerypost, nil];
    view.currentIndex = 0;
    
    [_navigationController pushViewController:view animated:TRUE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
