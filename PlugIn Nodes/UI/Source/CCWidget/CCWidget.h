/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2013 Apportable Inc.
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

#import "CCNodeV3.h"

typedef NS_ENUM(NSInteger, CCWidgetPositionType) {
    CCWidgetPositionTypeAbsolute,
    CCWidgetPositionTypePercent
};

typedef NS_ENUM(NSInteger, CCWidgetSizeType) {
    CCWidgetSizeTypeAbsolute,
    CCWidgetSizeTypePercent
};

typedef NS_ENUM(NSInteger, CCWidgetBrightStyle) {
    CCWidgetBrightStyleNone = -1,
    CCWidgetBrightStyleNormal,
    CCWidgetBrightStyleHighlight
};

@interface CCWidget : CCNodeV3 {
    CGSize customSize_;
    CCWidgetBrightStyle brightStyle_;
}

@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL highlighted;
@property (nonatomic) BOOL bright;
@property (nonatomic) BOOL ignoreContentAdaptWithSize;
@property (nonatomic) BOOL touchEnabled;
@property (nonatomic) BOOL swallowTouches;
@property (nonatomic) BOOL propagateTouchEvents;
@property (nonatomic) BOOL unifySizeEnabled;
@property (nonatomic) BOOL layoutComponentEnabled;

@property (nonatomic) CGPoint sizePercent;
@property (nonatomic) CCWidgetSizeType sizeType;

@property (nonatomic) CGPoint positionPercent;
@property (nonatomic) CCWidgetPositionType positionType;

@property (nonatomic, readonly) CGSize customSize;

@property (nonatomic, readonly) CCNode* virtualRenderer;
@property (nonatomic, readonly) CGSize virtualRendererSize;

- (CCWidget*) getWidgetParent;

- (void) setBrightStyle:(CCWidgetBrightStyle) style;

- (void) updateSizeAndPosition;
- (void) updateSizeAndPositionWithParentSize:(CGSize) parentSize;

- (void) updateContentSizeWithTextureSize:(CGSize) size;

- (void) onSizeChanged;

- (void) onPressStateChangedToNormal;
- (void) onPressStateChangedToPressed;
- (void) onPressStateChangedToDisabled;

- (void) initRenderer;

- (void) adaptRenderers;
- (void) updateChildrenDisplayRGBA;

@end
