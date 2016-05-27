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

#import "CCButton.h"
#import "CCScale9Sprite.h"
#import "cocos2d.h"

const NSInteger BackgroundSpriteZOrder = -2;
const NSInteger TitleZOrder = -1;

@implementation CCButton

- (void) dealloc {
    [buttonRenderers_ release];
    [buttonRenderersEnabled_ release];
    
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    prevIgnoreSize_ = NO;
    
    [self createTitleRenderer];
    
    [self setScale9Enabled:YES];
    
    return self;
}

- (void) initRenderer {
    buttonRenderers_ = [NSMutableDictionary dictionary];
    buttonRenderersEnabled_ = [NSMutableDictionary dictionary];
    
    [buttonRenderers_ retain];
    [buttonRenderersEnabled_ retain];
}

- (void) createTitleRenderer {
    titleRenderer_ = [CCLabelTTF labelWithString:@"Title"
                                        fontName:@"Helvetica"
                                        fontSize:12];
    [titleRenderer_ setAnchorPoint:CGPointMake(0.5, 0.5)];
    [self addChild:titleRenderer_ z:TitleZOrder];
}

//- (void) loadTextureNormal {
//    if ([self ignoreContentAdaptWithSize] == NO &&
//        CGSizeEqualToSize([self customSize], CGSizeZero)) {
//        customSize_ = [[buttonRenderers_ objectForKey:CCButtonStateNormal] contentSize];
//    }
//    [self setupNormalTexture];
//}
//
//- (void) setupNormalTexture {
//    
//}

- (void) updateTitleLocation {
    CGFloat width = [self contentSize].width;
    CGFloat height = [self contentSize].height;
    [titleRenderer_ setPosition:CGPointMake(width / 2, height / 2)];
}

- (void) onSizeChanged {
    [super onSizeChanged];
    [self updateTitleLocation];
}

- (void) setContentSize:(CGSize) contentSize {
    [super setContentSize:contentSize];
    
    for (CCScale9Sprite* sprite in [buttonRenderers_ allValues]) {
        [sprite setPreferedSize:contentSize];
    }
}

- (void) setTitleText:(NSString*) text {
//    if ([text isEqualToString:[titleRenderer_ string]]) {
//        return;
//    }
    [titleRenderer_ setString:text];
    [self updateTitleLocation];
}

- (NSString*) titleText {
    return [titleRenderer_ string];
}

- (void) setTitleColor:(ccColor3B) color {
    [titleRenderer_ setColor:color];
}

- (ccColor3B) titleColor {
    return [titleRenderer_ color];
}

- (void) setTitleFontSize:(CGFloat) size {
    [titleRenderer_ setFontSize:size];
}

- (CGFloat) titleFontSize {
    return [titleRenderer_ fontSize];
}

- (void) setTitleFontName:(NSString*) fontName {
    if ([fontName length] > 0) {
        [titleRenderer_ setFontName:fontName];
    }
}

- (NSString*) titleFontName {
    return [titleRenderer_ fontName];
}

- (void) setIgnoreContentAdaptWithSize:(BOOL) ignore {
    if ([self scale9Enabled] == NO || ([self scale9Enabled] && ignore == NO)) {
        [super setIgnoreContentAdaptWithSize:ignore];
        prevIgnoreSize_ = ignore;
    }
}

- (void) setScale9Enabled:(BOOL) enabled {
    _scale9Enabled = enabled;
    if (_scale9Enabled) {
        BOOL ignoreBefore = [self ignoreContentAdaptWithSize];
        [self setIgnoreContentAdaptWithSize:NO];
        prevIgnoreSize_ = ignoreBefore;
    } else {
        [self setIgnoreContentAdaptWithSize:prevIgnoreSize_];
    }
    [self setBright:[self bright]];
}

- (void) setBackgroundSpriteEnabled:(BOOL) enabled
                           forState:(CCButtonState) state {
    [buttonRenderersEnabled_ setObject:[NSNumber numberWithBool:enabled]
                                forKey:[NSNumber numberWithInteger:state]];
    [[self backgroundSpriteForState:state] setVisible:enabled];
}

- (BOOL) backgroundSpriteEnabledForState:(CCButtonState) state {
    BOOL enabled = [[buttonRenderersEnabled_ objectForKey:[NSNumber numberWithInteger:state]] boolValue];
    return enabled;
}

- (void) setBackgroundSprite:(CCScale9Sprite*) sprite
                    forState:(CCButtonState) state {
    if ([self backgroundSpriteEnabledForState:state] == NO) {
        // Not enabled.
        return;
    }
    
    CCScale9Sprite* current = [self backgroundSpriteForState:state];
    [self removeChild:current];
    
    [sprite setVisible:[self backgroundSpriteEnabledForState:state]];
    [sprite setPreferedSize:[self contentSize]];
    [sprite setAnchorPoint:CGPointZero];
    
    // Normal background sprite has the highest z-order,
    // then pressed background sprite.
    NSInteger zOrder = BackgroundSpriteZOrder;
    if (state == CCButtonStatePressed) {
        zOrder -= 1;
    }
    if (state == CCButtonStateDisabled) {
        zOrder -= 2;
    }
    
    [self addChild:sprite z:zOrder];
    [buttonRenderers_ setObject:sprite
                         forKey:[NSNumber numberWithInteger:state]];
}

- (void) setBackgroundSpriteFrame:(CCSpriteFrame*) spriteFrame
                         forState:(CCButtonState) state {
    if ([self backgroundSpriteEnabledForState:state]) {
        CCScale9Sprite* sprite = [CCScale9Sprite spriteWithSpriteFrame:spriteFrame];
        [self setBackgroundSprite:sprite forState:state];
    }
}

- (CCScale9Sprite*) backgroundSpriteForState:(CCButtonState) state {
    CCScale9Sprite* sprite = [buttonRenderers_ objectForKey:[NSNumber numberWithInteger:state]];
    return sprite;
}

- (void) setValue:(id) value forUndefinedKey:(NSString*) key {
    if ([key isEqualToString:@"normalSpriteFrame"]) {
        return [self setBackgroundSpriteFrame:value forState:CCButtonStateNormal];
    }
    if ([key isEqualToString:@"pressedSpriteFrame"]) {
        return [self setBackgroundSpriteFrame:value forState:CCButtonStatePressed];
    }
    if ([key isEqualToString:@"disabledSpriteFrame"]) {
        return [self setBackgroundSpriteFrame:value forState:CCButtonStateDisabled];
    }
    if ([key isEqualToString:@"normalSpriteFrameEnabled"]) {
        return [self setBackgroundSpriteEnabled:[value boolValue]
                                       forState:CCButtonStateNormal];
    }
    if ([key isEqualToString:@"pressedSpriteFrameEnabled"]) {
        return [self setBackgroundSpriteEnabled:[value boolValue]
                                       forState:CCButtonStatePressed];
    }
    if ([key isEqualToString:@"disabledSpriteFrameEnabled"]) {
        return [self setBackgroundSpriteEnabled:[value boolValue]
                                       forState:CCButtonStateDisabled];
    }
    
    [super setValue:value forUndefinedKey:key];
}

- (id) valueForUndefinedKey:(NSString*) key {
    if ([key isEqualToString:@"normalSpriteFrameEnabled"]) {
        return [NSNumber numberWithBool:[self backgroundSpriteEnabledForState:CCButtonStateNormal]];
    }
    if ([key isEqualToString:@"pressedSpriteFrameEnabled"]) {
        return [NSNumber numberWithBool:[self backgroundSpriteEnabledForState:CCButtonStatePressed]];
    }
    if ([key isEqualToString:@"disabledSpriteFrameEnabled"]) {
        return [NSNumber numberWithBool:[self backgroundSpriteEnabledForState:CCButtonStateDisabled]];
    }
    
    return [super valueForUndefinedKey:key];
}

@end
