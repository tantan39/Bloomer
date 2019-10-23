//
//  SearchLocationVC.m
//  Bloomer
//
//  Created by Tran Thai Tan on 6/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "SearchLocationVC.h"

@interface SearchLocationVC (){
    CGRect currentFrame;
    CGRect windFrame;
}

@end

static CGFloat rowHeight = 40;

@implementation SearchLocationVC

- (instancetype) initWithViewController:(id<UITableViewDataSource,UITableViewDelegate>) viewController{
    self = [super init];
    if (self) {
        self = [[SearchLocationVC alloc] initWithNibName:@"SearchLocationVC" bundle:nil];
        [self.tableView registerNib:[UINib nibWithNibName:@"SearchLocationResultCell" bundle:nil] forCellReuseIdentifier:@"SearchLocationResultCell"];
        self.tableView.dataSource = viewController;
        self.tableView.delegate = viewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    currentFrame = self.view.frame;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void) reloadDataWithDataSource:(NSArray *) dataSource{
    if (dataSource) {

        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        windFrame = [self.view convertRect:self.view.frame toView:window];
        CGFloat heightView = dataSource.count * rowHeight + windFrame.origin.y;
        [self.tableView reloadData];
        
        CGRect toFrame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y, currentFrame.size.width, heightView);
        if (SYSTEM_VERSION_LESS_THAN(@"10.0")){
            heightView = dataSource.count * rowHeight + self.view.frame.origin.y;
            toFrame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y + 20, currentFrame.size.width, heightView + rowHeight);
        }
        [UIView animateWithDuration:0.3 animations:^{
            [self.view setFrame:toFrame];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"%li",indexPath.row];
    
    return cell;
}




/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/


@end
