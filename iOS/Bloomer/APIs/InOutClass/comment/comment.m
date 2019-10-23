//
//  comment.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "comment.h"

@implementation comment

//- (void)extractData:(NSDictionary*) data
//{
//    NSDictionary *profile = data;
//    NSDictionary *comment = data;
//    if([data objectForKey:k_PROFILE])
//        profile = [data objectForKey:k_PROFILE];
//    if([data objectForKey:k_COMMENT])
//        comment = [data objectForKey:k_COMMENT];
////    NSDictionary *profile = [data objectForKey:k_PROFILE];
////    NSDictionary *comment = [data objectForKey:k_COMMENT];
//
//    _uid = [[profile objectForKey:k_UID] integerValue];
//
//    _name = [profile objectForKey:k_NAME];
//    // encode for EMOJI character
////    NSData *nameData = [[profile objectForKey:k_NAME] dataUsingEncoding:NSUTF8StringEncoding];
////    _name = [[NSString alloc] initWithData:nameData encoding:NSNonLossyASCIIStringEncoding];
//
//    _avatar = [profile objectForKey:k_AVATAR];
//    _username = [profile objectForKey:k_USERNAME];
//
//    _comment_id = [comment objectForKey:k_COMMENT_ID];
//    _content = [comment objectForKey:k_CONTENT];
//    _timestamp = [[comment objectForKey:k_TIMESTAMP] longLongValue];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSDictionary *profile = json;
        NSDictionary *comment = json;
        if([json objectForKey:k_PROFILE])
            profile = [json objectForKey:k_PROFILE];
        if([json objectForKey:k_COMMENT])
            comment = [json objectForKey:k_COMMENT];
        //    NSDictionary *profile = [data objectForKey:k_PROFILE];
        //    NSDictionary *comment = [data objectForKey:k_COMMENT];
        
        _uid = [[profile objectForKey:k_UID] integerValue];
        
        _name = [profile objectForKey:k_NAME];
        // encode for EMOJI character
        //    NSData *nameData = [[profile objectForKey:k_NAME] dataUsingEncoding:NSUTF8StringEncoding];
        //    _name = [[NSString alloc] initWithData:nameData encoding:NSNonLossyASCIIStringEncoding];
        
        _avatar = [profile objectForKey:k_AVATAR];
        _username = [profile objectForKey:k_USERNAME];
        
        _comment_id = [comment objectForKey:k_COMMENT_ID];
        _content = [comment objectForKey:k_CONTENT];
        _timestamp = [[comment objectForKey:k_TIMESTAMP] longLongValue];
    }
    return self;
}

@end
