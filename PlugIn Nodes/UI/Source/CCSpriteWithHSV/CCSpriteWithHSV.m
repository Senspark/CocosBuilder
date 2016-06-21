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
    [self setSaturation:100];
    [self setBrightness:100];
    
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
    
    hueLocation_ = [p uniformLocationForName:@"u_hue"];
    saturationLocation_ = [p uniformLocationForName:@"u_saturation"];
    brightnessLocation_ = [p uniformLocationForName:@"u_brightness"];
    
    [self setShaderProgram:p];
    [self updateColor];
}

- (void) updateColor {
    [super updateColor];
    [self updateColorMatrix];
}

- (void) updateColorMatrix {
    [[self shaderProgram] use];
    [self updateHueMatrix];
    [self updateSaturationMatrix];
    [self updateBrightnessMatrix];
}

- (void) updateHueMatrix {
    kmMat4 mat;
    hueRotation(&mat, [self hue]);
    [[self shaderProgram] setUniformLocation:hueLocation_
                               withMatrix4fv:mat.mat
                                       count:1];
}

- (void) updateSaturationMatrix {
    kmMat4 mat;
    modifySaturation(&mat, [self saturation] * 0.01);
    [[self shaderProgram] setUniformLocation:saturationLocation_
                               withMatrix4fv:mat.mat
                                       count:1];
}

- (void) updateBrightnessMatrix {
    kmMat4 mat;
    CGFloat brightness = [self brightness] * 0.01;
    changeBrightness(&mat, brightness, brightness, brightness);
    [[self shaderProgram] setUniformLocation:brightnessLocation_
                               withMatrix4fv:mat.mat
                                       count:1];
}

- (void) setHue:(CGFloat) hue {
    _hue = hue;
    [self updateColorMatrix];
}

- (void) setSaturation:(CGFloat) saturation {
    saturation = max(0, saturation);
    _saturation = saturation;
    [self updateColorMatrix];
}

- (void) setBrightness:(CGFloat) brightness {
    brightness = max(0, brightness);
    _brightness = brightness;
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
    uniform mat4 u_hue;                                                      \n\
    uniform mat4 u_saturation;                                               \n\
    uniform mat4 u_brightness;                                               \n\
                                                                             \n\
    void main() {                                                            \n\
        vec4 pixelColor = texture2D(CC_Texture0, v_texCoord);                \n\
        vec4 fragColor = u_hue * pixelColor;                                 \n\
        fragColor = u_saturation * fragColor;                                \n\
        fragColor = u_brightness * fragColor;                                \n\
        gl_FragColor = fragColor * v_fragmentColor;                          \n\
    }                                                                        \n\
    ";
}

@end
