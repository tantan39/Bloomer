//
//  Country.h
//  Bloomer
//
//  Created by Le Chau Tu on 12/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic, strong) NSString* countryCode;
@property (nonatomic, strong) NSString* countryShortName;
@property (nonatomic, strong) NSString* countryName;
@property (nonatomic, strong) NSString* countryFlag;
@property (nonatomic, assign) NSInteger countryID;

-(id)initWithCode:(NSString*)countryCode countryName:(NSString*)countryName countryShortName:(NSString*)countryShortName countryFlag:(NSString *) countryFlag  countryID:(NSInteger)countryID;

@end
