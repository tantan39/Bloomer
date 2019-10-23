//
//  PhotosTaggedCollectionViewCell.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/22/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "PhotosTaggedCollectionViewCell.h"

@implementation PhotosTaggedCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _photo.contentMode = UIViewContentModeScaleAspectFill;
    _photo.clipsToBounds = TRUE;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    _thankyouView = [[ThankYou alloc]initWithStyle:ThankYouStyleForCollectionViewCell atPoint:CGPointZero frame:CGRectMake(0, 0, screenSize.width / 2 - 2.5, screenSize.width / 2 - 2.5)];
    self.thankyouView.hidden = true;
    [self addSubview:_thankyouView];
}

-(void)showThankYou:(BOOL)isShow
{
    self.thankyouView.hidden = !isShow;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // Reset contentView
    _post_id = @"";
    _photo.image = nil;
    self.thankyouView.hidden = true;
}

- (void)TouchPictureView {
    FullPictureViewController *view;
    view = [[FullPictureViewController alloc] initWithNibName:@"FullPictureViewController" bundle:nil];
    
    view.isScrollingEnabled = FALSE;
    view.post_id = _post_id;
    
    [_navigationController pushViewController:view animated:TRUE];
}

- (IBAction)touchPhoto:(id)sender {
    FullPictureViewController *view;
    view = [[FullPictureViewController alloc] initWithNibName:@"FullPictureViewController" bundle:nil];

    view.isScrollingEnabled = FALSE;
    [_navigationController pushViewController:view animated:TRUE];
}
@end
