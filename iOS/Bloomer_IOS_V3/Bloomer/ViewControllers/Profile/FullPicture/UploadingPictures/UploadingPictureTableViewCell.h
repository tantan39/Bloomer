//
//  UploadingPictureTableViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 10/23/15.
//  Copyright © 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadingPicturesTableViewController.h"

@interface UploadingPictureTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UITextView *editorField;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceholder;

@end
