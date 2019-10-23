//
//  RaceAlertView.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/23/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaceAlertView : UIView
@property (strong, nonatomic) IBOutlet UIView *dialogView;
@property (strong, nonatomic) IBOutlet UIImageView *trophyImage;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UILabel *fullMessage;

-(instancetype)initWithMessage:(NSString*)message gsb:(NSInteger)gsb;
-(instancetype)initWithMessage:(NSString*)message;
-(void)show;

@end
