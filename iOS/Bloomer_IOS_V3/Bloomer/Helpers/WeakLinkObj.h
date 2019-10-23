//
//  WeakLinkObj.h
//  MyChartDemo
//
//  Created by Ahri on 7/21/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakLinkObj: NSObject

@property (weak, nonatomic) id realTarget;

- (instancetype)initWithRealTarget:(id)target;

+ (instancetype)weakObjectWithRealTarget:(id)target;

@end
