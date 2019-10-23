//
//  hprofile.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "hprofile.h"
#import "APIDefine.h"

@implementation hprofile
@synthesize URL;

-(id)init
{
    self = [super init];
    if(self)
    {
        URL = [APIDefine hProfileLink];
    }
    
    return self;
}

-(id)initWithUserId:(NSString*) photoID andSize:(NSString*)size andFileType:(NSString*) type
{
    self = [self init];
    
    if(self)
    {
        URL= [[[[[URL stringByAppendingString:photoID] stringByAppendingString:@"-"] stringByAppendingString:size] stringByAppendingString:@"."]stringByAppendingString:type];
    }
    
    return self;
}

-(void)setParamUserId:(NSString*) photoID andSize:(NSString*)size andFileType:(NSString*) type
{
    URL= [[[[[URL stringByAppendingString:photoID] stringByAppendingString:@"-"] stringByAppendingString:size] stringByAppendingString:@"."]stringByAppendingString:type];
}

-(void)connect
{
    dispatch_queue_t imageQueue = dispatch_queue_create("imageDownloader", nil);
    
    dispatch_async(imageQueue, ^{
        
        NSURL *imageURL = [NSURL URLWithString:URL];
        
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        UIImage *imageInView = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.myDelegate getUIImage_hprofile:imageInView];
            
        });
        
    });
}

@end
