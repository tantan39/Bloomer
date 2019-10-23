//
//  anonymous_races_surprise_fetches_using.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 5/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UsingAPIs.h"
#import "out_races_fetches.h"

@protocol anonymous_racesSurprise_fetchesDelegate <NSObject>

-(void)getDataRacesSurprise_fetches:(out_races_fetches *) data;
-(void)RacesSurprise_Fetches_RequestFailed:(ASIHTTPRequest *)request;

@end

@interface anonymous_races_surprise_fetches_using : UsingAPIs <connectToServer>
@property (weak, nonatomic) id <anonymous_racesSurprise_fetchesDelegate> myDelegate;

-(id)initWithKey:(NSString *)key
                    ckey:(NSString *)ckey
                  gender:(NSInteger)gender;
@end
