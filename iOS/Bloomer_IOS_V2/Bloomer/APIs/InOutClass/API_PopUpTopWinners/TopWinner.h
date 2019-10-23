//
//  TopWinner.h
//  Bloomer
//
//  Created by Steven on 1/2/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopWinner : NSObject

@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *popUpID;
@property (assign, nonatomic) NSInteger position;
@property (strong, nonatomic) NSString *raceKey;
@property (strong, nonatomic) NSString *raceName;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *url;

- (id)initWithAvatar:(NSString*)avatar message:(NSString*)message popUpID:(NSString*)popUpID position:(NSInteger)position raceKey:(NSString*)raceKey raceName:(NSString*)raceName type:(NSString*)type url:(NSString*)url;
@end
