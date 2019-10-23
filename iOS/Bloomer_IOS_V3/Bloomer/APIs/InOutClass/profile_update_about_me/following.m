//
//  following.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "following.h"
#import "AppHelper.h"

@implementation following

- (id)initWithUid:(NSInteger)uid isFollow:(BOOL)isFollow mocode:(NSString *)mocode gaveFlower:(long long)gave_flower name:(NSString *)name isChat:(BOOL)is_chat avatar:(NSString *)avatar spcode:(NSString *)spcode username:(NSString *)username matchingFlower:(BOOL)matchingFlower
{
    if (self)
    {
        _uid = uid;
        _is_follow = isFollow;
        _mocode = mocode;
        _gave_flower = gave_flower;
        _name = name;
        _is_chat = is_chat;
        _avatar = avatar;
        _spcode = spcode;
        _username = username;
        self.matchingFlower = matchingFlower;
    }
    
    return self;
}

- (CSSearchableItemAttributeSet*)searchableItemAttributeSet
{
    CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(__bridge NSString *)kUTTypeContact];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.avatar]];
    
    attributeSet.title = self.name;
    attributeSet.displayName = self.name;
    attributeSet.contentDescription = self.username;
    attributeSet.thumbnailData = imageData;
    attributeSet.supportsPhoneCall = [NSNumber numberWithBool:true];
    attributeSet.supportsNavigation = [NSNumber numberWithBool:true];
    attributeSet.keywords = @[self.name, self.username];
    
    //    CSSearchableItem *searchItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:[NSString stringWithFormat:@"Bloomer_User_%ld", self.uid] domainIdentifier:kSpotlightSearchUser attributeSet:attributeSet];
    
    return attributeSet;
}

- (CSSearchableItem*)searchableItem
{
    CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(__bridge NSString *)kUTTypeContact];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.avatar]];
    
    attributeSet.title = self.name;
    attributeSet.displayName = self.name;
    attributeSet.contentDescription = self.username;
    attributeSet.thumbnailData = imageData;
    attributeSet.supportsPhoneCall = [NSNumber numberWithBool:true];
    attributeSet.supportsNavigation = [NSNumber numberWithBool:true];
    attributeSet.keywords = @[self.name, self.username];
    
    CSSearchableItem *searchItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:[NSString stringWithFormat:@"%@#$#%ld", kSpotlightSearchUser, self.uid] domainIdentifier:kSpotlightSearchUser attributeSet:attributeSet];
    
    return searchItem;
}

@end
