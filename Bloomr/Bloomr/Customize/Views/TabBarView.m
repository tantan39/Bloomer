//
//  TabBarView.m
//  Xinh
//
//  Created by Truong Thuan Tai on 11/20/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "TabBarView.h"

#define MARGIN_VERTICAL 0.0f
#define MARGIN_HORIZONTAL 0.0f
#define OBJECT_WIDTH 80.0f
#define OBJECT_HEIGHT 80.0f

@implementation TabBarView
{
    BOOL isFlowerBouncing;
    SEDraggableLocation *home;
    SEDraggable *draggable;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flowerButtonTap)];
        singleTap.numberOfTapsRequired = 1;
        [_flowerButton addGestureRecognizer:singleTap];
        [_flowerButton setUserInteractionEnabled:TRUE];
        
        [self addSubview:self.view];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flowerButtonTap)];
        singleTap.numberOfTapsRequired = 1;
        [_flowerButton addGestureRecognizer:singleTap];
        [_flowerButton setUserInteractionEnabled:TRUE];
        
        isFlowerBouncing = false;
        
        [self addSubview:self.view];
        
        [self initTabbar];
    }
    return self;
}

- (void) initTabbar
{
    home = [[SEDraggableLocation alloc] initWithFrame:_flowerView.frame];
    [self addSubview:home];
    [self configureDraggableLocation:home];
    home.delegate = self;
    _homeLocation = home;
    
    draggable = [[SEDraggable alloc] initWithImageView: _flowerButton];
    draggable.delegate = self;
//    [draggable addSubview:_flowerValue];
    [self configureDraggableObject:draggable];
    _draggableButton = draggable;
    
    [self.view setExclusiveTouch:TRUE];
    [self.view bringSubviewToFront:_flowerValue];
}

- (void)setTabBarMode:(TabBarMode)mode{
    switch (mode) {
        case  Flower:{
            [self.imgvFlower setHidden:NO];
            [home setHidden:NO];
            [draggable setHidden:NO];
            [_stayFlowerValue setHidden:NO];
            break;
        }
        case UploadPhoto:{
            [self.imgvFlower setHidden:YES];
            [home setHidden:YES];
            [draggable setHidden:YES];
            [_stayFlowerValue setHidden:YES];
            break;
        }

        default:
            break;
    }
}

- (void) configureDraggableLocation:(SEDraggableLocation *)draggableLocation {
    // set the width and height of the objects to be contained in this SEDraggableLocation (for spacing/arrangement purposes)
    draggableLocation.objectWidth = OBJECT_WIDTH;
    draggableLocation.objectHeight = OBJECT_HEIGHT;
    
    // set the bounding margins for this location
//    draggableLocation.marginLeft = MARGIN_HORIZONTAL;
//    draggableLocation.marginRight = MARGIN_HORIZONTAL;
//    draggableLocation.marginTop = MARGIN_VERTICAL;
//    draggableLocation.marginBottom = MARGIN_VERTICAL;
    
    draggableLocation.marginLeft = -12.0f;
    draggableLocation.marginRight = MARGIN_HORIZONTAL;
    draggableLocation.marginTop = -12.0f;
    draggableLocation.marginBottom = MARGIN_VERTICAL;
    
    // set the margins that should be preserved between auto-arranged objects in this location
    draggableLocation.marginBetweenX = MARGIN_HORIZONTAL;
    draggableLocation.marginBetweenY = MARGIN_VERTICAL;
    
    // set up highlight-on-drag-over behavior
    draggableLocation.highlightColor = [UIColor greenColor].CGColor;
    draggableLocation.highlightOpacity = 0.4f;
    draggableLocation.shouldHighlightOnDragOver = YES;
    
    // you may want to toggle this on/off when certain events occur in your app
    draggableLocation.shouldAcceptDroppedObjects = NO;
    
    // set up auto-arranging behavior
    draggableLocation.shouldKeepObjectsArranged = YES;
    draggableLocation.fillHorizontallyFirst = YES; // NO makes it fill rows first
    draggableLocation.allowRows = YES;
    draggableLocation.allowColumns = YES;
    draggableLocation.shouldAnimateObjectAdjustments = YES; // if this is set to NO, objects will simply appear instantaneously at their new positions
    draggableLocation.animationDuration = 0.5f;
    draggableLocation.animationDelay = 0.0f;
    draggableLocation.animationOptions = UIViewAnimationOptionLayoutSubviews ; // UIViewAnimationOptionBeginFromCurrentState;
    
    draggableLocation.shouldAcceptObjectsSnappingBack = YES;
}

- (void) configureDraggableObject:(SEDraggable *)draggable {
    draggable.homeLocation = _homeLocation;
    [_homeLocation addDraggableObject:draggable animated:NO];
}

- (void) draggableObject:(SEDraggable *)object finishedEnteringLocation:(SEDraggableLocation *)location withEntryMethod:(SEDraggableLocationEntryMethod)entryMethod
{
    [object setHidden:NO];
    
    if (entryMethod == SEDraggableLocationEntryMethodWantsToSnapBack)
    {
        if(isFlowerBouncing == false)
        {
            [_flowerButton setImage:[UIImage imageNamed:@"Btn_FlowersTabbar.png"]];
            [_flowerValue setHidden:FALSE];
        }
    }
}

-(void)setFlowerButtonWithDefaultImage
{
    [self.flowerButton setImage:[UIImage imageNamed:@"Btn_FlowersTabbar.png"]];
}

-(void)flowerButtonTap
{
    _flowerButton.highlighted = FALSE;
}

- (void) draggableObjectDidMove:(SEDraggable *)object
{  
    [_flowerButton setImage:[UIImage imageNamed:@"Icon_Giving_Flowers"]];
    [_flowerValue setHidden:TRUE];
}

- (void)snapbackFlowerIconToTabbar
{    
    if (![self.draggableButton.homeLocation pointIsInsideResponsiveBounds:CGPointMake(self.draggableButton.firstX, self.draggableButton.firstY)])
    {
        [self.draggableButton askToSnapBackToLocation:self.draggableButton.homeLocation animated:YES];
    }
}

@end
