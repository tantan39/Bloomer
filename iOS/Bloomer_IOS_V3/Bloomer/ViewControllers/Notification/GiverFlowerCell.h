//
//  GiverFlowerCell.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/18/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "UIColor+Extension.h"

@interface GiverFlowerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *gaveFlower;

@property (weak, nonatomic) UINavigationController *navigationController;

-(void) setDataForCell:(NSString*)thisAvatar userName:(NSString*) nameUser nameId:(NSString*)idName floweGiver:(NSInteger) numberFlower;

@end
