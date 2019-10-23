//
//  LocationManager.h
//  Bloomer
//
//  Created by Le Chau Tu on 12/19/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString* countryCode;

+(id)sharedInstance;
-(void)startUpdatingLocation;
-(void)stopUpdatingLocation;
-(NSString*)getCountryCode;

@end
