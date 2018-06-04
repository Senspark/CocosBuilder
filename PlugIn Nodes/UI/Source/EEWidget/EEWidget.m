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

#import "CCActionInstant.h"
#import "EEWidget.h"

#import <PositionPropertySetter.h>

@implementation EEWidget {
    CCWidget* container_;
    NSInteger insetLeft_;
    NSInteger insetTop_;
    NSInteger insetRight_;
    NSInteger insetBottom_;
}

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    container_ = [[[CCWidget alloc] init] autorelease];
    [container_ setAnchorPoint:CGPointZero];
    [super addChild:container_ z:0 tag:0];
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)onEnter {
    [super onEnter];

    // Force to refresh children position.
    [PositionPropertySetter refreshPositionsForChildren:self];
}

- (void)visit {
    if ([self visible]) {
        [super visit];
    }
}

- (CCNode*)getChildByTag:(NSInteger)tag {
    return [container_ getChildByTag:tag];
}

- (void)addChild:(CCNode*)child z:(NSInteger)z tag:(NSInteger)tag {
    [container_ addChild:child z:z tag:tag];
}

- (void)removeChild:(CCNode*)child cleanup:(BOOL)cleanup {
    [container_ removeChild:child cleanup:cleanup];
}

- (void)removeChildByTag:(NSInteger)tag cleanup:(BOOL)cleanup {
    [container_ removeChildByTag:tag cleanup:cleanup];
}

- (void)removeAllChildrenWithCleanup:(BOOL)cleanup {
    [container_ removeAllChildrenWithCleanup:cleanup];
}

- (CCArray*)children {
    return [container_ children];
}

- (NSInteger)insetLeft {
    return insetLeft_;
}

- (NSInteger)insetTop {
    return insetTop_;
}

- (NSInteger)insetRight {
    return insetRight_;
}

- (NSInteger)insetBottom {
    return insetBottom_;
}

- (void)setInsetLeft:(NSInteger)inset {
    insetLeft_ = inset;
    [self _updateInset:[self contentSize]];
}

- (void)setInsetTop:(NSInteger)inset {
    insetTop_ = inset;
    [self _updateInset:[self contentSize]];
}

- (void)setInsetRight:(NSInteger)inset {
    insetRight_ = inset;
    [self _updateInset:[self contentSize]];
}

- (void)setInsetBottom:(NSInteger)inset {
    insetBottom_ = inset;
    [self _updateInset:[self contentSize]];
}

- (void)setContentSize:(CGSize)contentSize {
    [self _updateInset:contentSize];
    [super setContentSize:contentSize];
}

- (void)_updateInset:(CGSize)parentSize {
    CGPoint position = CGPointMake([self insetLeft], [self insetBottom]);
    [container_ setPosition:position];

    CGSize size = CGSizeMake(
        MAX(0, parentSize.width - [self insetLeft] - [self insetRight]),
        MAX(0, parentSize.height - [self insetTop] - [self insetBottom]));
    [container_ setContentSize:size];
}

- (void)onSizeChanged {
    [self _updateInset:_contentSize];
    [super onSizeChanged];
}

@end
