//
//  image_photo.h
//  Xinh
//
//  Created by Nguyen Thanh Tu on 12/16/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface image_photo : NSObject

//@property (strong, nonatomic) NSString* URL;

-(NSString *)getImageParamUserId:(NSInteger)userID andSize:(NSString*)size;

-(NSString* )getPhotoParamPhotoId:(NSString*)photoID andSize:(NSString*)size andFileType:(NSString*) type;

@end
