//
//  JSON_PostUserFetches.h
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"

@interface JSON_JoinRace : NSObject <BaseJSON>

@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) NSInteger irace_joined;
@property (assign, nonatomic) NSInteger irace_new;

@end


@interface JSON_CheckJoinRace : NSObject <BaseJSON>

@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) NSInteger irace_joined;
@property (assign, nonatomic) NSInteger irace_left;

@end
