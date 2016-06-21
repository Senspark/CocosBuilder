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
    
    return self;
}

- (void) initShader {
    CCGLProgram* p = [CCGLProgram programWithVertexShaderByteArray:ccPositionTextureColor_vert
                                           fragmentShaderByteArray:[self fragmentShader]];
    [p addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [p addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
    [p addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
    [p link];
    [p updateUniforms];
    
    hueLocation_ = glGetUniformLocation([p program], "u_hue");
    
    [self setShaderProgram:p];
    [self updateColor];
}

- (void) updateColor {
    [super updateColor];
    [self updateColorMatrix];
}

- (void) updateColorMatrix {
    [[self shaderProgram] use];
    
    kmMat4 mat;
    hueRotation(&mat, [self hue]);
    glUniformMatrix4fv(hueLocation_, 1, GL_FALSE, mat.mat);
}

- (void) setHue:(CGFloat) hue {
    _hue = hue;
    [self updateColorMatrix];
}

- (void) setSaturation:(GLuint) saturation {
    
}

- (void) setBrightness:(GLuint) brightness {
    
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
                                                                             \n\
    void main() {                                                            \n\
        vec4 pixelColor = texture2D(CC_Texture0, v_texCoord);                \n\
        vec4 fragColor = u_hue * pixelColor;                                 \n\
        gl_FragColor = fragColor * v_fragmentColor;                          \n\
    }                                                                        \n\
    ";
}

@end
