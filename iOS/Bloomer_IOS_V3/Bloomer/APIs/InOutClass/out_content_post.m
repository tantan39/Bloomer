//
//  content_post.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/15/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "out_content_post.h"

@implementation out_content_post

//-(void)extractData:(NSDictionary*) data
//{
//    NSDictionary *post = [data objectForKey:k_POST];
//
//    NSDictionary *commentDict = [post objectForKey:k_COMMENTS];
//
//    _size = [[commentDict objectForKey:k_SIZE] integerValue];
//
//    NSArray *listComment = [commentDict objectForKey:k_LIST];
//    _list = [[NSMutableArray alloc] init];
//
//    for (int i = 0; i < listComment.count; i++) {
//        NSDictionary *tem = [listComment objectAtIndex:i];
//        comment* new = [[comment alloc] initWithJSON:tem];
//        /*comments *new = [[comments alloc] initWithName:[tem objectForKey:k_NAME]
//                                                 avatar:[tem objectForKey:k_AVATAR]
//                                               username:[tem objectForKey:k_USERNAME]
//                                                content:[tem objectForKey:k_CONTENT]
//                                                    uid:[[tem objectForKey:k_UID] integerValue]
//                                             timestamp:[[tem objectForKey:k_TIMESTAMP] longLongValue]]; */
//        [_list addObject:new];
//    }
//
//    NSDictionary *profile = [post objectForKey:k_PROFILE];
//
//    _uid = [[profile objectForKey:k_UID] integerValue];
//    _is_share = [[profile objectForKey:k_IS_SHARE] boolValue];
//
//    _name = [profile objectForKey:k_NAME];
////    NSData *nameData = [[profile objectForKey:k_NAME] dataUsingEncoding:NSUTF8StringEncoding];
////    _name = [[NSString alloc] initWithData:nameData encoding:NSNonLossyASCIIStringEncoding];
//
//    _avatar = [profile objectForKey:k_AVATAR];
//    _username = [profile objectForKey:k_USERNAME];
//    _is_follow = [[profile objectForKey:k_IS_FOLLOW] boolValue];
//
//    NSDictionary *content = [post objectForKey:k_CONTENT];
//
//    _post_id = [content objectForKey:k_POST_ID];
//    _is_avatar = [[content objectForKey:k_IS_AVATAR] boolValue];
//    _caption = [content objectForKey:k_CAPTION];
//    _caption = [_caption stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    _timestamp = [[content objectForKey:k_TIMESTAMP] longLongValue];
//    _flower = [[content objectForKey:k_FLOWER] longLongValue];
//    _photo_url = [content objectForKey:k_PHOTO_URL];
//    self.mygiveflower = [[content objectForKey:k_MYGIVEFLOWER] longLongValue];
//
//    _tags =[[NSMutableArray alloc]init];
//    NSMutableArray* tagList = [content objectForKey:k_TAGS];
//    for (NSDictionary* tagObject in tagList) {
//        [_tags addObject:[tagObject objectForKey:k_NAME]];
//    }
//
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSDictionary *post = [json objectForKey:k_POST];
        
        NSDictionary *commentDict = [post objectForKey:k_COMMENTS];
        
        _size = [[commentDict objectForKey:k_SIZE] integerValue];
        
        NSArray *listComment = [commentDict objectForKey:k_LIST];
        _list = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < listComment.count; i++) {
            NSDictionary *tem = [listComment objectAtIndex:i];
            comment* new = [[comment alloc] initWithJSON:tem];
            /*comments *new = [[comments alloc] initWithName:[tem objectForKey:k_NAME]
             avatar:[tem objectForKey:k_AVATAR]
             username:[tem objectForKey:k_USERNAME]
             content:[tem objectForKey:k_CONTENT]
             uid:[[tem objectForKey:k_UID] integerValue]
             timestamp:[[tem objectForKey:k_TIMESTAMP] longLongValue]]; */
            [_list addObject:new];
        }
        
        NSDictionary *profile = [post objectForKey:k_PROFILE];
        
        _uid = [[profile objectForKey:k_UID] integerValue];
        _is_share = [[profile objectForKey:k_IS_SHARE] boolValue];
        
        _name = [profile objectForKey:k_NAME];
        //    NSData *nameData = [[profile objectForKey:k_NAME] dataUsingEncoding:NSUTF8StringEncoding];
        //    _name = [[NSString alloc] initWithData:nameData encoding:NSNonLossyASCIIStringEncoding];
        
        _avatar = [profile objectForKey:k_AVATAR];
        _username = [profile objectForKey:k_USERNAME];
        _is_follow = [[profile objectForKey:k_IS_FOLLOW] boolValue];
        
        NSDictionary *content = [post objectForKey:k_CONTENT];
        
        _post_id = [content objectForKey:k_POST_ID];
        _is_avatar = [[content objectForKey:k_IS_AVATAR] boolValue];
        _caption = [content objectForKey:k_CAPTION];
        _caption = [_caption stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _timestamp = [[content objectForKey:k_TIMESTAMP] longLongValue];
        _flower = [[content objectForKey:k_FLOWER] longLongValue];
        _photo_url = [content objectForKey:k_PHOTO_URL];
        _photo_url_full = [content objectForKey:k_PHOTO_URL_FULL];
        self.mygiveflower = [[content objectForKey:k_MYGIVEFLOWER] longLongValue];
        
        _tags =[[NSMutableArray alloc]init];
        NSMutableArray* tagList = [content objectForKey:k_TAGS];
        for (NSDictionary* tagObject in tagList) {
            [_tags addObject:[tagObject objectForKey:k_NAME]];
        }
    }
    return self;
}

- (instancetype)initWithFeedJSON:(NSDictionary *)feedJSON{
    self = [super init];
    if (self) {
        
        _post_id = [feedJSON objectForKey:k_POST_ID];
        _caption = [feedJSON objectForKey:k_CAPTION];
        _caption = [_caption stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _timestamp = [[feedJSON objectForKey:k_TIMESTAMP] longLongValue];
        _flower = [[feedJSON objectForKey:k_FLOWER] longLongValue];
        _photo_url = [feedJSON objectForKey:k_PHOTO_URL];
        _photo_url_full = [feedJSON objectForKey:k_PHOTO_URL_FULL];
        self.mygiveflower = [[feedJSON objectForKey:k_MYGIVEFLOWER] longLongValue];
        
        _tags =[[NSMutableArray alloc]init];
        NSMutableArray* tagList = [feedJSON objectForKey:k_TAGS];
        for (NSDictionary* tagObject in tagList) {
            [_tags addObject:[tagObject objectForKey:k_NAME]];
        }
    }
    return self;
}

@end
