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

@implementation CCBlurBackground

- (void) dealloc {
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    areRenderersInitialized_ = NO;
    _renderScale = 1.0;
    
    return self;
}

- (CCGLProgram*) createShader:(NSString*) name vertexShader:(GLchar*) shader {
    CCGLProgram* p = [[CCShaderCache sharedShaderCache] programForKey:name];
    if (p == nil) {
        p = [CCGLProgram programWithVertexShaderByteArray:shader
                                  fragmentShaderByteArray:[self fragShader]];
        [p addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [p addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [p addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
        [p addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
        [p link];
        [p updateUniforms];
        [[CCShaderCache sharedShaderCache] addProgram:p forKey:name];
    }
    return p;
}

- (CCGLProgram*) createHorizontalShader {
    return [self createShader:@"ee_horizontal_vertex_shader"
                 vertexShader:[self horizontalVertexShader]];
}

- (CCGLProgram*) createVerticalShader {
    return [self createShader:@"ee_vertical_vertex_shader"
                 vertexShader:[self verticalVertexShader]];
}

- (void) initRenderers {
    sceneSize_ = [[self rootNode] contentSize];
    
    [self setContentSize:sceneSize_];
    
    CGSize renderSize = CGSizeMake(sceneSize_.width * [self renderScale],
                                   sceneSize_.height * [self renderScale]);
    
    horizontalRenderer_ = [CCRenderTexture renderTextureWithWidth:renderSize.width
                                                           height:renderSize.height];
    
    verticalRenderer_ = [CCRenderTexture renderTextureWithWidth:renderSize.width
                                                         height:renderSize.height];
    
    [[horizontalRenderer_ sprite] setShaderProgram:[self createHorizontalShader]];
    [[verticalRenderer_ sprite] setShaderProgram:[self createVerticalShader]];
    
    [[horizontalRenderer_ sprite] setAnchorPoint:CGPointMake(0, 1)];
    [[verticalRenderer_ sprite] setAnchorPoint:CGPointMake(0, 1)];
    
    [horizontalRenderer_ setVisible:NO];
    [verticalRenderer_ setScale:1 / [self renderScale]];
    
    [self addChild:horizontalRenderer_ z:-1];
    [self addChild:verticalRenderer_ z:-1];
}

- (void) lazyInitRenderers {
    if (horizontalRenderer_ == nil) {
        [self initRenderers];
        areRenderersInitialized_ = YES;
    }
}

- (void) resetRenderers {
    [horizontalRenderer_ removeFromParent];
    [verticalRenderer_ removeFromParent];
}

- (void) adaptSceneSize {
    CGSize currentSize = [[self rootNode] contentSize];
    if (CGSizeEqualToSize(currentSize, sceneSize_)) {
        return;
    }
    
    if (areRenderersInitialized_) {
        [self resetRenderers];
        [self initRenderers];
    }
}

- (CCNode*) rootNode {
    CCDirector* director = [CCDirector sharedDirector];
    CCScene* runningScene = [director runningScene];
    
    CCLayer* cocosScene = [[runningScene children] objectAtIndex:0];
    CCNode* rootNode = [cocosScene valueForKey:@"rootNode"];
    
    return rootNode;
}

- (void) setRenderScale:(CGFloat) scale {
    if (_renderScale == scale) {
        return;
    }
    _renderScale = scale;
    
    if (areRenderersInitialized_) {
        [self resetRenderers];
        [self initRenderers];
    }
}

- (void) visit {
    if ([self visible]) {
        [self lazyInitRenderers];
        [self adaptSceneSize];
        
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
    
    [super visit];
}

- (GLchar*) horizontalVertexShader {
    return "\
attribute vec4 a_position;                                                   \n\
attribute vec2 a_texCoord;                                                   \n\
attribute vec4 a_color;                                                      \n\
                                                                             \n\
#ifdef GL_ES                                                                 \n\
varying lowp vec4 v_fragmentColor;                                           \n\
varying mediump vec2 v_texCoord;                                             \n\
varying mediump vec2 v_blurTexCoords[14];                                    \n\
#else                                                                        \n\
varying vec4 v_fragmentColor;                                                \n\
varying vec2 v_texCoord;                                                     \n\
varying vec2 v_blurTexCoords[14];                                            \n\
#endif                                                                       \n\
                                                                             \n\
void main() {                                                                \n\
    gl_Position = CC_MVPMatrix * a_position;                                 \n\
    v_fragmentColor = a_color;                                               \n\
    v_texCoord = a_texCoord;                                                 \n\
    v_blurTexCoords[ 0] = v_texCoord + vec2(-0.028, 0.0);                    \n\
    v_blurTexCoords[ 1] = v_texCoord + vec2(-0.024, 0.0);                    \n\
    v_blurTexCoords[ 2] = v_texCoord + vec2(-0.020, 0.0);                    \n\
    v_blurTexCoords[ 3] = v_texCoord + vec2(-0.016, 0.0);                    \n\
    v_blurTexCoords[ 4] = v_texCoord + vec2(-0.012, 0.0);                    \n\
    v_blurTexCoords[ 5] = v_texCoord + vec2(-0.008, 0.0);                    \n\
    v_blurTexCoords[ 6] = v_texCoord + vec2(-0.004, 0.0);                    \n\
    v_blurTexCoords[ 7] = v_texCoord + vec2( 0.004, 0.0);                    \n\
    v_blurTexCoords[ 8] = v_texCoord + vec2( 0.008, 0.0);                    \n\
    v_blurTexCoords[ 9] = v_texCoord + vec2( 0.012, 0.0);                    \n\
    v_blurTexCoords[10] = v_texCoord + vec2( 0.016, 0.0);                    \n\
    v_blurTexCoords[11] = v_texCoord + vec2( 0.020, 0.0);                    \n\
    v_blurTexCoords[12] = v_texCoord + vec2( 0.024, 0.0);                    \n\
    v_blurTexCoords[13] = v_texCoord + vec2( 0.028, 0.0);                    \n\
}                                                                            \n\
    ";
}

- (GLchar*) verticalVertexShader {
    return "\
attribute vec4 a_position;                                                   \n\
attribute vec2 a_texCoord;                                                   \n\
attribute vec4 a_color;                                                      \n\
                                                                             \n\
#ifdef GL_ES                                                                 \n\
varying lowp vec4 v_fragmentColor;                                           \n\
varying mediump vec2 v_texCoord;                                             \n\
varying mediump vec2 v_blurTexCoords[14];                                    \n\
#else                                                                        \n\
varying vec4 v_fragmentColor;                                                \n\
varying vec2 v_texCoord;                                                     \n\
varying vec2 v_blurTexCoords[14];                                            \n\
#endif                                                                       \n\
                                                                             \n\
void main() {                                                                \n\
    gl_Position = CC_MVPMatrix * a_position;                                 \n\
    v_fragmentColor = a_color;                                               \n\
    v_texCoord = a_texCoord;                                                 \n\
    v_blurTexCoords[ 0] = v_texCoord + vec2(0.0, -0.028);                    \n\
    v_blurTexCoords[ 1] = v_texCoord + vec2(0.0, -0.024);                    \n\
    v_blurTexCoords[ 2] = v_texCoord + vec2(0.0, -0.020);                    \n\
    v_blurTexCoords[ 3] = v_texCoord + vec2(0.0, -0.016);                    \n\
    v_blurTexCoords[ 4] = v_texCoord + vec2(0.0, -0.012);                    \n\
    v_blurTexCoords[ 5] = v_texCoord + vec2(0.0, -0.008);                    \n\
    v_blurTexCoords[ 6] = v_texCoord + vec2(0.0, -0.004);                    \n\
    v_blurTexCoords[ 7] = v_texCoord + vec2(0.0,  0.004);                    \n\
    v_blurTexCoords[ 8] = v_texCoord + vec2(0.0,  0.008);                    \n\
    v_blurTexCoords[ 9] = v_texCoord + vec2(0.0,  0.012);                    \n\
    v_blurTexCoords[10] = v_texCoord + vec2(0.0,  0.016);                    \n\
    v_blurTexCoords[11] = v_texCoord + vec2(0.0,  0.020);                    \n\
    v_blurTexCoords[12] = v_texCoord + vec2(0.0,  0.024);                    \n\
    v_blurTexCoords[13] = v_texCoord + vec2(0.0,  0.028);                    \n\
}                                                                            \n\
    ";
}

- (GLchar*) fragShader {
    return "\
#ifdef GL_ES                                                                 \n\
precision mediump float;                                                     \n\
#endif                                                                       \n\
                                                                             \n\
uniform sampler2D CC_Texture0;                                               \n\
                                                                             \n\
varying vec4 v_fragmentColor;                                                \n\
varying vec2 v_texCoord;                                                     \n\
varying vec2 v_blurTexCoords[14];                                            \n\
                                                                             \n\
void main() {                                                                \n\
    const float w0 = 0.159576912161;                                         \n\
    const float w1 = 0.147308056121;                                         \n\
    const float w2 = 0.115876621105;                                         \n\
    const float w3 = 0.0776744219933;                                        \n\
    const float w4 = 0.0443683338718;                                        \n\
    const float w5 = 0.0215963866053;                                        \n\
    const float w6 = 0.00895781211794;                                       \n\
    const float w7 = 0.0044299121055113265;                                  \n\
                                                                             \n\
    gl_FragColor = vec4(0.0);                                                \n\
    gl_FragColor += texture2D(CC_Texture0, v_blurTexCoords[ 0]) * w7;        \n\
    gl_FragColor += texture2D(CC_Texture0, v_blurTexCoords[ 1]) * w6;        \n\
    gl_FragColor += texture2D(CC_Texture0, v_blurTexCoords[ 2]) * w5;        \n\
    gl_FragColor += texture2D(CC_Texture0, v_blurTexCoords[ 3]) * w4;        \n\
    gl_FragColor += texture2D(CC_Texture0, v_blurTexCoords[ 4]) * w3;        \n\
    gl_FragColor += texture2D(CC_Texture0, v_blurTexCoords[ 5]) * w2;        \n\
    gl_FragColor += texture2D(CC_Texture0, v_blurTexCoords[ 6]) * w1;        \n\
    gl_FragColor += texture2D(CC_Texture0, v_texCoord         ) * w0;        \n\
    gl_FragColor += texture2D(CC_Texture0, v_blurTexCoords[ 7]) * w1;        \n\
    gl_FragColor += texture2D(CC_Texture0, v_blurTexCoords[ 8]) * w2;        \n\
    gl_FragColor += texture2D(CC_Texture0, v_blurTexCoords[ 9]) * w3;        \n\
    gl_FragColor += texture2D(CC_Texture0, v_blurTexCoords[10]) * w4;        \n\
    gl_FragColor += texture2D(CC_Texture0, v_blurTexCoords[11]) * w5;        \n\
    gl_FragColor += texture2D(CC_Texture0, v_blurTexCoords[12]) * w6;        \n\
    gl_FragColor += texture2D(CC_Texture0, v_blurTexCoords[13]) * w7;        \n\
    gl_FragColor = gl_FragColor * v_fragmentColor;                           \n\
}                                                                            \n\
    ";
}

@end
