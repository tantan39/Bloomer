//
//  WeakLinkObj.m
//  MyChartDemo
//
//  Created by Ahri on 7/21/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import "WeakLinkObj.h"

@implementation WeakLinkObj

- (instancetype)initWithRealTarget:(id)target {
    self = [self init];
    if (self) {
        self.realTarget = target;
    }
    return self;
}

+ (instancetype)weakObjectWithRealTarget:(id)target {
    return [[self alloc] initWithRealTarget:target];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.realTarget;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
}

@end
