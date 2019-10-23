//
//  achievementObject.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/2/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface achievementObject : NSObject
{
    @private
        NSString* name;
        NSString* data;
        int numberKey;
}

-(id)init;

-(id)initWithName:(NSString*) tittle content:(NSString*) content andKey:(int) number;

-(NSString*) getName;

-(NSString*) getData;

-(int) getKey;

-(void) setName:(NSString*) tittle;

-(void) setData:(NSString*) content;

-(void) setNumber:(int) key;

@end
