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

#import "CCClippingRectangleNode.h"

@implementation CCClippingRectangleNode

- (void)dealloc {
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    return self;
}

- (void)visit {
    // http://stackoverflow.com/questions/14645266/glscissor-call-inside-another-glscissor
    GLint previousScissorRect[4];
    bool scissorEnabled = glIsEnabled(GL_SCISSOR_TEST);
    glGetIntegerv(GL_SCISSOR_BOX, previousScissorRect);

    if ([self clippingEnabled]) {
        if (scissorEnabled == NO) {
            glEnable(GL_SCISSOR_TEST);
        }
        float scaleX = [self scaleX];
        float scaleY = [self scaleY];
        CCNode* parent = [self parent];
        while (parent != nil) {
            scaleX *= [parent scaleX];
            scaleY *= [parent scaleY];
            parent = [parent parent];
        }
        CGRect clippingRegion = CGRectMake(0, 0, [self contentSize].width,
                                           [self contentSize].height);

        CGPoint position = [self convertToWorldSpace:clippingRegion.origin];
        glScissor((GLint)(position.x), (GLint)(position.y),
                  (GLsizei)(clippingRegion.size.width * scaleX),
                  (GLsizei)(clippingRegion.size.height * scaleY));
    }

    [super visit];

    if ([self clippingEnabled]) {
        if (scissorEnabled) {
            glScissor(previousScissorRect[0], previousScissorRect[1],
                      previousScissorRect[2], previousScissorRect[3]);
        } else {
            glDisable(GL_SCISSOR_TEST);
        }
    }
}

@end
