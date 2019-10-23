//
//  InfinitePagingScrollView.m
//  InfinitePagingScrollView
//
//  Created by Shardul Prabhu on 18/11/12.
//  Copyright (c) 2012 Shardul Prabhu. All rights reserved.
//

#import "InfinitePagingScrollView.h"

@protocol InfinitePagingScrollViewDelegate;

static const NSUInteger numOfReusableViews = 3;

@interface InfinitePagingScrollView(){
    
    NSMutableArray  *visibleViews;
    UIView          *containerView;
    NSUInteger      currentPosition;
}

@end

@implementation InfinitePagingScrollView

@synthesize delegateForViews=_delegateForViews;

- (id)initWithCoder:(NSCoder *)aDecoder{
    if((self= [super initWithCoder:aDecoder])){
        
        visibleViews=[[NSMutableArray alloc] init];
        
        containerView = [[UIView alloc] init];
        
        [self addSubview:containerView];
        
        [self setShowsHorizontalScrollIndicator:NO];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if(self.delegateForViews){
        
        CGPoint contentOffset = self.contentOffset;
        
        if([self.delegateForViews noOfViews]>numOfReusableViews){
            NSUInteger centerIndex=visibleViews.count/2;
            NSUInteger noOfViews=[self.delegateForViews noOfViews];
            UIView *centerView=[visibleViews objectAtIndex:centerIndex];
            
            CGPoint centerViewOrigin=centerView.frame.origin;
            CGSize centerViewSize=centerView.frame.size;
            CGFloat offsetDifference=contentOffset.x-centerViewOrigin.x;
            CGFloat offsetDifferenceAbs=fabs(contentOffset.x-centerViewOrigin.x);
            
            if(offsetDifferenceAbs>=centerViewSize.width){
                
                if(offsetDifference<0){
                    currentPosition--;
                }else{
                    currentPosition++;
                }
                
                self.contentOffset=centerViewOrigin;
                
                currentPosition=[self getPosition:currentPosition noOfViews:noOfViews];
                
                [self.delegateForViews clearView:centerView];
                [self.delegateForViews setupView:centerView forPosition:currentPosition];
                
                for (int i=centerIndex-1; i>=0; i--) {
                    UIView* prevView=[visibleViews objectAtIndex:i];
                    [self.delegateForViews clearView:prevView];
                    [self.delegateForViews setupView:prevView forPosition:[self getPosition:currentPosition-1 noOfViews:noOfViews]];
                }
                
                for (int i=centerIndex+1; i<visibleViews.count; i++) {
                    UIView* nextView=[visibleViews objectAtIndex:i];
                    [self.delegateForViews clearView:nextView];
                    [self.delegateForViews setupView:nextView forPosition:[self getPosition:currentPosition+1 noOfViews:noOfViews]];
                }
                
            }
        }
        
    }
    
}

- (NSUInteger)getPosition:(NSUInteger) aPosition noOfViews:(NSUInteger) count{
    if(aPosition==-1){
        aPosition=count-1;
    }
    else if(aPosition==(count)){
        aPosition=0;
    }
    return aPosition;
}


- (void)setDelegateForViews:(id<InfinitePagingScrollViewDelegate>)aDelegateForViews pageCurrent:(NSUInteger) page{
    _delegateForViews=aDelegateForViews;
    [self invalidateViews:page];
}


- (void) invalidateViews: (NSUInteger) page{
    if(self.delegateForViews){
        currentPosition=page;
        NSUInteger noOfViews=MIN(numOfReusableViews, [self.delegateForViews noOfViews]);
        
        containerView.frame= CGRectMake(0, 0, self.frame.size.width*noOfViews, self.frame.size.height);
        self.contentSize=CGSizeMake(self.frame.size.width*noOfViews, self.frame.size.height);
        for (int i=0; i<noOfViews; i++) {
            UIView* view=[self.delegateForViews setupView:nil forPosition:i];
            CGRect frame=view.frame;
            view.frame=CGRectMake(frame.origin.x+(frame.size.width*i), frame.origin.y, frame.size.width, frame.size.height);
            [containerView addSubview:view];
            [visibleViews addObject:view];
        }
        
        
    }
}

- (NSUInteger) getCurrentPage {
    return currentPosition;
}

@end
