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

#import "CCWidget.h"

@implementation CCWidget

@synthesize swallowTouches = swallowTouches_;
@synthesize sizePercent = sizePercent_;
@synthesize positionPercent = positionPercent_;
@synthesize customSize = customSize_;

- (void)dealloc {
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }

    _layoutComponentEnabled = NO;
    _unifySizeEnabled = NO;
    _enabled = YES;
    _bright = YES;
    _touchEnabled = NO;
    _highlighted = NO;
    _ignoreContentAdaptWithSize = NO;
    _propagateTouchEvents = YES;
    brightStyle_ = CCWidgetBrightStyleNone;
    _sizeType = CCWidgetSizeTypeAbsolute;
    _positionType = CCWidgetPositionTypeAbsolute;
    customSize_ = CGSizeZero;

    [self initRenderer];
    [self setBright:YES];
    [self setAnchorPoint:CGPointMake(0.5, 0.5)];
    [self setIgnoreContentAdaptWithSize:YES];

    return self;
}

- (void)onEnter {
    if ([self layoutComponentEnabled] == NO) {
        [self updateSizeAndPosition];
    }
    [super onEnter];
}

- (void)visit {
    if ([self visible]) {
        [self adaptRenderers];
        [super visit];
    }
}

- (CCWidget*)getWidgetParent {
    if ([[self parent] isKindOfClass:[CCWidget class]]) {
        return (CCWidget*)[self parent];
    }
    return nil;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    [self setBright:enabled];
}

- (void)initRenderer {
}

- (void)setContentSize:(CGSize)contentSize {
    CGSize previousSize = [super contentSize];
    if (CGSizeEqualToSize(previousSize, contentSize)) {
        return;
    }
    [super setContentSize:contentSize];

    customSize_ = contentSize;
    if ([self unifySizeEnabled]) {

    } else if ([self ignoreContentAdaptWithSize]) {
        [super setContentSize:[self virtualRendererSize]];
    } else if ([self layoutComponentEnabled] == NO && [self isRunning]) {
        CCWidget* widgetParent = [self getWidgetParent];
        CGSize pSize;
        if (widgetParent != nil) {
            pSize = [widgetParent contentSize];
        } else {
            pSize = [[self parent] contentSize];
        }
        CGFloat spx = 0;
        CGFloat spy = 0;
        if (pSize.width > 0) {
            spx = [self customSize].width / pSize.width;
        }
        if (pSize.height > 0) {
            spy = [self customSize].width / pSize.height;
        }
        sizePercent_.x = spx;
        sizePercent_.y = spy;
    }
    [self onSizeChanged];
}

- (void)setSizePercent:(CGPoint)percent {
    if ([self layoutComponentEnabled]) {
        // Not yet supported.
    } else {
        sizePercent_ = percent;
        CGSize cSize = [self customSize];
        if ([self isRunning]) {
            CCWidget* widgetParent = [self getWidgetParent];
            if (widgetParent != nil) {
                cSize =
                    CGSizeMake([widgetParent contentSize].width * percent.x,
                               [widgetParent contentSize].height * percent.y);
            } else {
                cSize =
                    CGSizeMake([[self parent] contentSize].width * percent.x,
                               [[self parent] contentSize].height * percent.y);
            }
        }
        if ([self ignoreContentAdaptWithSize]) {
            [self setContentSize:[self virtualRendererSize]];
        } else {
            [self setContentSize:cSize];
        }
        customSize_ = cSize;
    }
}

- (void)updateSizeAndPosition {
    CGSize pSize = [[self parent] contentSize];
    [self updateSizeAndPositionWithParentSize:pSize];
}

- (void)updateSizeAndPositionWithParentSize:(CGSize)parentSize {
    // Ignore CCWidgetSizeTypePercent.
    CCWidgetSizeType prevSizeType = [self sizeType];
    [self setSizeType:CCWidgetSizeTypeAbsolute];
    switch ([self sizeType]) {
    case CCWidgetSizeTypeAbsolute: {
        if ([self ignoreContentAdaptWithSize]) {
            [self setContentSize:[self virtualRendererSize]];
        } else {
            [self setContentSize:[self customSize]];
        }
        CGFloat spx = 0;
        CGFloat spy = 0;
        if (parentSize.width > 0) {
            spx = [self customSize].width / parentSize.width;
        }
        if (parentSize.height > 0) {
            spy = [self customSize].height / parentSize.height;
        }
        sizePercent_.x = spx;
        sizePercent_.y = spy;
        break;
    }
    case CCWidgetSizeTypePercent: {
        CGSize cSize = CGSizeMake(parentSize.width * [self sizePercent].x,
                                  parentSize.height * [self sizePercent].y);
        if ([self ignoreContentAdaptWithSize]) {
            [self setContentSize:[self virtualRendererSize]];
        } else {
            [self setContentSize:cSize];
        }
        customSize_ = cSize;
        break;
    }
    }
    [self setSizeType:prevSizeType];
    // Ignore CCWidgetPositionTypePercent.
    CCWidgetPositionType prevPositionType = [self positionType];
    [self setPositionType:CCWidgetPositionTypeAbsolute];
    CGPoint absPos = [self position];
    switch ([self positionType]) {
    case CCWidgetPositionTypeAbsolute: {
        if (parentSize.width <= 0 || parentSize.height <= 0) {
            positionPercent_ = CGPointZero;
        } else {
            positionPercent_ = CGPointMake(absPos.x / parentSize.width,
                                           absPos.y / parentSize.height);
        }
        break;
    }
    case CCWidgetPositionTypePercent: {
        absPos = CGPointMake(parentSize.width * [self positionPercent].x,
                             parentSize.height * [self positionPercent].y);
        break;
    }
    }
    [self setPositionType:prevPositionType];
    [self setPosition:absPos];
}

- (void)setSizeType:(CCWidgetSizeType)type {
    _sizeType = type;
    if ([self layoutComponentEnabled]) {
        // ...
    }
}

- (void)setIgnoreContentAdaptWithSize:(BOOL)ignore {
    if (_unifySizeEnabled) {
        return [self setContentSize:[self customSize]];
    }
    if ([self ignoreContentAdaptWithSize] == ignore) {
        return;
    }
    _ignoreContentAdaptWithSize = ignore;
    if (ignore) {
        CGSize s = [self virtualRendererSize];
        [self setContentSize:s];
    } else {
        [self setContentSize:[self customSize]];
    }
}

- (CGPoint)sizePercent {
    if ([self layoutComponentEnabled]) {
        ///
    }
    return sizePercent_;
}

- (CCNode*)virtualRenderer {
    return self;
}

- (void)onSizeChanged {
    if ([self layoutComponentEnabled] == NO) {
        for (CCNode* child in [self children]) {
            if ([child isKindOfClass:[CCWidget class]]) {
                CCWidget* widgetChild = (CCWidget*)child;
                [widgetChild updateSizeAndPosition];
            }
        }
    }
}

- (CGSize)virtualRendererSize {
    return [self contentSize];
}

- (void)updateContentSizeWithTextureSize:(CGSize)size {
    if ([self unifySizeEnabled]) {
        return [self setContentSize:size];
    }
    if ([self ignoreContentAdaptWithSize]) {
        [self setContentSize:size];
    } else {
        [self setContentSize:[self customSize]];
    }
}

- (void)updateChildrenDisplayRGBA {
    [self setColor:[self color]];
    [self setOpacity:[self opacity]];
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted == [self highlighted]) {
        return;
    }

    _highlighted = highlighted;
    if ([self bright]) {
        if ([self highlighted]) {
            [self setBrightStyle:CCWidgetBrightStyleHighlight];
        } else {
            [self setBrightStyle:CCWidgetBrightStyleNormal];
        }
    } else {
        [self onPressStateChangedToDisabled];
    }
}

- (void)setBright:(BOOL)bright {
    _bright = bright;
    if ([self bright]) {
        brightStyle_ = CCWidgetBrightStyleNone;
        [self setBrightStyle:CCWidgetBrightStyleNormal];
    } else {
        [self onPressStateChangedToDisabled];
    }
}

- (void)setBrightStyle:(CCWidgetBrightStyle)style {
    if (brightStyle_ == style) {
        return;
    }
    brightStyle_ = style;
    switch (brightStyle_) {
    case CCWidgetBrightStyleNormal:
        [self onPressStateChangedToNormal];
        break;
    case CCWidgetBrightStyleHighlight:
        [self onPressStateChangedToPressed];
        break;
    default:
        break;
    }
}

- (void)onPressStateChangedToNormal {
}

- (void)onPressStateChangedToPressed {
}

- (void)onPressStateChangedToDisabled {
}

- (void)setPosition:(CGPoint)position {
    if ([self layoutComponentEnabled] == NO && [self isRunning]) {
        CCWidget* widgetParent = [self getWidgetParent];
        if (widgetParent != nil) {
            CGSize pSize = [widgetParent contentSize];
            if (pSize.width <= 0 || pSize.height <= 0) {
                positionPercent_ = CGPointZero;
            } else {
                positionPercent_ = CGPointMake(position.x / pSize.width,
                                               position.y / pSize.height);
            }
        }
    }
    [super setPosition:position];
}

- (void)setPositionPercent:(CGPoint)percent {
    if ([self layoutComponentEnabled]) {
        ///
    } else {
        positionPercent_ = percent;
        if ([self isRunning]) {
            CCWidget* widgetParent = [self getWidgetParent];
            if (widgetParent != nil) {
                CGSize parentSize = [widgetParent contentSize];
                CGPoint absPos =
                    CGPointMake(parentSize.width * [self positionPercent].x,
                                parentSize.height * [self positionPercent].y);
                [self setPosition:absPos];
            }
        }
    }
}

- (CGPoint)positionPercent {
    if ([self layoutComponentEnabled]) {
        ///
    }
    return positionPercent_;
}

- (void)setPositionType:(CCWidgetPositionType)type {
    _positionType = type;
    if ([self layoutComponentEnabled]) {
        ///
    }
}

- (void)adaptRenderers {
}

- (void)setContentSize_super:(CGSize)size {
    [super setContentSize:size];
}

@end
