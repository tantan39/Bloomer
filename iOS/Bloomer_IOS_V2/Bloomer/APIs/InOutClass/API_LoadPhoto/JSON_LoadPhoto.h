//
//  JSON_LoadPhoto.h
//  Bloomer
//
//  Created by Le Chau Tu on 10/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface JSON_LoadPhoto : NSObject<BaseJSON>

@property (strong, nonatomic) NSString* photo_url;

@end
