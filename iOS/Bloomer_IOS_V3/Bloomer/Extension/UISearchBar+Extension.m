//
//  UISearchBar+Extension.m
//  Bloomer
//
//  Created by Tran Thai Tan on 6/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "UISearchBar+Extension.h"
#import "UIColor+Extension.h"

@implementation UISearchBar (Extension)

- (void)customizeSearchbar
{
    UITextField *searchField = [self valueForKey:@"_searchField"];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.bounds.size.width, self.bounds.size.height + 20)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self insertSubview:bgView atIndex:1];

    if (searchField) {
        searchField.layer.borderWidth = 0.5;
        searchField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        searchField.layer.cornerRadius = 15;
        searchField.clipsToBounds = YES;
    }
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor lightGrayColor]];
}

- (void)setupSearchBar
{
    self.translucent = true;
    UITextField *searchField = [self valueForKey:@"_searchField"];
    
    searchField.textColor = [UIColor colorFromHexString:@"#202121"];
    [searchField setValue:[UIColor colorFromHexString:@"#BDBDBD"] forKeyPath:@"_placeholderLabel.textColor"];
    searchField.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:14];
}

- (void)customizeDefaultRoundSearchBar {
    [self setBackgroundColor:[UIColor rgb:235 green:235 blue:235]];
    [self setBackgroundImage:[UIImage new]];
    [self setTranslucent:true];
    UITextField *searchField = [self valueForKey:@"_searchField"];
    searchField.layer.masksToBounds = true;
    searchField.layer.cornerRadius = 15;
}

- (void)customizeWhiteThemeSearchBar {
    [self customizeDefaultRoundSearchBar];
    self.backgroundColor = UIColor.whiteColor;
    UITextField *searchTxt = [self valueForKey:@"_searchField"];
    searchTxt.layer.borderWidth = 1.0;
    searchTxt.layer.borderColor = [UIColor rgb:233 green:233 blue:233].CGColor;
}

- (void)customizeGrayThemeSearchBar {
    self.backgroundColor = UIColor.whiteColor;
    [self setBackgroundImage:[UIImage new]];
    [self setTranslucent:true];
    UITextField *searchField = [self valueForKey:@"_searchField"];
    searchField.layer.masksToBounds = true;
    searchField.layer.cornerRadius = 4;
    searchField.backgroundColor = [UIColor rgb:244 green:244 blue:244];
}

- (void)customizeCancelSearchBar {
    UIButton *cancelButton = [self valueForKey:@"_cancelButton"];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:14];
}
@end
