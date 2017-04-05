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

#import "CCSkeletonAnimation.h"

#import "spine/spine-cocos2d-objc.h"

NSString* const kNoAnimation = @"None";

@implementation CCSkeletonAnimation

@synthesize skeleton = skeleton_;
@synthesize animationList = availableAnimations_;
@synthesize skinList = availableSkins_;

- (void) dealloc {
    
    [availableSkins_ release];
    availableSkins_ = nil;
    
    [availableAnimations_ release];
    availableAnimations_ = nil;
    
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    _animationScale = 1.0;
    _timeScale = 1.0;
    
    _animation = kNoAnimation;
    _skin = nil;
    
    _debugSlotsEnabled = NO;
    _debugBonesEnabled = NO;
    
    return self;
}

- (void) updateSkeleton:(BOOL) cleanUp {
    [self removeChild:skeleton_];
    skeleton_ = nil;
    
    if ([[self dataFile] length] == 0 || [[self atlasFile] length] == 0) {
        return;
    }
    
    @try {
        skeleton_ = [SkeletonAnimation skeletonWithFile:[self dataFile]
                                              atlasFile:[self atlasFile]
                                                  scale:[self animationScale]];
        
        if (skeleton_ == nil) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"Error reading data/atlas files."
                                         userInfo:nil];
        }
        
        // Keep time scale.
        [skeleton_ setTimeScale:[self timeScale]];
        [skeleton_ setDebugBones:[self debugBonesEnabled]];
        [skeleton_ setDebugSlots:[self debugBonesEnabled]];
        
        [self addChild:skeleton_ z:-1];
        
        if (cleanUp) {
            // Update json or atlas.
            // Reload animation and skin names.
            [self updateAvailableAnimations];
            [self updateAvailableSkins];
        } else {
            // Update scale.
            // Keep animation and skin names.
            [skeleton_ setSkin:[self skin]];
            if ([[self animation] isEqualToString:kNoAnimation] == NO) {
                [self restartAnimation];
            }
        }
    } @catch (NSException* ex) {
        NSLog(@"%@", ex);
        
        _animation = kNoAnimation;
        _skin = nil;
        
        [availableSkins_ removeAllObjects];
        [availableAnimations_ removeAllObjects];
    }
}

- (void) updateAnimation {
    if ([[self animation] length] == 0) {
        NSAssert(NO, @"...");
        return;
    }
    
    if ([[self animation] isEqualToString:kNoAnimation]) {
        [self removeChild:skeleton_];
        if ([self dataFile] != nil && [self atlasFile] != nil) {
            skeleton_ =
                [SkeletonAnimation skeletonWithFile:[self dataFile]
                                          atlasFile:[self atlasFile]
                                              scale:[self animationScale]];
            if (skeleton_ != nil) {
                [skeleton_ setDebugBones:[self debugBonesEnabled]];
                [skeleton_ setDebugSlots:[self debugBonesEnabled]];
                [skeleton_ setTimeScale:[self timeScale]];
                [skeleton_ setSkin:[self skin]];
                [self addChild:skeleton_ z:-1];
            }
        }
    } else {
        [self restartAnimation];
    }
}

- (void) restartAnimation {
    [skeleton_ setAnimationForTrack:0
                               name:[self animation]
                               loop:[self isLoop]];
}

- (void) updateAvailableAnimations {
    [availableAnimations_ release];
    availableAnimations_ = [[NSMutableArray alloc] init];
    
    [availableAnimations_ addObject:kNoAnimation];
    for (int i = 0; i < [skeleton_ skeleton]->data->animationsCount; ++i) {
        [availableAnimations_ addObject:@([skeleton_ skeleton]->data->animations[i]->name)];
    }
    
    // Try to use the existing animation.
    NSInteger index = [availableAnimations_ indexOfObject:_animation];
    if (index == NSNotFound) {
        // Reset.
        [self setAnimation:kNoAnimation];
    } else {
        // Bypass the string comparison.
        NSString* holder = _animation;
        _animation = nil;
        [self setAnimation:holder];
    }
}

- (void) updateAvailableSkins {
    [availableSkins_ release];
    availableSkins_ = [[NSMutableArray alloc] init];
    
    NSInteger skinsCount = [skeleton_ skeleton]->data->skinsCount;
    BOOL ignoreDefaultSkin = NO;
    if (skinsCount > 1) {
        ignoreDefaultSkin = YES;
    }
    
    for (NSInteger i = (ignoreDefaultSkin ? 1 : 0); i < skinsCount; ++i) {
        [availableSkins_ addObject:@([skeleton_ skeleton]->data->skins[i]->name)];
    }
    
    // try to use the existing skin.
    NSInteger index = [availableSkins_ indexOfObject:_skin];
    if (index == NSNotFound) {
        // Temporarily reset the current skin.
        [_skin release];
        _skin = nil;
    
        [self setSkin:[availableSkins_ objectAtIndex:0]];
    } else {
        // Bypass the string comparison.
        NSString* holder = _skin;
        _skin = nil;
        [self setSkin:holder];
    }
}

- (void) setDataFile:(NSString*) dataFile {
    if ([_dataFile isEqualToString:dataFile]) {
        return;
    }
    [_dataFile autorelease];
    _dataFile = [dataFile copy];
    [self updateSkeleton:YES];
}

- (void) setAtlasFile:(NSString*) atlasFile {
    if ([_atlasFile isEqualToString:atlasFile]) {
        return;
    }
    [_atlasFile autorelease];
    _atlasFile = [atlasFile copy];
    [self updateSkeleton:YES];
}

- (void) setAnimationScale:(CGFloat) scale {
    if (_animationScale == scale) {
        return;
    }
    _animationScale = scale;
    [self updateSkeleton:NO];
}

- (void) setAnimation:(NSString*) animation {
    if ([_animation isEqualToString:animation]) {
        return;
    }
    [_animation autorelease];
    _animation = [animation copy];
    [self updateAnimation];
}

- (void) setLoop:(BOOL) loop {
    if (_loop == loop) {
        return;
    }
    _loop = loop;
    [self updateAnimation];
}

- (void) setTimeScale:(CGFloat) timeScale {
    if (_timeScale == timeScale) {
        return;
    }
    _timeScale = timeScale;
    [skeleton_ setTimeScale:_timeScale];
}

- (void) setSkin:(NSString*) skin {
    if ([_skin isEqualToString:skin]) {
        return;
    }
    [_skin autorelease];
    _skin = [skin copy];
    [skeleton_ setSkin:_skin];
}

- (void) setDebugBonesEnabled:(BOOL) enabled {
    if (_debugBonesEnabled == enabled) {
        return;
    }
    _debugBonesEnabled = enabled;
    [skeleton_ setDebugBones:enabled];
}

- (void) setDebugSlotsEnabled:(BOOL) enabled {
    if (_debugSlotsEnabled == enabled) {
        return;
    }
    _debugSlotsEnabled = enabled;
    [skeleton_ setDebugSlots:enabled];
}

- (void) setValue:(id) value forUndefinedKey:(NSString*) key {
    [super setValue:value forKey:key];
}

- (id) valueForUndefinedKey:(NSString*) key {
    return [super valueForUndefinedKey:key];
}

@end
