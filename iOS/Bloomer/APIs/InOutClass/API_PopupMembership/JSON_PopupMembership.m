//
//  JSON_PopupMembership.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_PopupMembership.h"

@implementation JSON_PopupMembership

-(instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if(self) {
        NSDictionary *data = [json objectForKey:@"data"];
        self.avatar = [data objectForKey:@"avatar"];
        self.htmlContent = [data objectForKey:@"content"];
        self.url = [data objectForKey:@"url"];
        self.key = [data objectForKey:@"key"];
        self.gsb = [[data objectForKey:@"gsb"] integerValue];
        
        NSDictionary *invitejoin = [json objectForKey:@"invitejoin"];
        _hasInvitation = invitejoin != nil;
        if(invitejoin) {
            _msgInvite = [invitejoin objectForKey:@"message"];
            _imgInviteLink = [invitejoin objectForKey:@"img"];
        }
    }
    return self;
}

@end
