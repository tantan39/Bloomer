//
//  LocationManager.m
//  Bloomer
//
//  Created by Le Chau Tu on 12/19/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

+(id)sharedInstance {
    static LocationManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(id)init {
    self = [super init];
    if (self) {
        _countryCode = @"vn";
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager requestWhenInUseAuthorization];
    }
    return self;
}

-(void)startUpdatingLocation {
    [_locationManager startUpdatingLocation];
}

-(void)stopUpdatingLocation {
    [_locationManager stopUpdatingLocation];
}

-(NSString *)getCountryCode {
    return _countryCode;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    [reverseGeocoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(!error) {
            CLPlacemark *placemark = [placemarks lastObject];
            _countryCode = [placemark.ISOcountryCode lowercaseString];
//            NSLog(@"Country code: %@", _countryCode);
        }
    }];
}

@end
