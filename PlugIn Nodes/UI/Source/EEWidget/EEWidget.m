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
    BOOL magic_;
    BOOL insetDirty_;
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
    magic_ = NO;
    insetDirty_ = NO;
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
}

- (void)visit {
    if ([self visible]) {
        if (insetDirty_) {
            insetDirty_ = NO;
            [self _updateInset];
        }
        [super visit];
    }
}

- (CGSize)contentSize {
    if (magic_) {
        return [container_ contentSize];
    }
    return [super contentSize];
}

- (CCNode*)getChildByTag:(NSInteger)tag {
    return [container_ getChildByTag:tag];
}

- (void)addChild:(CCNode*)child z:(NSInteger)z tag:(NSInteger)tag {
    [container_ addChild:child z:z tag:tag];
}

- (void)removeChild:(CCNode*)child cleanup:(BOOL)cleanup {
    if (child == container_) {
        [super removeChild:child cleanup:cleanup];
    } else {
        [container_ removeChild:child cleanup:cleanup];
    }
}

- (void)removeChildByTag:(NSInteger)tag cleanup:(BOOL)cleanup {
    [container_ removeChildByTag:tag cleanup:cleanup];
}

- (void)removeAllChildrenWithCleanup:(BOOL)cleanup {
    [super removeAllChildrenWithCleanup:cleanup];
    // [container_ removeAllChildrenWithCleanup:cleanup];
}

- (void)sortAllChildren {
    [super sortAllChildren];
    [container_ sortAllChildren];
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
    insetDirty_ = YES;
}

- (void)setInsetTop:(NSInteger)inset {
    insetTop_ = inset;
    insetDirty_ = YES;
}

- (void)setInsetRight:(NSInteger)inset {
    insetRight_ = inset;
    insetDirty_ = YES;
}

- (void)setInsetBottom:(NSInteger)inset {
    insetBottom_ = inset;
    insetDirty_ = YES;
}

- (void)_updateInset {
    CGPoint position = CGPointMake([self insetLeft], [self insetBottom]);
    [container_ setPosition:position];

    CGSize parentSize = [self contentSize];
    CGSize size = CGSizeMake(
        MAX(0, parentSize.width - [self insetLeft] - [self insetRight]),
        MAX(0, parentSize.height - [self insetTop] - [self insetBottom]));
    [container_ setContentSize:size];

    [self _alignChildren];
}

- (void)onSizeChanged {
    [super onSizeChanged];
    insetDirty_ = YES;
}

- (void)_alignChildren {
    magic_ = YES;
    [PositionPropertySetter refreshPositionsForChildren:self];
    magic_ = NO;
}

@end
