//
//  AlbumInfo.h
//  Bloomer
//
//  Created by Steven on 6/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface AlbumInfo : NSObject

@property (assign, nonatomic) NSInteger totalPhoto;
@property (strong, nonatomic) UIImage* thumbnail;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) PHAssetCollection *albumCollection;

- (id)initWithName:(NSString*)name totalPhoto:(NSInteger)totalPhoto thumbnail:(UIImage*)thumbnail;

@end
