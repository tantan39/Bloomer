//
//  PageContentViewController.h
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 10/19/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PageContentViewController : UIViewController
@property  NSString *imgFile;
@property  NSString *txtTitle;
@property  NSUInteger pageIndex;
@property (weak, nonatomic) IBOutlet UIImageView *ivScreenImage;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenLabel;

- (void) setUp: (NSString*) nameImage title: (NSString*)title;
@end

NS_ASSUME_NONNULL_END
