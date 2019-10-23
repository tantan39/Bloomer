//
//  banners_add.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "banners_add.h"

@implementation banners_add

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token posts:(NSMutableArray *)posts croppedRects:(NSMutableArray *)croppedRects {
    self = [super init];
    
    if (self) {
        _access_token = access_token;
        _device_token = device_token;
        _posts = posts;
        self.croppedRects = croppedRects;
    }
    
    return self;
}


- (NSDictionary *)encodeToJSON{
    NSDictionary *auth = [NSDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token,k_DEVICE_TOKEN, nil];
    NSMutableDictionary *upload = [[NSMutableDictionary alloc] init];
    NSMutableArray *postArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < self.posts.count; i++)
    {
        NSString *postID = (NSString*)[self.posts objectAtIndex:i];
        NSValue *value = (NSValue*)[self.croppedRects objectAtIndex:i];
        CGRect croppedRect = [value CGRectValue];
        
        NSDictionary *post = [NSDictionary dictionaryWithObjectsAndKeys:postID, k_POST_ID, [NSNumber numberWithFloat:croppedRect.origin.x], @"x1", [NSNumber numberWithFloat:croppedRect.origin.y], @"y1", [NSNumber numberWithFloat:croppedRect.size.width], @"x2", [NSNumber numberWithFloat:croppedRect.size.height], @"y2", [NSNumber numberWithFloat:croppedRect.size.width], @"width", nil];
        [postArray addObject:post];
    }
    
    [upload setObject:auth forKey:k_AUTH];
    [upload setObject:postArray forKey:k_POSTS];
    
    return upload;
}

@end
