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

#include "ColorUtils.h"

@interface CCSprite(UpdateColor);

- (void) updateColor;

@end

@implementation CCSpriteWithHSV

- (id) init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self initShader];
    [self setSaturation:1];
    [self setBrightness:0];
    [self setContrast:1];
    
    return self;
}

- (void) initShader {
    CCGLProgram* p = [[CCShaderCache sharedShaderCache] programForKey:@"hsv_program"];
    if (p == nil) {
        p = [CCGLProgram programWithVertexShaderByteArray:ccPositionTextureColor_vert
                                  fragmentShaderByteArray:[self fragmentShader]];
        [p addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [p addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
        [p addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
        [p link];
        [p updateUniforms];
        [[CCShaderCache sharedShaderCache] addProgram:p forKey:@"hsv_program"];
    }
    
    hsvLocation_ = [p uniformLocationForName:@"u_hsv"];
    
    [self setShaderProgram:p];
    [self updateColor];
}

- (void) updateColor {
    [super updateColor];
    [self updateColorMatrix];
}

- (void) updateColorMatrix {
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

- (void) updateHueMatrix {
    hueRotation(&hueMatrix_, [self hue]);
}

- (void) updateSaturationMatrix {
    modifySaturation(&saturationMatrix_, [self saturation]);
}

- (void) updateBrightnessMatrix {
    CGFloat brightness = [self brightness];
    offsetRGB(&brightnessMatrix_, brightness, brightness, brightness);
}

- (void) updateContrastMatrix {
    CGFloat contrast = [self contrast];
    kmMat4 scaleMatrix;
    scaleRGB(&scaleMatrix, contrast, contrast, contrast);
    
    kmMat4 offsetMatrix;
    CGFloat offset = (1 - contrast) / 2;
    offsetRGB(&offsetMatrix, offset, offset, offset);
    
    kmMat4Multiply(&contrastMatrix_, &offsetMatrix, &scaleMatrix);
}

- (void) setHue:(CGFloat) hue {
    _hue = hue;
    [self updateHueMatrix];
    [self updateColorMatrix];
}

- (void) setSaturation:(CGFloat) saturation {
    saturation = max(0, saturation);
    _saturation = saturation;
    [self updateSaturationMatrix];
    [self updateColorMatrix];
}

- (void) setBrightness:(CGFloat) brightness {
    _brightness = brightness;
    [self updateBrightnessMatrix];
    [self updateColorMatrix];
}

- (void) setContrast:(CGFloat) contrast {
    _contrast = contrast;
    [self updateContrastMatrix];
    [self updateColorMatrix];
}

- (GLchar*) fragmentShader {
    return \
    "                                                                        \n\
    #ifdef GL_ES                                                             \n\
    precision mediump float;                                                 \n\
    #endif                                                                   \n\
                                                                             \n\
    varying vec4 v_fragmentColor;                                            \n\
    varying vec2 v_texCoord;                                                 \n\
                                                                             \n\
    uniform sampler2D CC_Texture0;                                           \n\
    uniform mat4 u_hsv;                                                      \n\
                                                                             \n\
    void main() {                                                            \n\
        vec4 pixelColor = texture2D(CC_Texture0, v_texCoord);                \n\
                                                                             \n\
        // Store the original alpha.                                         \n\
        float alpha = pixelColor.w;                                          \n\
                                                                             \n\
        // Reset alpha to 1.0.                                               \n\
        pixelColor.w = 1.0;                                                  \n\
        vec4 fragColor = u_hsv * pixelColor;                                 \n\
                                                                             \n\
        // Restore the original alpha.                                       \n\
        fragColor.w = alpha;                                                 \n\
                                                                             \n\
        gl_FragColor = fragColor * v_fragmentColor;                          \n\
    }                                                                        \n\
    ";
}

@end
