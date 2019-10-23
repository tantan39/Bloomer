//
//  TTTextField.m
//  MessageView
//
//  Created by Tan Tan on 12/2/17.
//  Copyright © 2017 Tan Tan. All rights reserved.
//

#import "TTTextField.h"

#define HEIGHT_ROW 35

@interface TTTextField(){
    UIColor * textColor;
    UIColor * backgroundColor;
}
@property (strong, nonatomic) UITableView * tbvMain;
@property (strong,nonatomic) UIView * containerView;
@property (strong,nonatomic) NSMutableArray * dataSource;
@property (strong,nonatomic) UIView *parentView;
@property (strong, nonatomic) CALayer *underline;
@end
@implementation TTTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setBorderStyle:UITextBorderStyleNone];
        [self setUnderline];
        [self addTarget:self action:@selector(handleEventEdittingBegin) forControlEvents:UIControlEventTouchDown];

    }
    return self;
}

- (void) handleEventEdittingBegin{
    [self.containerView setHidden:NO];
    [self.tbvMain setHidden:NO];
    self.isShow = YES;
}

- (void) handleEventEdittingEnd{
    [self.containerView setHidden:YES];
    [self.tbvMain setHidden:YES];
    self.isShow = NO;
}

- (void) setUnderline{
    self.underline = [CALayer layer];
    CGFloat borderWidth = 1;
    self.underline.borderColor = [UIColor colorFromHexString:@"#EDEDED"].CGColor;
    self.underline.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, self.frame.size.height);
    self.underline.borderWidth = borderWidth;
    [self.layer addSublayer:self.underline];
    self.layer.masksToBounds = YES;
}

- (void)setUnderlineColor:(UIColor *)color{
    if (color) {
        self.underline.borderColor = color.CGColor;
    }
}

- (void) initContainerWithView:(UIView *) view{
    backgroundColor = [UIColor colorFromHexString:@"#F5F5F5"];
    textColor = [UIColor colorFromHexString:@"#333333"];
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y, view.bounds.size.width, self.bounds.size.height + (self.dataSource.count * HEIGHT_ROW))];
    [self.containerView setBackgroundColor:backgroundColor];
    [self.containerView setHidden:YES];
    [view insertSubview:self.containerView belowSubview:self];

}

- (void) initTableviewInView:(UIView *) view{
    if (view) {
        self.tbvMain = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + self.bounds.size.height, view.bounds.size.width, self.dataSource.count * HEIGHT_ROW)];
        [self.tbvMain setScrollEnabled:NO];
        [self.tbvMain setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [view addSubview:self.tbvMain];
    }
}

- (void)setDatasource:(NSArray *)array inView:(UIView *)view{
    if (array) {
        self.dataSource = [[NSMutableArray alloc] initWithArray:array];
        [self initTableviewInView:view];
        [self initContainerWithView:view];
        self.tbvMain.dataSource = self;
        self.tbvMain.delegate = self;
        [self.tbvMain reloadData];
        [self.tbvMain setHidden:YES];
    }
}

#pragma mark - Tableview DataSource/ Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_ROW;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:@"SFProText" size:18]];
    [cell.textLabel setTextColor:textColor];
    [cell setBackgroundColor:backgroundColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(textFieldSelectedIndex:textfield:)]) {
        [self.delegate textFieldSelectedIndex:indexPath.row textfield:self];
    }
    NSString * value = [self.dataSource objectAtIndex:indexPath.row];
    [self setText:value];
    [self handleEventEdittingEnd];
}


@end
