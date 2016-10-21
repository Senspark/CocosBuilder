//
//  CCSpriteWithHSV.m
//  UI
//
//  Created by Zinge on 6/20/16.
//
//

// Reference: http://graficaobscura.com/matrix/index.html

#import "CCSpriteWithHSV.h"

#import "cocos2d.h"
#import "ShaderUtils.h"

#include "ColorUtils.h"

@interface CCSprite (UpdateColor)

- (void)updateColor;

@end

@implementation CCSpriteWithHSV

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

    return self;
}

- (void)initShader {
    CCGLProgram* p = createHsvProgram();
    hsvLocation_ = [p uniformLocationForName:@"u_hsv"];

    [self setShaderProgram:p];
    [self updateColor];
}

- (void)updateColor {
    [super updateColor];
    [self updateColorMatrix];
}

- (void)updateColorMatrix {
    [[self shaderProgram] use];
    kmMat4 mat0, mat1;
    kmMat4Identity(&mat0);
    kmMat4Multiply(&mat1, &hueMatrix_, &mat0);
    kmMat4Multiply(&mat0, &saturationMatrix_, &mat1);
    kmMat4Multiply(&mat1, &brightnessMatrix_, &mat0);
    kmMat4Multiply(&mat0, &contrastMatrix_, &mat1);
    [[self shaderProgram] setUniformLocation:hsvLocation_
                               withMatrix4fv:mat0.mat
                                       count:1];
}

- (void)updateHueMatrix {
    hueRotation(&hueMatrix_, [self hue]);
}

- (void)updateSaturationMatrix {
    modifySaturation(&saturationMatrix_, [self saturation]);
}

- (void)updateBrightnessMatrix {
    CGFloat brightness = [self brightness];
    offsetRGB(&brightnessMatrix_, brightness, brightness, brightness);
}

- (void)updateContrastMatrix {
    CGFloat contrast = [self contrast];
    kmMat4 scaleMatrix;
    scaleRGB(&scaleMatrix, contrast, contrast, contrast);

    kmMat4 offsetMatrix;
    CGFloat offset = (1 - contrast) / 2;
    offsetRGB(&offsetMatrix, offset, offset, offset);

    kmMat4Multiply(&contrastMatrix_, &offsetMatrix, &scaleMatrix);
}

- (void)setHue:(CGFloat)hue {
    _hue = hue;
    [self updateHueMatrix];
    [self updateColorMatrix];
}

- (void)setSaturation:(CGFloat)saturation {
    saturation = max(0, saturation);
    _saturation = saturation;
    [self updateSaturationMatrix];
    [self updateColorMatrix];
}

- (void)setBrightness:(CGFloat)brightness {
    _brightness = brightness;
    [self updateBrightnessMatrix];
    [self updateColorMatrix];
}

- (void)setContrast:(CGFloat)contrast {
    _contrast = contrast;
    [self updateContrastMatrix];
    [self updateColorMatrix];
}

@end
