//
//  CCSpriteWithHSV.m
//  UI
//
//  Created by Zinge on 6/20/16.
//
//

// Reference: http://graficaobscura.com/matrix/index.html

#import "CCSpriteWithHsv.h"

#import "cocos2d.h"
#import "ShaderUtils.h"

#include "ColorUtils.h"

@interface CCSprite (UpdateColor)

- (void)updateColor;

@end

@implementation CCSpriteWithHsv

@synthesize hue = hue_;
@synthesize saturation = saturation_;
@synthesize brightness = brightness_;
@synthesize contrast = contrast_;
@synthesize displayedBrightness = displayedBrightness_;
@synthesize cascadeHsvEnabled = cascadeHsvEnabled_;

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }

    [self initShader];
    [self setHue:0];
    [self setSaturation:1];
    [self setBrightness:0];
    [self setContrast:1];

    matrixDirty_ = YES;
    hueMatrixDirty_ = YES;
    saturationMatrixDirty_ = YES;
    brightnessMatrixDirty_ = YES;
    contrastMatrixDirty_ = YES;

    [self updateMatrix];

    return self;
}

- (void)initShader {
    CCGLProgram* p = createHsvProgram();
    hsvLocation_ = [p uniformLocationForName:@"u_hsv"];

    [self setShaderProgram:p];
}

- (void)updateMatrix {
    [self updateHueMatrix];
    [self updateSaturationMatrix];
    [self updateBrightnessMatrix];
    [self updateContrastMatrix];

    if (matrixDirty_) {
        matrixDirty_ = NO;
        kmMat4 mat0, mat1;
        kmMat4Identity(&mat0);
        kmMat4Multiply(&mat1, &hueMatrix_, &mat0);
        kmMat4Multiply(&mat0, &saturationMatrix_, &mat1);
        kmMat4Multiply(&mat1, &brightnessMatrix_, &mat0);
        kmMat4Multiply(&mat0, &contrastMatrix_, &mat1);
        [[self shaderProgram] use];
        [[self shaderProgram] setUniformLocation:hsvLocation_
                                   withMatrix4fv:mat0.mat
                                           count:1];
    }
}

- (void)updateHueMatrix {
    if (hueMatrixDirty_) {
        hueMatrixDirty_ = NO;
        hueRotation(&hueMatrix_, [self hue]);
    }
}

- (void)updateSaturationMatrix {
    if (saturationMatrixDirty_) {
        saturationMatrixDirty_ = NO;
        modifySaturation(&saturationMatrix_, [self saturation]);
    }
}

- (void)updateBrightnessMatrix {
    if (brightnessMatrixDirty_) {
        brightnessMatrixDirty_ = NO;
        CGFloat brightness = [self displayedBrightness];
        offsetRGB(&brightnessMatrix_, brightness, brightness, brightness);
    }
}

- (void)updateContrastMatrix {
    if (contrastMatrixDirty_) {
        contrastMatrixDirty_ = NO;
        CGFloat contrast = [self contrast];
        kmMat4 scaleMatrix;
        scaleRGB(&scaleMatrix, contrast, contrast, contrast);

        kmMat4 offsetMatrix;
        CGFloat offset = (1 - contrast) / 2;
        offsetRGB(&offsetMatrix, offset, offset, offset);

        kmMat4Multiply(&contrastMatrix_, &offsetMatrix, &scaleMatrix);
    }
}

- (void)setHue:(CGFloat)hue {
    if (hue == [self hue]) {
        return;
    }
    hue_ = hue;
    matrixDirty_ = hueMatrixDirty_ = YES;
}

- (void)setSaturation:(CGFloat)saturation {
    saturation = max(0, saturation);
    if (saturation == [self saturation]) {
        return;
    }
    saturation_ = saturation;
    matrixDirty_ = saturationMatrixDirty_ = YES;
}

- (void)setBrightness:(CGFloat)brightness {
    if (brightness == [self brightness]) {
        return;
    }
    displayedBrightness_ = brightness_ = brightness;
    matrixDirty_ = brightnessMatrixDirty_ = YES;
    [self updateCascadeBrightness];
}

- (void)setContrast:(CGFloat)contrast {
    if (contrast == [self contrast]) {
        return;
    }
    contrast_ = contrast;
    matrixDirty_ = contrastMatrixDirty_ = YES;
}

- (void)setCascadeHsvEnabled:(BOOL)enabled {
    if (enabled == [self isCascadeHsvEnabled]) {
        return;
    }
    cascadeHsvEnabled_ = enabled;
    if (enabled) {
        [self updateCascadeBrightness];
    } else {
        [self disableCascadeBrightness];
    }
}

- (void)disableCascadeBrightness {
    for (id child in [self children]) {
        if ([child conformsToProtocol:@protocol(CCHsvProtocol)]) {
            id<CCHsvProtocol> protocol = (id<CCHsvProtocol>)child;
            [protocol updateDisplayedBrightness:0.0];
        }
    }
}

- (void)updateCascadeBrightness {
    CGFloat parentBrightness = 0.0;
    if ([[self parent] conformsToProtocol:@protocol(CCHsvProtocol)]) {
        id<CCHsvProtocol> protocol = (id<CCHsvProtocol>)[self parent];
        if ([protocol isCascadeHsvEnabled]) {
            parentBrightness = [protocol displayedBrightness];
        }
    }
    [self updateDisplayedBrightness:parentBrightness];
}

- (void)updateDisplayedBrightness:(CGFloat)parentBrightness {
    CGFloat displayedBrightness = [self brightness] + parentBrightness;
    if (displayedBrightness != [self displayedBrightness]) {
        displayedBrightness_ = displayedBrightness;
        matrixDirty_ = brightnessMatrixDirty_ = YES;
    }
    if ([self isCascadeHsvEnabled]) {
        for (id child in [self children]) {
            if ([child conformsToProtocol:@protocol(CCHsvProtocol)]) {
                id<CCHsvProtocol> protocol = (id<CCHsvProtocol>)child;
                [protocol updateDisplayedBrightness:[self displayedBrightness]];
            }
        }
    }
}

- (void)addChild:(CCNode*)child z:(NSInteger)z tag:(NSInteger)aTag {
    [super addChild:child z:z tag:aTag];
    if ([self isCascadeHsvEnabled]) {
        [self updateCascadeBrightness];
    }
}

- (void)draw {
    [self updateMatrix];
    [super draw];
}

@end
