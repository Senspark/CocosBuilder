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

/// Reference: http://xissburg.com/faster-gaussian-blur-in-glsl/

#import "CCBlurBackground.h"

#import "cocos2d.h"

#include "BlurUtils.h"

@implementation CCBlurBackground

@synthesize renderScale = renderScale_;
@synthesize sigma = sigma_;
@synthesize blurRadius = blurRadius_;

- (void) dealloc {
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    renderScale_ = 1.0;
    sigma_ = 2.0f;
    blurRadius_ = 4;
    rendererDirty_ = YES;
    rendererInitialized_ = NO;
    
    [self scheduleUpdate];
    return self;
}

- (void) updateRenderders {
    if (rendererDirty_) {
        rendererDirty_ = NO;
        [self resetRenderers];
        [self createRenderers];
    }
}

- (void) createRenderers {
    sceneSize_ = [[self rootNode] contentSize];
    
    [self setContentSize:sceneSize_];
    
    CGSize renderSize = CGSizeMake(sceneSize_.width * [self renderScale],
                                   sceneSize_.height * [self renderScale]);
    
    horizontalRenderer_ = [CCRenderTexture renderTextureWithWidth:renderSize.width
                                                           height:renderSize.height];
    
    verticalRenderer_ = [CCRenderTexture renderTextureWithWidth:renderSize.width
                                                         height:renderSize.height];
    
    [self configHorizontalRenderer];
    [self configVerticalRenderer];
    
    [self addChild:horizontalRenderer_ z:-1];
    [self addChild:verticalRenderer_ z:-1];
}

- (void) configHorizontalRenderer {
    [horizontalRenderer_ setVisible:NO];
    
    CCSprite* sprite = [horizontalRenderer_ sprite];
    CCTexture2D* texture = [sprite texture];
    
    CGFloat textureWidth = [texture contentSizeInPixels].width;
    
    [sprite setShaderProgram:createHorizontalBlurProgram(textureWidth,
                                                         (int) [self blurRadius],
                                                         [self sigma])];
    [sprite setAnchorPoint:CGPointMake(0, 1)];
}

- (void) configVerticalRenderer {
    [verticalRenderer_ setScale:1 / [self renderScale]];
    
    CCSprite* sprite = [verticalRenderer_ sprite];
    CCTexture2D* texture = [sprite texture];
    
    if ([self renderScale] < 1.0) {
        [texture setAntiAliasTexParameters];
    } else {
        [texture setAliasTexParameters];
    }
    
    CGFloat textureHeight = [texture contentSizeInPixels].height;
    
    [sprite setShaderProgram:createVerticalBlurProgram(textureHeight,
                                                       (int) [self blurRadius],
                                                       [self sigma])];
    
    [sprite setAnchorPoint:CGPointMake(0, 1)];
}

- (void) resetRenderers {
    if (rendererInitialized_ == NO) {
        return;
    }
    [horizontalRenderer_ removeFromParent];
    [verticalRenderer_ removeFromParent];
    rendererInitialized_ = NO;
}

- (void) updateSceneSize {
    CGSize currentSize = [[self rootNode] contentSize];
    if (CGSizeEqualToSize(currentSize, sceneSize_)) {
        return;
    }
    sceneSize_ = currentSize;
    rendererDirty_ = YES;
}

- (CCNode*) rootNode {
    CCDirector* director = [CCDirector sharedDirector];
    CCScene* runningScene = [director runningScene];
    
    CCLayer* cocosScene = [[runningScene children] objectAtIndex:0];
    CCNode* rootNode = [cocosScene valueForKey:@"rootNode"];
    
    return rootNode;
}

- (void) setRenderScale:(CGFloat) scale {
    if (renderScale_ == scale) {
        return;
    }
    renderScale_ = scale;
    rendererDirty_ = YES;
}

- (void) setSigma:(CGFloat) sigma {
    if (sigma_ == sigma) {
        return;
    }
    sigma_ = sigma;
    rendererDirty_ = YES;
}

- (void) setBlurRadius:(NSInteger) radius {
    // Clamp radius.
    // Maximum the number of varying variables is 32.
    radius = clampf(radius, 1, 6);
    
    if (blurRadius_ == radius) {
        return;
    }
    blurRadius_ = radius;
    rendererDirty_ = YES;
}

- (void) update:(ccTime) delta {
    if ([self visible]) {
        [self updateSceneSize];
        [self updateRenderders];
        
        [self setVisible:NO];
        [horizontalRenderer_ beginWithClear:0 g:0 b:0 a:0];
        
        CCNode* rootNode = [self rootNode];
        
        CGFloat originalScale = [rootNode scale];
        [rootNode setScale:[self renderScale]];
        [rootNode visit];
        [rootNode setScale:originalScale];
        
        [horizontalRenderer_ end];
        [self setVisible:YES];
        
        [verticalRenderer_ beginWithClear:0 g:0 b:0 a:0];
        [[horizontalRenderer_ sprite] visit];
        [verticalRenderer_ end];
    }
}

- (void) visit {
    [super visit];
}

@end
