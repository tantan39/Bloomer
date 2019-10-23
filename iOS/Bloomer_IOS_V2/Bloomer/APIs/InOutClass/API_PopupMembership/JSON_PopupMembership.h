//
//  JSON_PopupMembership.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface JSON_PopupMembership : NSObject <BaseJSON>

@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *htmlContent;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) BOOL hasInvitation;
@property (nonatomic, strong) NSString *msgInvite;
@property (nonatomic, strong) NSString *imgInviteLink;
@property (nonatomic, assign) NSInteger gsb;

@end
