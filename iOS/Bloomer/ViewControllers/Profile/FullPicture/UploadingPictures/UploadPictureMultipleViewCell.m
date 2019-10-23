//
//  UploadPictureMultipleViewCell.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 2/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "UploadPictureMultipleViewCell.h"

@implementation UploadPictureMultipleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _RemoveButton.layer.borderColor = UIColorFromRGB(0xea1615).CGColor;
    _RemoveButton.layer.borderWidth = 2.0;
    _RemoveButton.layer.cornerRadius = 12;
    _CaptionTitle.text = NSLocalizedString(@"UploadPictureMultipleCellAddCaptions.title", );
    _lblPlaceholder.text = NSLocalizedString(@"UploadPictureMultipleCellAddThinking.title", );
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)RemoveClick:(id)sender {
    
    [(UploadingPicturesTableViewController*)_myParentView removingIndex:_index];
}
@end
