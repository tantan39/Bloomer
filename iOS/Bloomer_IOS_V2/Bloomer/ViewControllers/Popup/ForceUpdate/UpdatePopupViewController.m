//
//  UpdatePopupViewController.m
//  Bloomer
//
//  Created by Le Chau Tu on 3/25/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "UpdatePopupViewController.h"

@interface UpdatePopupViewController ()

@end

@implementation UpdatePopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Set round edges for button Cancel
    self.buttonUpdate.layer.cornerRadius = self.buttonUpdate.frame.size.height / 2;
    self.buttonUpdate.clipsToBounds = true;

    
    //Set round corner for frame
    self.popupFrame.layer.cornerRadius = 20;
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonUpdate:(id)sender {
    NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/vn/app/apple-store/id1116920501?mt=8"];
    [[UIApplication sharedApplication] openURL:url];
}

@end
