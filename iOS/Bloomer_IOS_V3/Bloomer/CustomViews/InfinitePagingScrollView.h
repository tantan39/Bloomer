//
//  InfinitePagingScrollView.h
//  InfinitePagingScrollView
//
//  Created by Shardul Prabhu on 18/11/12.
//  Copyright (c) 2012 Shardul Prabhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfinitePagingScrollViewDelegate;

@interface InfinitePagingScrollView : UIScrollView

@property (nonatomic,assign) id<InfinitePagingScrollViewDelegate> delegateForViews;
- (void)setDelegateForViews:(id<InfinitePagingScrollViewDelegate>)aDelegateForViews pageCurrent:(NSUInteger) page;
- (NSUInteger) getCurrentPage;
@end

@protocol InfinitePagingScrollViewDelegate

- (UIView*)setupView:(UIView*)reusedView forPosition:(NSUInteger) position;
- (NSUInteger) noOfViews;
- (void)clearView:(UIView*)reusableView;

@end
