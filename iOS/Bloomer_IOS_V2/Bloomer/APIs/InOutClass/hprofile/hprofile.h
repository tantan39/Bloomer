//
//  hprofile.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol hprofileDelegate <NSObject>

-(void)getUIImage_hprofile:(UIImage *)data;

@end

@interface hprofile : NSObject
@property (weak, nonatomic) id<hprofileDelegate> myDelegate;
@property (strong, nonatomic) NSString* URL;

-(id)init;
-(id)initWithUserId:(NSString*) photoID andSize:(NSString*)size andFileType:(NSString*) type;
-(void)setParamUserId:(NSString*) photoID andSize:(NSString*)size andFileType:(NSString*) type;
-(void)connect;

@end
