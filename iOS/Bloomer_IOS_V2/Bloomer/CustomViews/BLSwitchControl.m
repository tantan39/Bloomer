//
//  BLSwitchControl.m
//  Bloomer
//
//  Created by Tan Tan on 10/11/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "BLSwitchControl.h"

@interface BLSwitchControl()

@property (strong,nonatomic) ItemView * selectedView;
@property (strong,nonatomic) UITapGestureRecognizer * tapGesture;
@property (strong,nonatomic) UIPanGestureRecognizer * panGesture;
@property (strong,nonatomic) NSLayoutConstraint * selectedViewLeftPadding;
@end

@implementation BLSwitchControl

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self finishInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [ super initWithCoder:aDecoder];
    if (self) {
        [self finishInit];
    }
    return self;
}

- (void) finishInit{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = self.bounds.size.height / 2;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor rgb:245 green:245 blue:245].CGColor;
    
    ItemView * item1 = [[ItemView alloc] initWithIcon:[UIImage imageNamed:@"icoFemaleGrey"] Title: [AppHelper getLocalizedString:@"signUp.Female"]];
    item1.translatesAutoresizingMaskIntoConstraints = NO;

    ItemView * item2 = [[ItemView alloc] initWithIcon:[UIImage imageNamed:@"icoMaleGrey"] Title:[AppHelper getLocalizedString:@"signUP.Male"]];
    item2.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:item1];
    [self addSubview:item2];
    
    self.selectedIndex = 0;

    NSDictionary * views = NSDictionaryOfVariableBindings(item1,item2);

    NSArray * hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[item1][item2(==item1)]|" options:0 metrics:nil views:views];

    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];

    NSArray * vItem1Constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[item1]|" options:0 metrics:nil views:views];
    NSArray * vItem2Constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[item2]|" options:0 metrics:nil views:views];

    [self addConstraint:width];
    [self addConstraints:hConstraints];
    [self addConstraints:vItem1Constraints];
    [self addConstraints:vItem2Constraints];

    [self initSelectedView];

    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:self.tapGesture];
    
}

- (void) initSelectedView{
    self.selectedView = [[ItemView alloc] initWithIcon:[UIImage imageNamed:@"icoFemaleGrey"] Title:[AppHelper getLocalizedString:@"signUp.Female"]];
    self.selectedView.backgroundColor = [UIColor rgb:178 green:34 blue:37];
    [self.selectedView.lblTitle setTextColor:[UIColor whiteColor]];
    self.selectedView.layer.cornerRadius = self.bounds.size.height / 2;
    [self.selectedView clipsToBounds];
    self.selectedView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.selectedView];
    
    self.selectedViewLeftPadding = [NSLayoutConstraint constraintWithItem:self.selectedView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint * center = [NSLayoutConstraint constraintWithItem:self.selectedView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:self.selectedView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:self.selectedView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    
    [self addConstraints:@[self.selectedViewLeftPadding,center,width,height]];
    
//    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [self.selectedView addGestureRecognizer:self.panGesture];
    
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    if (selectedIndex == 0) {
        self.selectedViewLeftPadding.constant = 0;
        [self.selectedView.lblTitle setText:[AppHelper getLocalizedString:@"signUp.Female"]];
        [self.selectedView.icon setImage:[UIImage imageNamed:@"icoFemaleWhite"]];
    }else{
        self.selectedViewLeftPadding.constant = self.bounds.size.width / 2;
        [self.selectedView.lblTitle setText:[AppHelper getLocalizedString:@"signUP.Male"]];
        [self.selectedView.icon setImage:[UIImage imageNamed:@"icoMaleWhite"]];
    }
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
    
    if ([self respondsToSelector:@selector(sendActionsForControlEvents:)]) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

//MARK:- Gesture

- (void) handleTap:(UIGestureRecognizer *) gesture{
    CGPoint point = [gesture locationInView:self];
    int index = (point.x / (self.bounds.size.width / 2));
    
    [self setSelectedIndex:index];
}

- (void) handlePan:(UIPanGestureRecognizer * ) gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged:{
            
            CGRect frame = self.selectedView.frame;
            frame.origin.x += [gesture translationInView:self].x;
            frame.origin.x = MAX(MIN(frame.origin.x, self.bounds.size.width - frame.size.width), 2.0);
            self.selectedView.frame = frame;

        }
            break;

        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:{

            int index = MAX(0, MIN(1, (self.selectedView.center.x / (self.bounds.size.width / 2))));
//            [self setSelectedIndex:index];
        }
            break;


        default:
            break;
    }

}

@end

@implementation ItemView

- (instancetype)initWithIcon:(UIImage *)icon Title:(NSString *)title{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self config];
        self.icon.image = icon;
        self.lblTitle.text = title;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

- (void) config{
    
    self.icon = [[UIImageView alloc] init];
    [self.icon setContentMode:UIViewContentModeScaleAspectFit];
    [self.icon setContentMode:UIViewContentModeCenter];
    self.icon.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.icon];
    
    self.lblTitle = [[UILabel alloc] init];
    CGFloat fontSize = IS_IPHONE_5 ? 12 : 14;
    [self.lblTitle setFont:[UIFont fontWithName:@"SFProText-Regular" size:fontSize]];
    [self.lblTitle setTextColor:[UIColor rgb:211 green:211 blue:211]];
    self.lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.lblTitle];
    
    NSDictionary * views = NSDictionaryOfVariableBindings(_icon,_lblTitle);
    NSDictionary * metrics = @{@"padding": @15.0,
                               @"width" : @20.0
                               };

    NSArray * hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[_icon(width)]-padding-[_lblTitle]|" options:0 metrics:metrics views:views];
    NSArray * vIconConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_icon]|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views];
    NSArray * vTitleConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_lblTitle]|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];

    [self addConstraints:hConstraints];
    [self addConstraints:vIconConstraints];
    [self addConstraints:vTitleConstraints];
    
}



@end
