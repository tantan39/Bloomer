//
//  ConfirmationPopupViewController.h
//  Bloomer
//
//  Created by VanLuu on 7/13/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfirmationPopupDelegate <NSObject>

-(void)didConfirmationPopupOK:(NSInteger) locID;

@end

@interface ConfirmationPopupViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;
@property (weak, nonatomic) NSString *raceName;
@property (assign, nonatomic) NSInteger locationID;

@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) id<ConfirmationPopupDelegate> delegate;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@end
