//
//  FilterCustomView.h
//  Bloomer
//
//  Created by Tan Tan on 7/25/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
#import "Support.h"
@protocol FilterCustomViewDelegate <NSObject>
- (void) filterMenuDidSelectedAtIndex:(NSInteger) index;
@end

@interface FilterMenuCell: UITableViewCell

@property (weak,nonatomic) IBOutlet UIView * separatorLine;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgvCheck;

@end

@interface FilterCustomView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) UITableView * filterMenu;
@property (strong,nonatomic) NSArray * dataSources;
@property (weak,nonatomic) id<FilterCustomViewDelegate> delegate;
@property (assign,nonatomic) NSInteger index;
@property (assign,nonatomic) BOOL isShow;

+ (instancetype) showInView:(id) parentView Index:(NSInteger) index;

- (void) handleDismiss;

@end


@interface FilterMenuItem:NSObject

@property (strong,nonatomic) NSString * title;
@property (assign,nonatomic) BOOL isSelected;

- (instancetype)initWithTitle:(NSString *) title isSelected:(BOOL) selected;
@end
