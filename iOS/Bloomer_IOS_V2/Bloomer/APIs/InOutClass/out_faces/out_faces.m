//
//  out_faces.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "out_faces.h"

@implementation out_faces

@synthesize faces;

//-(void)extractData:(NSDictionary*) data
//{
//    NSArray *output = [data objectForKey:k_FACES];
//    
//    faces = [[NSMutableArray alloc] init];
//    
//    NSInteger n = [output count];
//    
//    for(NSInteger i = 0 ; i< n ; i++)
//    {
//        NSDictionary *temp = [output objectAtIndex:i];
//        
//        face *newFace = [[face alloc]initWithTimeStamp:[[temp objectForKey:k_TIMESTAMP] integerValue] uri_photo:[temp objectForKey:k_PHOTO] name:[temp objectForKey:k_NAME] uid:[[temp objectForKey:k_UID] integerValue] num_flower:[[temp objectForKey:k_NUM_FLOWER] longLongValue] avatar:[temp objectForKey:k_AVATAR] post_id:[temp objectForKey:k_POST_ID] photo_id:[temp objectForKey:k_PHOTO_ID] content_post:[temp objectForKey:k_CONTENT_POST]];
//        
//        
//        [faces addObject:newFace];
//    }
//    
//    
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSArray *output = [json objectForKey:k_FACES];
        
        faces = [[NSMutableArray alloc] init];
        
        NSInteger n = [output count];
        
        for(NSInteger i = 0 ; i< n ; i++)
        {
            NSDictionary *temp = [output objectAtIndex:i];
            
            face *newFace = [[face alloc]initWithTimeStamp:[[temp objectForKey:k_TIMESTAMP] integerValue] uri_photo:[temp objectForKey:k_PHOTO] name:[temp objectForKey:k_NAME] uid:[[temp objectForKey:k_UID] integerValue] num_flower:[[temp objectForKey:k_NUM_FLOWER] longLongValue] avatar:[temp objectForKey:k_AVATAR] post_id:[temp objectForKey:k_POST_ID] photo_id:[temp objectForKey:k_PHOTO_ID] content_post:[temp objectForKey:k_CONTENT_POST]];
            
            
            [faces addObject:newFace];
        }
    }
    return self;
}

@end
