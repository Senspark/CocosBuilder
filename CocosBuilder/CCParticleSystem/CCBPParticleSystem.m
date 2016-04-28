/*
 * CocosBuilder: http://www.cocosbuilder.com
 *
 * Copyright (c) 2012 Zynga Inc.
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

#import "CCBPParticleSystem.h"

@implementation CCBPParticleSystem

- (id) init {
    self = [super init];
    if (self != nil) {
        self.particlePositionType = CCParticleSystemPositionTypeGrouped;
    }
    return self;
}

#pragma mark Gravity mode

- (CGPoint) gravity {
    if (_emitterMode == CCParticleSystemModeGravity) {
        return [super gravity];
    }
    return ccp(0, 0);
}

- (void) setGravity:(CGPoint) gravity {
    if (_emitterMode == CCParticleSystemModeGravity) {
        [super setGravity:gravity];
    }
}

- (float) speed {
    if (_emitterMode == CCParticleSystemModeGravity) {
        return [super speed];
    }
    return 0;
}

- (void) setSpeed:(float) speed {
    if (_emitterMode == CCParticleSystemModeGravity) {
        [super setSpeed:speed];
    }
}

- (float) speedVar {
    if (_emitterMode == CCParticleSystemModeGravity) {
        return [super speedVar];
    }
    return 0;
}

- (void) setSpeedVar:(float) speedVar {
    if (_emitterMode == CCParticleSystemModeGravity) {
        [super setSpeedVar:speedVar];
    }
}

- (float) tangentialAccel {
    if (_emitterMode == CCParticleSystemModeGravity) {
        return [super tangentialAccel];
    }
    return 0;
}

- (void) setTangentialAccel:(float) tangentialAccel {
    if (_emitterMode == CCParticleSystemModeGravity) {
        [super setTangentialAccel:tangentialAccel];
    }
}

- (float) tangentialAccelVar {
    if (_emitterMode == CCParticleSystemModeGravity) {
        return [super tangentialAccelVar];
    }
    return 0;
}

- (void) setTangentialAccelVar:(float) tangentialAccelVar {
    if (_emitterMode == CCParticleSystemModeGravity) {
        [super setTangentialAccelVar:tangentialAccelVar];
    }
}

- (float) radialAccel {
    if (_emitterMode == CCParticleSystemModeGravity) {
        return [super radialAccel];
    }
    return 0;
}

- (void) setRadialAccel:(float) radialAccel {
    if (_emitterMode == CCParticleSystemModeGravity) {
        [super setRadialAccel:radialAccel];
    }
}

- (float) radialAccelVar {
    if (_emitterMode == CCParticleSystemModeGravity) {
        return [super radialAccelVar];
    }
    return 0;
}

- (void) setRadialAccelVar:(float) radialAccelVar {
    if (_emitterMode == CCParticleSystemModeGravity) {
        [super setRadialAccelVar:radialAccelVar];
    }
}

#pragma mark Radial mode

- (float) startRadius {
    if (_emitterMode == CCParticleSystemModeRadius) {
        return [super startRadius];
    }
    return 0;
}

- (void) setStartRadius:(float) startRadius {
    if (_emitterMode == CCParticleSystemModeRadius) {
        [super setStartRadius:startRadius];
    }
}

- (float) startRadiusVar {
    if (_emitterMode == CCParticleSystemModeRadius) {
        return [super startRadiusVar];
    }
    return 0;
}

- (void) setStartRadiusVar:(float) startRadiusVar {
    if (_emitterMode == CCParticleSystemModeRadius) {
        [super setStartRadiusVar:startRadiusVar];
    }
}

- (float) endRadius {
    if (_emitterMode == CCParticleSystemModeRadius) {
        return [super endRadius];
    }
    return 0;
}

- (void) setEndRadius:(float) endRadius {
    if (_emitterMode == CCParticleSystemModeRadius) {
        [super setEndRadius:endRadius];
    }
}

- (float) endRadiusVar {
    if (_emitterMode == CCParticleSystemModeRadius) {
        return [super endRadiusVar];
    }
    return 0;
}

- (void) setEndRadiusVar:(float) endRadiusVar {
    if (_emitterMode == CCParticleSystemModeRadius) {
        [super setEndRadiusVar:endRadiusVar];
    }
}

- (float) rotatePerSecond {
    if (_emitterMode == CCParticleSystemModeRadius) {
        return [super rotatePerSecond];
    }
    return 0;
}

- (void) setRotatePerSecond:(float) rotatePerSecond {
    if (_emitterMode == CCParticleSystemModeRadius) {
        [super setRotatePerSecond:rotatePerSecond];
    }
}

- (float) rotatePerSecondVar {
    if (_emitterMode == CCParticleSystemModeRadius) {
        return [super rotatePerSecondVar];
    }
    return 0;
}

- (void) setRotatePerSecondVar:(float) rotatePerSecondVar {
    if (_emitterMode == CCParticleSystemModeRadius) {
        [super setRotatePerSecondVar:rotatePerSecondVar];
    }
}

- (NSArray*) ccbExcludePropertiesForSave {
    if (_emitterMode == CCParticleSystemModeGravity) {
        return [NSArray arrayWithObjects:
                @"startRadius",
                @"endRadius",
                @"rotatePerSecond",
                nil];
    } else {
        return [NSArray arrayWithObjects:
                @"gravity",
                @"speed",
                @"tangentialAccel",
                @"radialAccel",
                nil];
    }    
    return nil;
}

@end
