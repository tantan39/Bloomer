//
//  GiverFlowerCell.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/18/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "GiverFlowerCell.h"

@implementation GiverFlowerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _avatar.layer.cornerRadius = _avatar.frame.size.height / 2;
    _avatar.layer.borderWidth = 2;
    _avatar.layer.borderColor = [UIColor colorFromHexString:@"#0xdcdcdc"].CGColor;
    _avatar.clipsToBounds = TRUE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setDataForCell:(NSString*)thisAvatar userName:(NSString*) nameUser nameId:(NSString*)idName floweGiver:(NSInteger) numberFlower
{
    [_avatar setImageWithURL:[NSURL URLWithString:thisAvatar]];
    _userName.text = nameUser;
    _userId.text = idName;
    _gaveFlower.text = [NSString stringWithFormat: NSLocalizedString(@"FlowerGiver.numberOfFlower", ), (long)numberFlower];
}

@end
