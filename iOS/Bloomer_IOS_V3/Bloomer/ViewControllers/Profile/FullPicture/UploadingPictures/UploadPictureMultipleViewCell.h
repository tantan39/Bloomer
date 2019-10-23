//
//  UploadPictureMultipleViewCell.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 2/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "UploadingPicturesTableViewController.h"

@interface UploadPictureMultipleViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UITextView *editorField;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *CaptionTitle;
@property (weak, nonatomic) IBOutlet UIButton *RemoveButton;
- (IBAction)RemoveClick:(id)sender;
@property (assign, nonatomic) NSInteger index;
@property (weak,nonatomic) UIViewController * myParentView;

@end
