//
//  UIImageView+Extension.m
//  Bloomer
//
//  Created by Tan Tan on 8/27/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

- (void)setImageWithAnimationFromURL:(NSURL *)url placeHolder:(UIImage *)placeHolder{
    
    __weak typeof(self) weakImageView = self;
    
    [self sd_setImageWithURL:url placeholderImage:placeHolder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView transitionWithView:weakImageView
                          duration:.2
                           options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                               weakImageView.image = image;
                           }
                        completion:nil];
    }];
}

- (void)setImageWithURL:(NSURL *)url{
    [self sd_setImageWithURL:url];
}

@end
