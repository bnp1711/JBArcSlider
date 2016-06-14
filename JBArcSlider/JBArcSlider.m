//
//  JBArcSlider.m
//  Awake
//
//  Created by Bhavesh Patel on 13/6/16.
//  Copyright (c) 2016 Bhavesh Patel. All rights reserved.
//

#import "JBArcSlider.h"
#import <QuartzCore/QuartzCore.h>
#import "JBArcTrig.h"


@interface JBArcSlider ()

@property (nonatomic) CGFloat radius;
@property (nonatomic) int     angleFromNorth;
@property (nonatomic, strong) NSMutableDictionary *labelsWithPercents;

@property (nonatomic, readonly) CGFloat handleWidth;
@property (nonatomic, readonly) CGFloat innerLabelRadialDistanceFromCircumference;
@property (nonatomic, readonly) CGPoint centerPoint;

@property (nonatomic, readonly) CGFloat radiusForDoubleArcOuterArc;
@property (nonatomic, readonly) CGFloat lineWidthForDoubleArcOuterArc;
@property (nonatomic, readonly) CGFloat radiusForDoubleArcInnerArc;
@property (nonatomic, readonly) CGFloat lineWidthForDoubleArcInnerArc;

@end

static const CGFloat kFitFrameRadius = -1.0;

@implementation JBArcSlider

@synthesize radius = _radius;

#pragma mark - Initialisation
- (id)init
{
    return [self initWithRadius:kFitFrameRadius];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultValuesWithRadius:kFitFrameRadius];
    }
    return self;
}

- (id)initWithRadius:(CGFloat)radius
{
    self = [super init];
    if (self)
    {
        [self initDefaultValuesWithRadius:radius];
    }
    return self;
}

-(void) initDefaultValuesWithRadius:(CGFloat)radius
{
    _radius        = radius;
    _maximumValue  = 100.0f;
    _minimumValue  = 0.0f;
    _lineWidth     = 5;
    _unfilledColor = [UIColor grayColor];
    _filledColor   = [UIColor purpleColor];
    _labelFont     = [UIFont systemFontOfSize:10.0f];
    _snapToLabels  = NO;
    _handleType    = ArcSliderHandleTypeSemiTransparentWhiteArc;
    _labelColor    = [UIColor blackColor];
    _labelDisplacement = 0;
    _angleFromNorth = 0;
    _StartAngle = 1;
    _EndAngle = 360;
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Public setter overrides
-(void) setStartAngle:(float)StartAngle
{
    _StartAngle = StartAngle;
    _angleFromNorth = _StartAngle;
    [self setNeedsUpdateConstraints]; // This could affect intrinsic content size
    [self invalidateIntrinsicContentSize]; // Need to update intrinsice content size
    [self setNeedsDisplay];           // Need to redraw with new line width
}

-(void) setLineWidth:(int)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsUpdateConstraints]; // This could affect intrinsic content size
    [self invalidateIntrinsicContentSize]; // Need to update intrinsice content size
    [self setNeedsDisplay];           // Need to redraw with new line width
}

-(void) setHandleType:(ArcSliderHandleType)handleType
{
    _handleType = handleType;
    [self setNeedsUpdateConstraints]; // This could affect intrinsic content size
    [self setNeedsDisplay];           // Need to redraw with new handle type
}

-(void) setFilledColor:(UIColor*)filledColor
{
    _filledColor = filledColor;
    [self setNeedsDisplay]; // Need to redraw with new filled color
}

-(void) setUnfilledColor:(UIColor*)unfilledColor
{
    _unfilledColor = unfilledColor;
    [self setNeedsDisplay]; // Need to redraw with new unfilled color
}

-(void) setHandlerColor:(UIColor *)handleColor
{
    _handleColor = handleColor;
    [self setNeedsDisplay]; // Need to redraw with new handle color
}

-(void) setLabelFont:(UIFont*)labelFont
{
    _labelFont = labelFont;
    [self setNeedsDisplay]; // Need to redraw with new label font
}

-(void) setLabelColor:(UIColor*)labelColor
{
    _labelColor = labelColor;
    [self setNeedsDisplay]; // Need to redraw with new label color
}

-(void)setInnerMarkingLabels:(NSArray*)innerMarkingLabels
{
    _innerMarkingLabels = innerMarkingLabels;
    [self setNeedsUpdateConstraints]; // This could affect intrinsic content size
    [self setNeedsDisplay]; // Need to redraw with new label texts
}

-(void)setMinimumValue:(float)minimumValue
{
    _minimumValue = minimumValue;
    [self setNeedsDisplay]; // Need to redraw with updated value range
}

-(void)setMaximumValue:(float)maximumValue
{
    _maximumValue = maximumValue;
    [self setNeedsDisplay]; // Need to redraw with updated value range
}

/**
 *  There is no local variable currentValue - it is always calculated based on angleFromNorth
 *
 *  @param currentValue Value used to update angleFromNorth between minimumValue & maximumValue
 */
-(void) setCurrentValue:(float)currentValue
{
    NSAssert(currentValue <= self.maximumValue && currentValue >= self.minimumValue,
             @"currentValue (%.2f) must be between self.minimuValue (%.2f) and self.maximumValue (%.2f)",
              currentValue, self.minimumValue, self.maximumValue);
    
    // Update the angleFromNorth to match this newly set value
    self.angleFromNorth = (currentValue * _EndAngle)/(self.maximumValue - self.minimumValue);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)setAngleFromNorth:(int)angleFromNorth
{
    _angleFromNorth = angleFromNorth;
    NSAssert(_angleFromNorth >= 0, @"_angleFromNorth %d must be greater than 0", angleFromNorth);
}

-(void) setRadius:(CGFloat)radius
{
    _radius = radius;
    [self invalidateIntrinsicContentSize]; // Need to update intrinsice content size
    [self setNeedsDisplay]; // Need to redraw with new radius
}

#pragma mark - Public getter overrides

/**
 *  There is no local variable currentValue - it is always calculated based on angleFromNorth
 *
 *  @return currentValue Value between minimumValue & maximumValue derived from angleFromNorth
 */
-(float) currentValue
{
    float temp = ((self.angleFromNorth-_StartAngle) * (self.maximumValue - self.minimumValue))/(_EndAngle-_StartAngle);
    if (temp>self.maximumValue) {
        temp = _maximumValue;
    }else if(temp<self.minimumValue)
    {
        temp = _minimumValue;
    }
    if(self.angleFromNorth < _StartAngle)
    {
        self.angleFromNorth = _StartAngle;
        [self setNeedsDisplay];
    }else if (self.angleFromNorth > _EndAngle)
    {
        self.angleFromNorth = _EndAngle;
        [self setNeedsDisplay];
    }
    return temp;
}

-(CGFloat) radius
{
    if (_radius == kFitFrameRadius)
    {
        // Slider is being used in frames - calculate the max radius based on the frame
        //  (constrained by smallest dimension so it fits within view)
        CGFloat minimumDimension = MIN(self.bounds.size.height, self.bounds.size.width);
        int halfLineWidth = ceilf(self.lineWidth / 2.0);
        int halfHandleWidth = ceilf(self.handleWidth / 2.0);
        return minimumDimension * 0.5 - MAX(halfHandleWidth, halfLineWidth);
    }
    
    return _radius;
}

-(UIColor*)handleColor
{
    UIColor *newHandleColor = _handleColor;
    switch (self.handleType) {
        case ArcSliderHandleTypeSemiTransparentWhiteArc:
        {
            newHandleColor = [UIColor colorWithWhite:1.0 alpha:0.7];
            break;
        }
        case ArcSliderHandleTypeSemiTransparentBlackArc:
        {
            newHandleColor = [UIColor colorWithWhite:0.0 alpha:0.7];
            break;
        }
        case ArcSliderHandleTypeDoubleArcWithClosedCenter:
        case ArcSliderHandleTypeDoubleArcWithOpenCenter:
        case ArcSliderHandleTypeBigCircle:
        {
            if (!newHandleColor)
            {
                // handleColor public property hasn't been set - use filledColor
                newHandleColor = self.filledColor;
            }
            break;
        }
    }
    
    return newHandleColor;
}

#pragma mark - Private getter overrides

-(CGFloat) handleWidth
{
    switch (self.handleType) {
        case ArcSliderHandleTypeSemiTransparentWhiteArc:
        case ArcSliderHandleTypeSemiTransparentBlackArc:
        {
            return self.lineWidth;
        }
        case ArcSliderHandleTypeBigCircle:
        {
            return self.lineWidth + 5; // 5 points bigger than standard handles
        }
        case ArcSliderHandleTypeDoubleArcWithClosedCenter:
        case ArcSliderHandleTypeDoubleArcWithOpenCenter:
        {
            return 2 * [JBArcTrig outerRadiuOfUnfilledArcWithRadius:self.radiusForDoubleArcOuterArc
                                                               lineWidth:self.lineWidthForDoubleArcOuterArc];
        }
    }
}

-(CGFloat)radiusForDoubleArcOuterArc
{
    return 0.5 * self.lineWidth + 5;
}
-(CGFloat)lineWidthForDoubleArcOuterArc
{
    return 4.0;
}

-(CGFloat)radiusForDoubleArcInnerArc
{
    return 0.5 * self.lineWidth;
}
-(CGFloat)lineWidthForDoubleArcInnerArc
{
    return 2.0;
}

-(CGFloat)innerLabelRadialDistanceFromCircumference
{
    // Labels should be moved far enough to clear the line itself plus a fixed offset (relative to radius).
    int distanceToMoveInwards  = 0.1 * -(self.radius) - 0.5 * self.lineWidth;
        distanceToMoveInwards -= 0.5 * self.labelFont.pointSize; // Also account for variable font size.
    return distanceToMoveInwards;
}

-(CGPoint)centerPoint
{
    return CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
}

#pragma mark - Method overrides
-(CGSize)intrinsicContentSize
{    // Total width is: diameter + (2 * MAX(halfLineWidth, halfHandleWidth))
    int diameter = self.radius * 2;
    int halfLineWidth = ceilf(self.lineWidth / 2.0);
    int halfHandleWidth = ceilf(self.handleWidth / 2.0);
    
    int widthWithHandle = diameter + (2 *  MAX(halfHandleWidth, halfLineWidth));
    
    return CGSizeMake(widthWithHandle, widthWithHandle);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // Draw the arc lines that slider handle moves along
    [self drawLine:ctx];
    
    // Draw the draggable 'handle'
    [self drawHandle:ctx];
    
    // Add the labels
    [self drawInnerLabels:ctx];
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInsideHandle:point withEvent:event])
    {
        return YES; // Point is indeed within handle bounds
    }
    else
    {
        return [self pointInsideArc:point withEvent:event]; // Return YES if point is inside slider's Arc
    }
}

- (BOOL)pointInsideArc:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint p1 = [self centerPoint];
    CGPoint p2 = point;
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    double distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance < self.radius + self.lineWidth * 0.5;
}

- (BOOL)pointInsideHandle:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint handleCenter = [self pointOnArcAtAngleFromNorth:self.angleFromNorth];
    CGFloat handleRadius = MAX(self.handleWidth, 44.0) * 0.5;
    // Adhere to apple's design guidelines - avoid making touch targets smaller than 44 points
    
    // Treat handle as a box around it's center
    BOOL pointInsideHorzontalHandleBounds = (point.x >= handleCenter.x - handleRadius
                                             && point.x <= handleCenter.x + handleRadius);
    BOOL pointInsideVerticalHandleBounds  = (point.y >= handleCenter.y - handleRadius
                                             && point.y <= handleCenter.y + handleRadius);
    return pointInsideHorzontalHandleBounds && pointInsideVerticalHandleBounds;
}

#pragma mark - Drawing methods

-(void) drawLine:(CGContextRef)ctx
{
    if(self.angleFromNorth > _EndAngle && self.angleFromNorth < _StartAngle){
        _angleFromNorth = _StartAngle;
    }
    // Draw an unfilled Arc (this shows what can be filled)
    [self.unfilledColor set];
    [JBArcTrig drawUnfilledArcInContext:ctx
                               center:self.centerPoint
                               radius:self.radius
                            lineWidth:self.lineWidth
                            StartAngle:self.StartAngle
                            EndAngle:self.EndAngle];

    // Draw an unfilled arc up to the currently filled point
    [self.filledColor set];
    
    [JBArcTrig drawUnfilledArcInContext:ctx
                                      center:self.centerPoint
                                      radius:self.radius
                                   lineWidth:self.lineWidth
                          fromAngleFromNorth:self.StartAngle
                            toAngleFromNorth:self.angleFromNorth];
}

-(void) drawHandle:(CGContextRef)ctx{
    CGContextSaveGState(ctx);
    CGPoint handleCenter = [self pointOnArcAtAngleFromNorth:self.angleFromNorth];
    
    // Ensure that handle is drawn in the correct color
    [self.handleColor set];
    switch (self.handleType) {
        case ArcSliderHandleTypeSemiTransparentWhiteArc:
        case ArcSliderHandleTypeSemiTransparentBlackArc:
        case ArcSliderHandleTypeBigCircle:
        {
            [JBArcTrig drawFilledArcInContext:ctx
                                     center:handleCenter
                                     radius:0.5 * self.handleWidth];
            break;
        }
        case ArcSliderHandleTypeDoubleArcWithClosedCenter:
        case ArcSliderHandleTypeDoubleArcWithOpenCenter:
        {
            [self drawUnfilledLineBehindDoubleArcHandle:ctx];
            // Draw unfilled outer Arc
            [JBArcTrig drawUnfilledArcInContext:ctx
                                       center:CGPointMake(handleCenter.x,
                                                          handleCenter.y)
                                       radius:self.radiusForDoubleArcOuterArc
                                    lineWidth:self.lineWidthForDoubleArcOuterArc
                                            StartAngle:self.StartAngle
                                              EndAngle:self.EndAngle];
            
            if (self.handleType == ArcSliderHandleTypeDoubleArcWithClosedCenter)
            {
                // Draw filled inner Arc
                [JBArcTrig drawFilledArcInContext:ctx
                                                   center:handleCenter
                                                   radius:[JBArcTrig outerRadiuOfUnfilledArcWithRadius:self.radiusForDoubleArcInnerArc
                                                                                                  lineWidth:self.lineWidthForDoubleArcInnerArc]];
            }
            else if (self.handleType == ArcSliderHandleTypeDoubleArcWithOpenCenter)
            {
                // Draw unfilled inner Arc
                [JBArcTrig drawUnfilledArcInContext:ctx
                                                     center:CGPointMake(handleCenter.x,
                                                                        handleCenter.y)
                                                     radius:self.radiusForDoubleArcInnerArc
                                                  lineWidth:self.lineWidthForDoubleArcInnerArc
                                                StartAngle:self.StartAngle
                                                  EndAngle:self.EndAngle];
            }
            break;
        }
    }
    CGContextRestoreGState(ctx);
}
/**
 *  Draw unfilled line from left edge of handle to right edge of handle
 *  This is to ensure that the filled portion of the line doesn't show inside the double Arc
 *  @param ctx Graphics Context within which to draw unfilled line behind handle
 */
-(void) drawUnfilledLineBehindDoubleArcHandle:(CGContextRef)ctx
{
    CGFloat degreesToHandleCenter   = self.angleFromNorth;
    // To determine where handle intersects the filledArc, make approximation that arcLength ~ radius of handle outer Arc.
    // This is a fine approximation whenever self.radius is sufficiently large (which it must be for this control to be usable)
    CGFloat degreesDifference = [JBArcTrig degreesForArcLength:self.radiusForDoubleArcOuterArc
                                                 onArcWithRadius:self.radius EndAngle:_EndAngle];
    CGFloat degreesToHandleLeftEdge  = degreesToHandleCenter - degreesDifference;
    CGFloat degreesToHandleRightEdge = degreesToHandleCenter + degreesDifference;
    
    CGContextSaveGState(ctx);
    [self.unfilledColor set];
    [JBArcTrig drawUnfilledArcInContext:ctx
                                      center:self.centerPoint
                                      radius:self.radius
                                   lineWidth:self.lineWidth
                          fromAngleFromNorth:degreesToHandleLeftEdge
                            toAngleFromNorth:degreesToHandleRightEdge];
    CGContextRestoreGState(ctx);
}

-(void) drawInnerLabels:(CGContextRef)ctx
{
    // Only draw labels if they have been set
    NSInteger labelsCount = self.innerMarkingLabels.count;
    if(labelsCount)
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
        NSDictionary *attributes = @{ NSFontAttributeName: self.labelFont,
                                      NSForegroundColorAttributeName: self.labelColor};
#endif
        for (int i = 0; i < labelsCount; i++)
        {
            // Enumerate through labels clockwise
            NSString* label = self.innerMarkingLabels[i];
            
            CGRect labelFrame = [self contextCoordinatesForLabelAtIndex:i];
            
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
            [label drawInRect:labelFrame withAttributes:attributes];
#else
            [self.labelColor setFill];
            [label drawInRect:labelFrame withFont:self.labelFont];
#endif
        }
    }
}

-(CGRect)contextCoordinatesForLabelAtIndex:(NSInteger)index
{
    NSString *label = self.innerMarkingLabels[index];

    // Determine how many degrees around the full Arc this label should go
    CGFloat percentageAlongArc    = (index) / ((float)self.innerMarkingLabels.count-1);
    CGFloat degreesFromNorthForLabel = _StartAngle+(percentageAlongArc * (_EndAngle - _StartAngle));
    CGPoint pointOnArc = [self pointOnArcAtAngleFromNorth:degreesFromNorthForLabel];
    CGSize  labelSize        = [self sizeOfString:label withFont:self.labelFont];
    CGPoint offsetFromArc = [self offsetFromArcForLabelAtIndex:index withSize:labelSize];
    return CGRectMake(pointOnArc.x + offsetFromArc.x, pointOnArc.y + offsetFromArc.y, labelSize.width, labelSize.height);
//    NSString *label = self.innerMarkingLabels[index];
//
//    // Determine how many degrees around the full Arc this label should go
//    CGFloat percentageAlongArc    = (index + 1) / (float)self.innerMarkingLabels.count;
//    CGFloat degreesFromNorthForLabel = percentageAlongArc * _EndAngle;
//    CGPoint pointOnArc = [self pointOnArcAtAngleFromNorth:degreesFromNorthForLabel];
//    
//    CGSize  labelSize        = [self sizeOfString:label withFont:self.labelFont];
//    CGPoint offsetFromArc = [self offsetFromArcForLabelAtIndex:index withSize:labelSize];
//
//    return CGRectMake(pointOnArc.x + offsetFromArc.x, pointOnArc.y + offsetFromArc.y, labelSize.width, labelSize.height);
}

-(CGPoint) offsetFromArcForLabelAtIndex:(NSInteger)index withSize:(CGSize)labelSize
{
    // Determine how many degrees around the full Arc this label should go
    CGFloat percentageAlongArc    = (index + 1) / (float)self.innerMarkingLabels.count;
    CGFloat degreesFromNorthForLabel = percentageAlongArc * _EndAngle;
    
    CGFloat radialDistance = self.innerLabelRadialDistanceFromCircumference + self.labelDisplacement;
    CGPoint inwardOffset   = [JBArcTrig pointOnRadius:radialDistance
                                            atAngleFromNorth:degreesFromNorthForLabel];
    
    return CGPointMake(-labelSize.width * 0.5 + inwardOffset.x, -labelSize.height * 0.5 + inwardOffset.y);
}

#pragma mark - UIControl functions

-(BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint lastPoint = [touch locationInView:self];
    [self moveHandle:lastPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    if(self.snapToLabels && self.innerMarkingLabels != nil)
    {
        CGPoint bestGuessPoint = CGPointZero;
        float minDist = _EndAngle;
        NSUInteger labelsCount = self.innerMarkingLabels.count;
        for (int i = 0; i < labelsCount; i++)
        {
            CGFloat percentageAlongArc = i/((float)labelsCount-1);
            CGFloat degreesForLabel       =_StartAngle+(percentageAlongArc * (_EndAngle - _StartAngle));
            if(abs(self.angleFromNorth - degreesForLabel) < minDist)
            {
                minDist = abs(self.angleFromNorth - degreesForLabel);
                bestGuessPoint = [self pointOnArcAtAngleFromNorth:degreesForLabel-0.00001];
            }
        }
        self.angleFromNorth = floor([JBArcTrig angleRelativeToNorthFromPoint:self.centerPoint
                                                                             toPoint:bestGuessPoint]);
        if(self.angleFromNorth < self.StartAngle)
        {
            self.angleFromNorth = self.StartAngle+1;
        }
        if(self.angleFromNorth > self.StartAngle  && self.angleFromNorth < self.EndAngle)
        {
            [self setNeedsDisplay];
        }
    }
}

-(void)moveHandle:(CGPoint)point
{
    self.angleFromNorth = floor([JBArcTrig angleRelativeToNorthFromPoint:self.centerPoint
                                                                        toPoint:point]);
    if(self.angleFromNorth > self.StartAngle && self.angleFromNorth < self.EndAngle)
    {
        [self setNeedsDisplay];
    }
}

#pragma mark - Helper functions
- (BOOL) isDoubleArcHandle
{
    return self.handleType == ArcSliderHandleTypeDoubleArcWithClosedCenter || self.handleType == ArcSliderHandleTypeDoubleArcWithOpenCenter;
}

- (CGSize) sizeOfString:(NSString *)string withFont:(UIFont*)font
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[NSAttributedString alloc] initWithString:string attributes:attributes].size;
}

-(CGPoint)pointOnArcAtAngleFromNorth:(int)angleFromNorth
{
    CGPoint offset = [JBArcTrig  pointOnRadius:self.radius atAngleFromNorth:angleFromNorth];
    return CGPointMake(self.centerPoint.x + offset.x, self.centerPoint.y + offset.y);
}

@end
