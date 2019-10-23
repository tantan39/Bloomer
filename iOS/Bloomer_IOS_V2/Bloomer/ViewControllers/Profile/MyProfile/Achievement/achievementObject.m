//
//  achievementObject.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/2/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "achievementObject.h"

@implementation achievementObject

-(id)init
{
    self = [super init];
    if(self)
    {
        self->name = [[NSString alloc] init];
        self->data = [[NSString alloc] init];
        self->numberKey = -1;
    }
    return self;
}

-(id)initWithName:(NSString*) tittle content:(NSString*) content andKey:(int) number
{
    self = [super init];
    if(self)
    {
        self->name = [[NSString alloc] initWithString:tittle];
        self->data = [[NSString alloc] initWithString:content];
        self->numberKey = number;
    }
    return self;
}

-(NSString*) getName
{
    return self->name;
}

-(NSString*) getData
{
    return self->data;
}

-(int) getKey
{
    return numberKey;
}

-(void) setName:(NSString*) tittle
{
    self->name = tittle;
}

-(void) setData:(NSString*) content
{
    self->data = content;
}

-(void) setNumber:(int) key
{
    self->numberKey = key;
}

@end
