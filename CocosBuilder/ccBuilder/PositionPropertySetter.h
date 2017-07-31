/*
 * CocosBuilder: http://www.cocosbuilder.com
 *
 * Copyright (c) 2012 Zynga Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum {
    kCCBPositionTypeRelativeBottomLeft,
    kCCBPositionTypeRelativeTopLeft,
    kCCBPositionTypeRelativeTopRight,
    kCCBPositionTypeRelativeBottomRight,
    kCCBPositionTypePercent,
    kCCBPositionTypeMultiplyResolution,
};

enum {
    kCCBSizeTypeAbsolute,
    kCCBSizeTypePercent,
    kCCBSizeTypeRelativeContainer,
    kCCBSizeTypeHorizontalPercent,
    kCCBSzieTypeVerticalPercent,
    kCCBSizeTypeMultiplyResolution,
};

enum { kCCBScaleTypeAbsolute, kCCBScaleTypeMultiplyResolution };

@interface PositionPropertySetter : NSObject

+ (cocos2d::Size)getParentSize:(cocos2d::Node*)node;

// Setting/getting positions
+ (void)setPosition:(NSPoint)pos
               type:(int)type
            forNode:(cocos2d::Node*)node
               prop:(NSString*)prop;

+ (void)setPosition:(NSPoint)pos
               type:(int)type
            forNode:(cocos2d::Node*)node
               prop:(NSString*)prop
         parentSize:(CGSize)parentSize;

+ (void)setPosition:(NSPoint)pos
            forNode:(cocos2d::Node*)node
               prop:(NSString*)prop;

+ (void)setPositionType:(int)type
                forNode:(cocos2d::Node*)node
                   prop:(NSString*)prop;

+ (NSPoint)positionForNode:(cocos2d::Node*)node prop:(NSString*)prop;

+ (int)positionTypeForNode:(cocos2d::Node*)node prop:(NSString*)prop;

+ (void)addPositionKeyframeForNode:(cocos2d::Node*)node;

// Positioning helpers
+ (NSPoint)calcAbsolutePositionFromRelative:(NSPoint)pos
                                       type:(int)type
                                 parentSize:(CGSize)parentSize;
+ (NSPoint)calcRelativePositionFromAbsolute:(NSPoint)pos
                                       type:(int)type
                                 parentSize:(CGSize)parentSize;
+ (NSPoint)convertPosition:(NSPoint)pos
                  fromType:(int)fromType
                    toType:(int)toType
                   forNode:(cocos2d::Node*)node;

// Setting/getting sizes
+ (void)setSize:(NSSize)size
           type:(int)type
        forNode:(cocos2d::Node*)node
           prop:(NSString*)prop;

+ (void)setSize:(NSSize)size
           type:(int)type
        forNode:(cocos2d::Node*)node
           prop:(NSString*)prop
     parentSize:(CGSize)parentSize;

+ (void)setSize:(NSSize)size forNode:(cocos2d::Node*)node prop:(NSString*)prop;

+ (NSSize)sizeForNode:(cocos2d::Node*)node prop:(NSString*)prop;

+ (int)sizeTypeForNode:(cocos2d::Node*)node prop:(NSString*)prop;

+ (void)setSizeType:(int)type forNode:(cocos2d::Node*)node prop:(NSString*)prop;

+ (void)refreshSizeForNode:(cocos2d::Node*)node prop:(NSString*)prop;

// Setting/getting scale
+ (void)setScaledX:(float)scaleX
                 Y:(float)scaleY
              type:(int)type
           forNode:(cocos2d::Node*)node
              prop:(NSString*)prop;

+ (float)scaleXForNode:(cocos2d::Node*)node prop:(NSString*)prop;

+ (float)scaleYForNode:(cocos2d::Node*)node prop:(NSString*)prop;

+ (int)scaledFloatTypeForNode:(cocos2d::Node*)node prop:(NSString*)prop;

+ (void)setFloatScale:(float)f
                 type:(int)type
              forNode:(cocos2d::Node*)node
                 prop:(NSString*)prop;

+ (float)floatScaleForNode:(cocos2d::Node*)node prop:(NSString*)prop;

+ (int)floatScaleTypeForNode:(cocos2d::Node*)node prop:(NSString*)prop;

// Refreshing positions
+ (void)refreshPositionsForChildren:(cocos2d::Node*)node;

+ (void)refreshAllPositions;

@end
