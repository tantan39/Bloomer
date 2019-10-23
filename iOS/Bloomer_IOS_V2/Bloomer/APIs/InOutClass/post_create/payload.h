//
//  payload.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/1/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface payload : NSObject

@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *caption;
@property (strong, nonatomic) NSMutableArray *tags;

- (id)initWithPhotoID:(NSString *)photo_id
              caption:(NSString *)caption
                 tags:(NSMutableArray *)tags;

@end
