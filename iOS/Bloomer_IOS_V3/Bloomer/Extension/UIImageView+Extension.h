//
//  UIImageView+Extension.h
//  Bloomer
//
//  Created by Tan Tan on 8/27/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface UIImageView (Extension)

- (void) setImageWithAnimationFromURL:(NSURL *) url placeHolder:(UIImage *) placeHolder;

- (void) setImageWithURL:(NSURL *) url ;
@end
