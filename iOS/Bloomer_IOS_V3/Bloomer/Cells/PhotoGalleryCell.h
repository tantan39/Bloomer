//
//  PhotoGalleryCell.h
//  Bloomer
//
//  Created by Steven on 6/4/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoGalleryCell : UITableViewCell

+ (CGFloat)cellHeight;
+ (NSString*)nibName;
+ (NSString*)cellIdentifier;

@property (weak, nonatomic) IBOutlet UIImageView *albumThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *labelAlbumName;
@property (weak, nonatomic) IBOutlet UILabel *labelAlbumPhotoNumber;
@end
