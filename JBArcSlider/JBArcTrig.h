//
//  JBArcTrig.h
//  
//
//  Created by Bhavesh Patel on 13/6/16.
//  Copyright (c) 2016 Bhavesh Patel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  Helper class that provides interfaces for calculations involving trigonometry.
 *  Also includes function for drawing arcs.
 */
@interface JBArcTrig : NSObject

/**
 *  Determines the angle between two points on a Arc
 *
 *  @param fromPoint Point on the Arc circumference
 *  @param toPoint   Point on the Arc circumference
 *
 *  @return Angle in degrees between the two points, relative to North as 0 degrees (clockwise)
 */
+(CGFloat) angleRelativeToNorthFromPoint:(CGPoint)fromPoint
                                 toPoint:(CGPoint)toPoint;

/**
 *  Determine the coordinates of a point on a Arc at a given angle
 *
 *  @param radius         Radius of the Arc
 *  @param angleFromNorth Angle from North as 0 degrees (clockwise)
 *
 *  @return Point on the Arc circumference
 */
+(CGPoint)pointOnRadius:(CGFloat)radius
       atAngleFromNorth:(CGFloat)angleFromNorth;

/**
 *  Draw a filled Arc using current context settings
 *
 *  @param ctx    Graphics context within which to fill a Arc
 *  @param center Center of the Arc to draw
 *  @param radius Radius of the Arc to draw
 */
+(void) drawFilledArcInContext:(CGContextRef)ctx
                           center:(CGPoint)center
                           radius:(CGFloat)radius;

/**
 *  Draw an empty Arc with a variable line width using current context settings
 *
 *  @param ctx       Graphics context within which to fill a Arc
 *  @param center    Center of the Arc to draw
 *  @param radius    Radius of the Arc to draw
 *  @param lineWidth Width of line to draw around Arc (centered on radius)
 */
+(void) drawUnfilledArcInContext:(CGContextRef)ctx
                             center:(CGPoint)center
                             radius:(CGFloat)radius
                          lineWidth:(CGFloat)lineWidth
                        StartAngle:(CGFloat)StartAngle
                          EndAngle:(CGFloat)EndAngle;
                            

/**
 *  Draw an unfilled arc (ie partial Arc) with a variable line width using current context settings
 *
 *  @param ctx                Graphics context within which to fill a Arc
 *  @param center             Center of the Arc to draw
 *  @param radius             Radius of the Arc to draw
 *  @param lineWidth          Width of line to draw around Arc (centered on radius)
 *  @param fromAngleFromNorth Angle in degrees to draw arc from (clockwise)
 *  @param toAngleFromNorth   Angle in degrees to draw arc to (clockwise)
 */
+(void) drawUnfilledArcInContext:(CGContextRef)ctx
                          center:(CGPoint)center
                          radius:(CGFloat)radius
                       lineWidth:(CGFloat)lineWidth
              fromAngleFromNorth:(CGFloat)fromAngleFromNorth
                toAngleFromNorth:(CGFloat)toAngleFromNorth;

/**
 *  Calculates how many degrees an arc spans along the circumference of a Arc
 *
 *  @param arcLength Length of arc segment along Arc circumference
 *  @param radius    Radius of Arc whose circumference arc sits upon
 *
 *  @return Degrees from start of arc to end of arc along Arc's circumference
 */
+(CGFloat) degreesForArcLength:(CGFloat)arcLength
            onArcWithRadius:(CGFloat)radius
             EndAngle:(CGFloat)EndAngle;

/**
 *  Given an unfilled arc or Arc, determine width from arc center to outside edge of line
 *
 *  @param radius    Radius of the arc
 *  @param lineWidth Width of line drawn around arc
 *
 *  @return Distance from center to outer edge of unfilled arc
 */
+(CGFloat) outerRadiuOfUnfilledArcWithRadius:(CGFloat)radius
                                   lineWidth:(CGFloat)lineWidth;

/**
 *  Given an unfilled arc or Arc, determine width from arc center to inside edge of line
 *
 *  @param radius    Radius of the arc
 *  @param lineWidth Width of line drawn around arc
 *
 *  @return Distance from center to inner edge of unfilled arc
 */
+(CGFloat)innerRadiusOfUnfilledArcWithRadius:(CGFloat)radius
                                   lineWidth:(CGFloat)lineWidth;

@end
