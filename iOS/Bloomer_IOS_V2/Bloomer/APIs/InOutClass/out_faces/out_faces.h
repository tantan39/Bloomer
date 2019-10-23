//
//  out_faces.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseJSON.h"
#import "face.h"

@interface out_faces : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray * faces;

@end


