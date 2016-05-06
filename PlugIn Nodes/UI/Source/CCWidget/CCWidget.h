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

#import "CCNode.h"

@interface CCWidget : CCNode {
    CGSize customSize_;
}

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) BOOL bright;
@property (nonatomic, assign) BOOL ignoreContentAdaptWithSize;
@property (nonatomic, assign) BOOL touchEnabled;
@property (nonatomic, assign) BOOL swallowTouches;
@property (nonatomic, assign) BOOL propagateTouchEvents;

//@property (nonatomic, assign) CGSize sizePercent;

@property (nonatomic, readonly) CGSize customSize;

- (CCWidget*) getWidgetParent;

- (void) initRenderer;

- (void) updateSizeAndPosition;
- (void) updateSizeAndPositionWithParentSize:(CGSize) parentSize;

- (void) adaptRenderers;

- (void) updateContentSizeWithTextureSize:(CGSize) size;
- (void) onSizeChanged;

@property (nonatomic, readonly) CGSize virtualRendererSize;

@end
