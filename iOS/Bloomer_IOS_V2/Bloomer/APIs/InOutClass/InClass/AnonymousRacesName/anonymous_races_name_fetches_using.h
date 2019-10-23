//
//  anonymous_races_name_fetches_using.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 5/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UsingAPIs.h"
#import "out_races_name_fetches.h"

@protocol anonymous_races_name_fetchesDelegate <NSObject>

-(void)getDataRacesName_fetches:(out_races_name_fetches *) data;
-(void)Races_Name_Fetches_RequestFailed:(ASIHTTPRequest *)request;

@end

@interface anonymous_races_name_fetches_using : UsingAPIs<connectToServer>

@property (weak, nonatomic) id <anonymous_races_name_fetchesDelegate> myDelegate;

-(id)initWithkey:(NSString *)key
         gender:(NSInteger)gender;

@end
