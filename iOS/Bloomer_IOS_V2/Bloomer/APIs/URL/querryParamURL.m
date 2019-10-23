
//
//  querryParamURL.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/10/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "querryParamURL.h"

@implementation querryParamURL

- (id)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (id)initWithUrl:(NSString *)linkUrl andparams:(NSMutableArray *)parameter {
    self = [super initWithUrl:linkUrl];
    
    if (self) {
        self->params = [NSMutableArray arrayWithArray:parameter];
    }
    
    return self;
}

- (NSString *)getUrl {
    if (params.count != 0) {
        NSArray *foo = [self->url componentsSeparatedByString: @"?"];
        NSString *rightSide = [foo objectAtIndex:1];
        NSArray *foo2 = [rightSide componentsSeparatedByString:@"&"];
        
        NSInteger n = [self->params count];
        NSString *rightParam = @"";
        
        for (int i = 0; i < n ; i++) {
            NSArray *foo3 = [[foo2 objectAtIndex: i] componentsSeparatedByString:@"="];
            
            if (i > 0) {
                rightParam = [rightParam stringByAppendingString:@"&"];
            }
            
            rightParam = [[[rightParam stringByAppendingString:[foo3 objectAtIndex:0]] stringByAppendingString:@"="] stringByAppendingString:[self->params objectAtIndex:i]];
        }
        
        NSString *result=[[[foo objectAtIndex:0] stringByAppendingString:@"?"] stringByAppendingString:rightParam];
        
        NSLog(@"%@", result);
        
        return result;
    }
    
    NSLog(@"%@", self->url);
    
    return self->url;
}
-(NSString*) updateAccessTokenURL{
    if (![self->url isEqualToString:@""]) {
        
        //get access_token from userdefault
        NSString* access_token = @"fdjsakfjlsjflsdjfjlk";
        NSArray *foo = [self->url componentsSeparatedByString: @"?"];
        NSString *rightSide = [foo objectAtIndex:1];
        NSArray *foo2 = [rightSide componentsSeparatedByString:@"&"];
        
        NSInteger n = [self->params count];
        NSString *rightParam = @"";
        
        for (int i = 0; i < n ; i++) {
            NSArray *foo3 = [[foo2 objectAtIndex: i] componentsSeparatedByString:@"="];
           
            //
            
            rightParam = [[[rightParam stringByAppendingString:[foo3 objectAtIndex:0]] stringByAppendingString:@"="] stringByAppendingString:access_token];
        }
        
        NSString *result=[[[foo objectAtIndex:0] stringByAppendingString:@"?"] stringByAppendingString:rightParam];
        
        NSLog(@"%@", result);
        
        return result;
    }
    
    NSLog(@"%@", self->url);
    
    return self->url;
}

@end
