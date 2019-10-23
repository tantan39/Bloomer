//
//  AwesomeMenuItem.h
//  AwesomeMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 Levey & Other Contributors. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AwesomeMenuItemDelegate;

@interface AwesomeMenuItem : UIImageView
{
    UILabel *_content;
    CGPoint _startPoint;
    CGPoint _endPoint;
    CGPoint _nearPoint; // near
    CGPoint _farPoint; // far
    
    id<AwesomeMenuItemDelegate> __weak _delegate;
}

@property (nonatomic, strong, readonly) UILabel *content;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) CGPoint nearPoint;
@property (nonatomic) CGPoint farPoint;

@property (nonatomic, weak) id<AwesomeMenuItemDelegate> delegate;

- (id)initWithImage:(UIImage *)img
   highlightedImage:(UIImage *)himg
               text:(NSString *)text;

@end

@protocol AwesomeMenuItemDelegate <NSObject>
- (void)AwesomeMenuItemTouchesBegan:(AwesomeMenuItem *)item;
- (void)AwesomeMenuItemTouchesEnd:(AwesomeMenuItem *)item;
@end