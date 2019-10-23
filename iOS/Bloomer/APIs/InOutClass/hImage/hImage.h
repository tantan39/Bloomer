//
//  hImage.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol himageDelegate <NSObject>

-(void)getUIImage_hImage:(UIImage *)data;

@end

@interface hImage : NSObject

@property (weak, nonatomic) id<himageDelegate> myDelegate;
@property (strong, nonatomic) NSString* URL;

-(id)init;
-(id)initWithUserId:(NSString*) userID andSize:(NSString*)size;
-(void)setParamUserId:(NSString*) userID andSize:(NSString*)size;
-(void)connect;

@end
