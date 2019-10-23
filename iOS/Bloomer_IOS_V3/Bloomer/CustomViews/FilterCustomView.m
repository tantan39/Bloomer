//
//  FilterCustomView.m
//  Bloomer
//
//  Created by Tan Tan on 7/25/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "FilterCustomView.h"

#define kHEIGHT_MENU 165

@implementation FilterMenuCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

@end

CGFloat yOffSet;
CGRect screenSize;
static NSString * cellID = @"FilterMenuCell";

@implementation FilterCustomView

+ (instancetype) showInView:(id) parentView Index:(NSInteger)index{
    screenSize = [[UIScreen mainScreen ] bounds];
    if (IS_IPHONE_X) {
        if (@available(iOS 11.0, *)) {
            UIWindow *window = UIApplication.sharedApplication.keyWindow;
            CGFloat bottomPadding = window.safeAreaInsets.bottom;
            yOffSet = screenSize.size.height - bottomPadding;
        }
    }else{
        yOffSet = screenSize.size.height;
    }
    
    FilterCustomView * view = [[FilterCustomView alloc] initWithFrame:CGRectMake(0, 0, screenSize.size.width,yOffSet) ];
    view.delegate = parentView;
    view.index = index;
    view.isShow = YES;
    [view setupView];
    
    return view;
}

- (void) setupView{
    
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDismiss)];
    [self addGestureRecognizer:gesture];
    
    [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    
    self.filterMenu = [[UITableView alloc] initWithFrame:CGRectMake(0, screenSize.size.height, screenSize.size.width, 0)];
    [self.filterMenu registerNib:[UINib nibWithNibName:@"FilterMenuCell" bundle:nil] forCellReuseIdentifier:cellID];
    
    self.dataSources = @[[[FilterMenuItem alloc] initWithTitle:NSLocalizedString(@"Female", nil) isSelected:NO],
                         [[FilterMenuItem alloc] initWithTitle:NSLocalizedString(@"Male", nil) isSelected:NO],
                         [[FilterMenuItem alloc] initWithTitle:NSLocalizedString(@"All", nil) isSelected:NO]];
    
    FilterMenuItem * item = [self.dataSources objectAtIndex:self.index];
    [item setIsSelected:YES];
    
    self.filterMenu.dataSource = self;
    self.filterMenu.delegate = self;
    [self.filterMenu setScrollEnabled:NO];
    self.filterMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.filterMenu];
    [self setAlpha:0];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self setAlpha:1];
        [self.filterMenu setFrame:CGRectMake(0, yOffSet - kHEIGHT_MENU, screenSize.size.width, kHEIGHT_MENU)];
        [self.filterMenu roundCornersWithCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) Radius:10.0];
        
    } completion:nil];

}

- (void) handleDismiss{
    if (self.isShow) {
        self.isShow = !self.isShow;
        CGRect screenSize = [[UIScreen mainScreen ] bounds];
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self setAlpha:0];
            [self.filterMenu setFrame:CGRectMake(0, yOffSet, screenSize.size.width, 0)];
        } completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT_MENU / self.dataSources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FilterMenuCell * cell = (FilterMenuCell *)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    FilterMenuItem * item = [self.dataSources objectAtIndex:indexPath.row];
    cell.lblTitle.text = item.title;
    if (item.isSelected) {
        [cell.lblTitle setTextColor:[UIColor rgb:178 green:34 blue:37]];
        [cell.imgvCheck setHidden:NO];
    }else{
        [cell.lblTitle setTextColor: [UIColor rgb:32 green:32 blue:33]];
        [cell.imgvCheck setHidden:YES];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self handleDismiss];
    if ([self.delegate respondsToSelector:@selector(filterMenuDidSelectedAtIndex:)]) {
        [self.delegate filterMenuDidSelectedAtIndex:indexPath.row];
    }
    
    [self.dataSources enumerateObjectsUsingBlock:^(FilterMenuItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = idx == indexPath.row ? YES : NO;
        NSIndexPath * index = [NSIndexPath indexPathForRow:idx inSection:0];
        [tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}

@end

@implementation FilterMenuItem

- (instancetype)initWithTitle:(NSString *)title isSelected:(BOOL)selected{
    self = [super init];
    if (self) {
        self.title = title;
        self.isSelected = selected;
    }
    return self;
}

@end
