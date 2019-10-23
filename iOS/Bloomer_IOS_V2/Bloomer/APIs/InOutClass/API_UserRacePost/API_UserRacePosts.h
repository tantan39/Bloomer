//
//  API_UserRacePosts.h
//  Bloomer
//
//  Created by Steven on 4/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BloomerRestful.h"
#import "JSON_UserRacePosts.h"

//@protocol API_UserRacePostsDelegate <NSObject>
//
//- (void)getUserRacePostsSuccessful:(JSON_UserRacePosts *)data raceKey:(NSString*)raceKey;
//- (void)getUserRacePostsFail:(ASIHTTPRequest *)request;
//
//@end

@interface API_UserRacePosts : BloomerRestful

@property (weak, nonatomic) NSString* raceKey;

-(id)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                     key:(NSString *)key
                     uid:(NSInteger)uid
                 post_id:(NSString *)post_id
                   limit:(NSInteger)limit;

@end
