//
//  MenuProfilPopUpView.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 11/20/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "BloomerMenuPopUpView.h"
#define kHeightMenu 45

@implementation BloomerMenuPopUpView
{

}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.list = [[NSArray alloc] init];
    self.tableview.scrollEnabled = false;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.allowsSelection = TRUE;
}

+ (id) createInView:(UIView *)view data: (NSArray*)data selectIndex: (void(^)(NSInteger)) selectIndex {
    BloomerMenuPopUpView * menu = [[NSBundle mainBundle] loadNibNamed:@"BloomerMenuPopUpView" owner:view options:nil][0];
    menu.translatesAutoresizingMaskIntoConstraints = false;
    menu.ownerView = view;
    menu.selectIndex = selectIndex;
    menu.list = data;
    [menu setUpView];
    return menu;
}

- (void) setUpView {
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapClose:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    
//    UITapGestureRecognizer * gestureContent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchContent)];
//    [self.contentView addGestureRecognizer:gestureContent];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (touch.view != self){
        return NO;;
    }
    return YES;
}
- (void) touchContent {
    
}
- (void)showAnimate
{
    self.alpha = 0;
    self.heightContentConstraint.constant = kHeightMenu * self.list.count;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        [self.ownerView layoutIfNeeded];
    }];
}

- (void)handleTapClose:(UITapGestureRecognizer *)recognizer {
    [self handleDismiss];
}

-(void)show {
    self.heightContentConstraint.constant = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ownerView addSubview:self];
        [self.ownerView addConstraints:[self getConstraintsWithParent:self.ownerView top:0 bottom:0 left:0 right:0]];
        [self.ownerView layoutIfNeeded];
        [self showAnimate];
    });

}

-(void)handleDismiss {
    self.heightContentConstraint.constant = 0;
    [UIView animateWithDuration:.25 animations:^{
        [self.ownerView layoutIfNeeded];
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightMenu;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    UILabel *lb = [[UILabel alloc] initWithFrame: CGRectMake(25, 0, self.contentView.frame.size.width - 50, kHeightMenu)];
    lb.text = self.list[indexPath.row];
    [cell addSubview:lb];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self handleDismiss];
     self.selectIndex(indexPath.row);
}

@end
