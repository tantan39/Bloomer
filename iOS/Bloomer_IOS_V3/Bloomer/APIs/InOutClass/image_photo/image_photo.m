//
//  image_photo.m
//  Xinh
//
//  Created by Nguyen Thanh Tu on 12/16/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "image_photo.h"
#import "APIDefine.h"

@implementation image_photo

//@synthesize URL;

-(NSString *)getImageParamUserId:(NSInteger) userID andSize:(NSString*)size
{
    NSString *result = [APIDefine hImageLink];
    
    result= [[[result stringByAppendingString:[NSString stringWithFormat: @"%d", userID]] stringByAppendingString:@"/"] stringByAppendingString:size];
    
    return result;
}

-(NSString* )getPhotoParamPhotoId:(NSString*) photoID andSize:(NSString*)size andFileType:(NSString*) type
{
    NSString *result = [APIDefine hProfileLink];
    
    result= [[[[[result stringByAppendingString:photoID] stringByAppendingString:@"-"] stringByAppendingString:size] stringByAppendingString:@"."]stringByAppendingString:type];
    
    return result;
}

@end
