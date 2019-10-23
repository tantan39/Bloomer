//
//  API_LoadPhoto.h
//  Bloomer
//
//  Created by Le Chau Tu on 10/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_LoadPhoto.h"

@interface API_LoadPhoto : BloomerRestful

-(id)initWithPhotoId:(NSString*)photo_id size:(NSString*)size;

@end
