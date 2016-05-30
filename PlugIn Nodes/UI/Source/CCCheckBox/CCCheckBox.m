//
//  CCCheckBox.m
//  UI
//
//  Created by Zinge on 5/27/16.
//
//

#import "CCCheckBox.h"

#import "cocos2d.h"

const int kBackgroundLocalZOrder = -2;
const int kCrossLocalZOrder = -1;

@implementation CCCheckBox

- (id) init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self setSelected:NO];
    
    return self;
}

- (void) dealloc {
    [backgroundRenderers_ release];
    [backgroundRenderersEnabled_ release];
    [backgroundRenderersAdaptDirty_ release];
    
    [crossRenderers_ release];
    [crossRenderersEnabled_ release];
    [crossRenderersAdaptDirty_ release];
    
    [super dealloc];
}

- (void) initRenderer {
    backgroundRenderers_ = [[NSMutableDictionary alloc] init];
    backgroundRenderersEnabled_ = [[NSMutableDictionary alloc] init];
    backgroundRenderersAdaptDirty_ = [[NSMutableDictionary alloc] init];
    
    [backgroundRenderersAdaptDirty_ setObject:@(YES) forKey:@(CCCheckBoxBackgroundStateNormal)];
    [backgroundRenderersAdaptDirty_ setObject:@(YES) forKey:@(CCCheckBoxBackgroundStatePressed)];
    [backgroundRenderersAdaptDirty_ setObject:@(YES) forKey:@(CCCheckBoxBackgroundStateDisabled)];
    
    crossRenderers_ = [[NSMutableDictionary alloc] init];
    crossRenderersEnabled_ = [[NSMutableDictionary alloc] init];
    crossRenderersAdaptDirty_ = [[NSMutableDictionary alloc] init];
    
    [crossRenderersAdaptDirty_ setObject:@(YES) forKey:@(CCCheckBoxCrossStateNormal)];
    [crossRenderersAdaptDirty_ setObject:@(YES) forKey:@(CCCheckBoxCrossStateDisabled)];
}

- (void) setEnabled:(BOOL) enabled {
    [super setEnabled:enabled];
    
    [self updateCrossSpriteFrameVisibility];
    [self updateBackgroundSpriteFrameVisibility];
}

- (void) setSelected:(BOOL) selected {
    _selected = selected;
    [[self crossSpriteForState:CCCheckBoxCrossStateNormal] setVisible:selected];
}

- (BOOL) normalBackgroundSpriteFrameEnabled {
    return [self backgroundSpriteEnabledForState:CCCheckBoxBackgroundStateNormal];
}

- (BOOL) pressedBackgroundSpriteFrameEnabled {
    return [self backgroundSpriteEnabledForState:CCCheckBoxBackgroundStatePressed];
}

- (BOOL) disabledBackgroundSpriteFrameEnabled {
    return [self backgroundSpriteEnabledForState:CCCheckBoxBackgroundStateDisabled];
}

- (void) setNormalBackgroundSpriteFrameEnabled:(BOOL) enabled {
    return [self setBackgroundSpriteEnabled:enabled
                                   forState:CCCheckBoxBackgroundStateNormal];
}

- (void) setPressedBackgroundSpriteFrameEnabled:(BOOL) enabled {
    return [self setBackgroundSpriteEnabled:enabled
                                   forState:CCCheckBoxBackgroundStatePressed];
}

- (void) setDisabledBackgroundSpriteFrameEnabled:(BOOL) enabled {
    return [self setBackgroundSpriteEnabled:enabled
                                   forState:CCCheckBoxBackgroundStateDisabled];
}

- (void) setBackgroundSpriteEnabled:(BOOL) enabled
                           forState:(CCCheckBoxBackgroundState) state {
    [backgroundRenderersEnabled_ setObject:@(enabled)
                                    forKey:@(state)];
    [self updateBackgroundSpriteFrameVisibilityForState:state];
}

- (BOOL) backgroundSpriteEnabledForState:(CCCheckBoxBackgroundState) state {
    return [[backgroundRenderersEnabled_ objectForKey:@(state)] boolValue];
}

- (void) setBackgroundSprite:(CCSprite*) sprite
                    forState:(CCCheckBoxBackgroundState) state {
    CCSprite* current = [self backgroundSpriteForState:state];
    [self removeChild:current];
    
    [self addChild:sprite z:kBackgroundLocalZOrder];
    
    if (state == CCCheckBoxBackgroundStateNormal) {
        [self updateContentSizeWithTextureSize:[sprite contentSize]];
    }
    
    [backgroundRenderers_ setObject:sprite forKey:@(state)];
    [backgroundRenderersAdaptDirty_ setObject:@(YES) forKey:@(state)];
    
    [self updateChildrenDisplayRGBA];
    [self updateBackgroundSpriteFrameVisibilityForState:state];
}

- (void) setBackgroundSpriteFrame:(CCSpriteFrame*) spriteFrame
                         forState:(CCCheckBoxBackgroundState) state {
    CCSprite* sprite = [CCSprite spriteWithSpriteFrame:spriteFrame];
    [self setBackgroundSprite:sprite forState:state];
}

- (CCSprite*) backgroundSpriteForState:(CCCheckBoxBackgroundState) state {
    return [backgroundRenderers_ objectForKey:@(state)];
}

- (void) updateBackgroundSpriteFrameVisibility {
    [self updateBackgroundSpriteFrameVisibilityForState:CCCheckBoxBackgroundStateNormal];
    [self updateBackgroundSpriteFrameVisibilityForState:CCCheckBoxBackgroundStatePressed];
    [self updateBackgroundSpriteFrameVisibilityForState:CCCheckBoxBackgroundStateDisabled];
}

- (void) updateBackgroundSpriteFrameVisibilityForState:(CCCheckBoxBackgroundState) state {
    BOOL enabled = [self backgroundSpriteEnabledForState:state];
    CCSprite* sprite = [self backgroundSpriteForState:state];
    if (state == CCCheckBoxBackgroundStateNormal) {
        [sprite setVisible:[self enabled] && enabled];
    } else if (state == CCCheckBoxBackgroundStatePressed) {
        [sprite setVisible:enabled];
    } else {
        [sprite setVisible:[self enabled] == NO && enabled];
    }
}

- (BOOL) normalCrossSpriteFrameEnabled {
    return [self crossSpriteEnabledForState:CCCheckBoxCrossStateNormal];
}

- (BOOL) disabledCrossSpriteFrameEnabled {
    return [self crossSpriteEnabledForState:CCCheckBoxCrossStateDisabled];
}

- (void) setNormalCrossSpriteFrameEnabled:(BOOL) enabled {
    [self setCrossSpriteFrameEnabled:enabled
                            forState:CCCheckBoxCrossStateNormal];
}

- (void) setDisabledCrossSpriteFrameEnabled:(BOOL) enabled {
    [self setCrossSpriteFrameEnabled:enabled
                            forState:CCCheckBoxCrossStateDisabled];
}

- (void) setCrossSpriteFrameEnabled:(BOOL) enabled
                           forState:(CCCheckBoxCrossState) state {
    [crossRenderersEnabled_ setObject:@(enabled) forKey:@(state)];
    [self updateCrossSpriteFrameVisibilityForState:state];
}

- (BOOL) crossSpriteEnabledForState:(CCCheckBoxCrossState) state {
    return [[crossRenderersEnabled_ objectForKey:@(state)] boolValue];
}

- (void) setCrossSprite:(CCSprite*) sprite
               forState:(CCCheckBoxCrossState) state {
    CCSprite* current = [self crossSpriteForState:state];
    [self removeChild:current];
    
    [self addChild:sprite z:kCrossLocalZOrder];
    
    [crossRenderers_ setObject:sprite forKey:@(state)];
    [crossRenderersAdaptDirty_ setObject:@(YES) forKey:@(state)];
    
    [self updateChildrenDisplayRGBA];
    [self updateCrossSpriteFrameVisibilityForState:state];
}

- (void) setCrossSpriteFrame:(CCSpriteFrame*) spriteFrame
                    forState:(CCCheckBoxCrossState) state {
    CCSprite* sprite = [CCSprite spriteWithSpriteFrame:spriteFrame];
    [self setCrossSprite:sprite forState:state];
}

- (CCSprite*) crossSpriteForState:(CCCheckBoxCrossState) state {
    return [crossRenderers_ objectForKey:@(state)];
}

- (void) updateCrossSpriteFrameVisibility {
    [self updateCrossSpriteFrameVisibilityForState:CCCheckBoxCrossStateNormal];
    [self updateCrossSpriteFrameVisibilityForState:CCCheckBoxCrossStateDisabled];
}

- (void) updateCrossSpriteFrameVisibilityForState:(CCCheckBoxCrossState) state {
    BOOL enabled = [self crossSpriteEnabledForState:state];
    CCSprite* sprite = [self crossSpriteForState:state];
    if (state == CCCheckBoxCrossStateNormal) {
        [sprite setVisible:[self enabled] && [self selected] && enabled];
    } else {
        [sprite setVisible:[self enabled] == NO && enabled];
    }
}

- (void) onSizeChanged {
    [super onSizeChanged];
    
    for (NSNumber* key in [backgroundRenderersAdaptDirty_ allKeys]) {
        [backgroundRenderersAdaptDirty_ setObject:@(YES) forKey:key];
    }
    
    for (NSNumber* key in [crossRenderersAdaptDirty_ allKeys]) {
        [crossRenderersAdaptDirty_ setObject:@(YES) forKey:key];
    }
}

- (void) adaptRenderers {
    [self updateBackgroundTextureForState:CCCheckBoxBackgroundStateNormal];
    [self updateBackgroundTextureForState:CCCheckBoxBackgroundStatePressed];
    [self updateCrossTextureForState:CCCheckBoxCrossStateNormal];
    [self updateBackgroundTextureForState:CCCheckBoxBackgroundStateDisabled];
    [self updateCrossTextureForState:CCCheckBoxCrossStateDisabled];
}

- (void) updateBackgroundTextureForState:(CCCheckBoxBackgroundState) state {
    if ([[backgroundRenderersAdaptDirty_ objectForKey:@(state)] boolValue]) {
        [self textureScaleChangedWithSize:[backgroundRenderers_ objectForKey:@(state)]];
        [backgroundRenderersAdaptDirty_ setObject:@(NO) forKey:@(state)];
    }
}

- (void) updateCrossTextureForState:(CCCheckBoxCrossState) state {
    if ([[crossRenderersAdaptDirty_ objectForKey:@(state)] boolValue]) {
        [self textureScaleChangedWithSize:[crossRenderers_ objectForKey:@(state)]];
        [crossRenderersAdaptDirty_ setObject:@(NO) forKey:@(state)];
    }
}

- (CGSize) virtualRendererSize {
    return [[self backgroundSpriteForState:CCCheckBoxBackgroundStateNormal] contentSize];
}

- (void) textureScaleChangedWithSize:(CCSprite*) sprite {
    if ([self ignoreContentAdaptWithSize]) {
        [sprite setScale:1.0];
    } else {
        CGSize textureSize = [sprite contentSize];
        if (textureSize.width <= 0 || textureSize.height <= 0) {
            return [sprite setScale:1.0];
        }
        CGFloat scaleX = [self contentSize].width / textureSize.width;
        CGFloat scaleY = [self contentSize].height / textureSize.height;
        [sprite setScaleX:scaleX];
        [sprite setScaleY:scaleY];
    }
    [sprite setPosition:CGPointMake([self contentSize].width / 2,
                                    [self contentSize].height / 2)];
}

- (void) setValue:(id) value forUndefinedKey:(NSString*) key {
    if ([key isEqualToString:@"normalBackgroundSpriteFrame"]) {
        return [self setBackgroundSpriteFrame:value
                                     forState:CCCheckBoxBackgroundStateNormal];
    }
    if ([key isEqualToString:@"pressedBackgroundSpriteFrame"]) {
        return [self setBackgroundSpriteFrame:value
                                     forState:CCCheckBoxBackgroundStatePressed];
    }
    if ([key isEqualToString:@"disabledBackgroundSpriteFrame"]) {
        return [self setBackgroundSpriteFrame:value
                                     forState:CCCheckBoxBackgroundStateDisabled];
    }
    if ([key isEqualToString:@"normalCrossSpriteFrame"]) {
        return [self setCrossSpriteFrame:value
                                forState:CCCheckBoxCrossStateNormal];
    }
    if ([key isEqualToString:@"disabledCrossSpriteFrame"]) {
        return [self setCrossSpriteFrame:value
                                forState:CCCheckBoxCrossStateDisabled];
    }
    [super setValue:value forUndefinedKey:key];
}

@end