//
//  hImage.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "hImage.h"
#import "APIDefine.h"

@implementation hImage
@synthesize URL;

-(id)init
{
    self = [super init];
    if(self)
    {
        URL = [APIDefine hImageLink];
    }
    
    return self;
}

-(id)initWithUserId:(NSString*) userID andSize:(NSString*)size
{
    self = [self init];
    
    if(self)
    {
        URL= [[[URL stringByAppendingString:userID] stringByAppendingString:@"/"] stringByAppendingString:size];
    }
    
    return self;
}

-(void)setParamUserId:(NSString*) userID andSize:(NSString*)size
{
    URL = [[[URL stringByAppendingString:userID] stringByAppendingString:@"/"] stringByAppendingString:size];
}

-(void)connect
{
    dispatch_queue_t imageQueue = dispatch_queue_create("imageDownloader", nil);
    
    dispatch_async(imageQueue, ^{
        
        NSURL *imageURL = [NSURL URLWithString:URL];
        
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        UIImage *imageInView = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.myDelegate getUIImage_hImage:imageInView];
            
        });
        
    });
}

@end
