//
//  NewsFeedSearchCustomView.m
//  Bloomer
//
//  Created by Tan Tan on 1/3/19.
//  Copyright © 2019 Glassegg. All rights reserved.
//

#import "NewsFeedSearchCustomView.h"

@implementation NewsFeedSearchCustomView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self customInit];
    
    
}

- (void) customInit{
    [[NSBundle mainBundle] loadNibNamed:@"NewsFeedSearchCustomView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:[SearchNewFeedTableViewCell nibName] bundle:nil]  forCellReuseIdentifier:[SearchNewFeedTableViewCell cellIdentifier]];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SearchNewFeedTableViewCell cellHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchNewFeedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[SearchNewFeedTableViewCell cellIdentifier] forIndexPath:indexPath];
    return cell;
}


@end
