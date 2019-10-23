//
//  API_Avatar_Attached.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/23/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Avatar_Attached.h"

@implementation API_Avatar_Attached

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token image:(UIImage *)image{
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
//    NSData *imageData = UIImagePNGRepresentation(image);
    
//
//    if (_accessToken != nil)
//    {
//        [myRequest addPostValue:_accessToken forKey:k_ACCESS_TOKEN];
//        [myRequest addPostValue:_device_token forKey:k_DEVICE_TOKEN];
//        if(___ty != nil)
//        {
//            [myRequest addPostValue:___ty forKey:k_TY];
//        }
//        if(_raceKey!= nil)
//        {
//            [myRequest addPostValue:_raceKey forKey:@"key"];
//        }
//    }
//    else
//    {
//        [myRequest addPostValue:@(_m_id).stringValue forKey:k_M_ID];
//    }
//    
//    
//    [myRequest setData:imageData forKey:k_UPLOAD];
    
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token};
    
    self = [super initWith:[APIDefine avatar_attachedLink] Params:params];
    self.dataImage = imageData;
    
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_avatar_attached alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_avatar_attached alloc] init];
}

@end
