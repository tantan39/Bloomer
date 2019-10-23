//
//  resendcode.m
//  Bloomer
//
//  Created by Tran Thai Tan on 12/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "resendcode.h"

@implementation resendcode

- (instancetype) initWithPhoneNumb:(NSString *) mobile CountryID:(NSInteger) countryID Voice:(BOOL) voice{
    self = [super init];
    if (self) {
        self.mobile = mobile;
        self.country_id = countryID;
        self.voice = voice;
    }
    return self;

}

- (NSDictionary *)encodeToJSON{
    NSDictionary * params = @{k_MOBILE : _mobile,
                              k_COUNTRY_ID : [NSNumber numberWithInteger:_country_id],
                              k_VOICE : [[NSNumber numberWithBool:_voice] stringValue]
                              };    
    return params;
}

@end
