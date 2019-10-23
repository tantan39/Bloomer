//
//  WaveView.m
//  MyChartDemo
//
//  Created by Ahri on 7/21/17.
//  Copyright © 2017 Bloomer. All rights reserved.
//

#import "WaveView.h"
#import "WeakLinkObj.h"

@interface WaveView () {
}

@property (assign, nonatomic) CGFloat offsetX;
@property (strong, nonatomic) CAShapeLayer *waveShapeLayer;

@property (strong, nonatomic) CADisplayLink *waveDisplayLink;
@property (strong, nonatomic) NSTimer *waveGoesDownTimer;
@property (strong, nonatomic) NSTimer *waveSlowerTimer;

@end

@implementation WaveView

- (void)dealloc {
    [self.waveDisplayLink invalidate];
    [self.waveGoesDownTimer invalidate];
    [self.waveSlowerTimer invalidate];
    self.waveDisplayLink = nil;
    self.waveGoesDownTimer = nil;
    self.waveSlowerTimer = nil;
}

+ (instancetype)addToView:(UIView *)view withFrame:(CGRect)frame {
    WaveView *wave = [[self alloc] initWithFrame:frame];
    [view addSubview:wave];
    return wave;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self basicSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        [self basicSetup];
    }
    return self;
}

- (void)basicSetup {
    self.waveColor = [UIColor whiteColor];
    self.waveTime = 1.5f;
    self.angularSpeed = 2.f;
    self.waveSpeed = 6.f;
    self.steepIncrementUnit = 0.2f;
}

- (BOOL)wave {
    if (self.waveShapeLayer.path) {
        return false;
    }
    
    self.waveShapeLayer = [CAShapeLayer layer];
    self.waveShapeLayer.fillColor = self.waveColor.CGColor;
    [self.layer addSublayer:self.waveShapeLayer];
    
    self.waveDisplayLink = [CADisplayLink displayLinkWithTarget:[WeakLinkObj weakObjectWithRealTarget:self]
                                                       selector:@selector(currentWave)];
    [self.waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    if (self.waveTime != WAVE_NEVER_STOP && self.waveTime > 0.f) {
        __weak WaveView *weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.waveTime * NSEC_PER_SEC))
                       , dispatch_get_main_queue(), ^{
                           [weakSelf activateStopTimers];
                       });
    }
    return true;
}

- (void)currentWave {
    self.offsetX -= (self.waveSpeed * self.superview.frame.size.width / 320);
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = 0.f;
    CGFloat steepLevel = 0.f;
    
    if (self.isFrontWave) {
        CGPathMoveToPoint(path, nil, 0, height / 2);
        for (CGFloat x = 0.f; x <= width; x++) {
            y = height * sin(0.01 * (self.angularSpeed * x + self.offsetX)) - steepLevel;
            CGPathAddLineToPoint(path, nil, x, y);
            steepLevel += self.steepIncrementUnit;
        }
        CGPathAddLineToPoint(path, nil, width, height);
        CGPathAddLineToPoint(path, nil, 0, height);
        CGPathCloseSubpath(path);
    } else {
        CGPathMoveToPoint(path, nil, 0, height);
        for (CGFloat x = 0.f; x <= width; x++) {
            y = height * sin(0.01 * (self.angularSpeed * x + self.offsetX)) - steepLevel;
            CGPathAddLineToPoint(path, nil, x, y);
            steepLevel += self.steepIncrementUnit;
        }
        CGPathAddLineToPoint(path, nil, width, height / 2);
        CGPathAddLineToPoint(path, nil, width, height);
        CGPathCloseSubpath(path);
    }
    self.waveShapeLayer.path = path;
    CGPathRelease(path);
}

- (void)activateStopTimers {
    self.waveGoesDownTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                              target:[WeakLinkObj weakObjectWithRealTarget:self]
                                                            selector:@selector(waveGoesDown)
                                                            userInfo:nil
                                                             repeats:true];
}

- (void)waveGoesDown {
    self.steepIncrementUnit -= 0.003f;
    if (self.steepIncrementUnit < 0.1f) {
        self.waveSlowerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                                  target:[WeakLinkObj weakObjectWithRealTarget:self]
                                                                selector:@selector(waveBecomesSlower)
                                                                userInfo:nil
                                                                 repeats:true];
        [self.waveGoesDownTimer invalidate];
        self.waveGoesDownTimer = nil;
    }
}

- (void)waveBecomesSlower {
    self.waveSpeed -= 0.2f;
    if (self.waveSpeed < 0) {
        [self.waveDisplayLink invalidate];
        [self.waveSlowerTimer invalidate];
        self.waveDisplayLink = nil;
        self.waveSlowerTimer = nil;
//        self.waveShapeLayer.path = nil; // make wave disappear
//        self.alpha = 0.9f;
    }
}

@end
