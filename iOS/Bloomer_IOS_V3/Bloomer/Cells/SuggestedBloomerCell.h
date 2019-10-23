//
//  SuggestedBloomerCell.h
//  Bloomer
//
//  Created by Steven on 12/15/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuggestedPersonView.h"
#import "API_SuggestedList.h"

@interface SuggestedBloomerCell : UITableViewCell

// MARK: - Static variables
+ (CGFloat) cellHeight;
+ (NSString*) cellIdentifier;
+ (NSString*) nibName;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *labelSuggestedBloomerTitle;

@property (assign, nonatomic) BOOL isLoaded;
@property (weak, nonatomic) UINavigationController *navigationController;

- (void)loadSuggestedList;

@end
