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

@synthesize customSize = customSize_;

- (void) dealloc {
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self initRenderer];
    
    [self setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    [self setEnabled:YES];
    [self setBright:YES];
    [self setIgnoreContentAdaptWithSize:YES];
    [self setTouchEnabled:YES];
    [self setHighlighted:NO];
    [self setPropagateTouchEvents:YES];
    [self setSwallowTouches:YES];
    
    return self;
}

- (void) visit {
    if ([self visible]) {
        [self adaptRenderers];
        [super visit];
    }
}

- (CCWidget*) getWidgetParent {
    if ([[self parent] isKindOfClass:[CCWidget class]]) {
        return (CCWidget*) [self parent];
    }
    return nil;
}

- (void) setEnabled:(BOOL) enabled {
    _enabled = enabled;
    [self setBright:enabled];
}

- (void) initRenderer {}

- (void) setContentSize:(CGSize) contentSize {
//    CGSize previousSize = [super contentSize];
//    if (CGSizeEqualToSize(previousSize, contentSize)) {
//        return;
//    }
    [super setContentSize:contentSize];
    
    customSize_ = contentSize;
    if ([self ignoreContentAdaptWithSize]) {
        [super setContentSize:[self virtualRendererSize]];
    } else if ([self isRunning]) {
        // ??? update size percent ???
//        CCWidget* widgetParent = [self getWidgetParent];
//        CGSize pSize;
//        if (widgetParent != nil) {
//            pSize = [widgetParent contentSize];
//        } else {
//            pSize = [[self parent] contentSize];
//        }
//        CGFloat spx = 0;
//        CGFloat spy = 0;
//        if (pSize.width > 0) {
//            spx = customSize_.width / pSize.width;
//        }
//        if (pSize.height > 0) {
//            spy = customSize_.width / pSize.height;
//        }
//        _sizePercent.width = spx;
//        _sizePercent.height = spy;
    }
    [self onSizeChanged];
}

- (void) updateSizeAndPosition {
    CGSize pSize = [[self parent] contentSize];
    [self updateSizeAndPositionWithParentSize:pSize];
}

- (void) updateSizeAndPositionWithParentSize:(CGSize) parentSize {
    if ([self ignoreContentAdaptWithSize]) {
        [self setContentSize:[self virtualRendererSize]];
    } else {
        [self setContentSize:customSize_];
    }
}

- (void) setIgnoreContentAdaptWithSize:(BOOL) ignore {
//    if ([self ignoreContentAdaptWithSize] == ignore) {
//        return;
//    }
    _ignoreContentAdaptWithSize = ignore;
    if (ignore) {
        CGSize s = [self virtualRendererSize];
        [self setContentSize:s];
    } else {
        [self setContentSize:customSize_];
    }
}

- (void) onSizeChanged {}

- (CGSize) virtualRendererSize {
    return [self contentSize];
}

- (void) updateContentSizeWithTextureSize:(CGSize) size {
    if ([self ignoreContentAdaptWithSize]) {
        [self setContentSize:size];
    } else {
        [self setContentSize:customSize_];
    }
}

- (void) adaptRenderers {}

- (void) setValue:(id) value forUndefinedKey:(NSString*) key {
    [super setValue:value forKey:key];
}

- (id) valueForUndefinedKey:(NSString*) key {
    return [super valueForUndefinedKey:key];
}

@end
