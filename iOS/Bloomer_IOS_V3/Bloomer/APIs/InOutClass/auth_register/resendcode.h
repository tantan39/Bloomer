//
//  resendcode.h
//  Bloomer
//
//  Created by Tran Thai Tan on 12/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface resendcode : NSObject<BaseJSON>

@property (strong,nonatomic) NSString * mobile;
@property (assign,nonatomic) NSInteger country_id;
@property BOOL voice;

- (instancetype) initWithPhoneNumb:(NSString *) mobile CountryID:(NSInteger) countryID Voice:(BOOL) voice;

@end
