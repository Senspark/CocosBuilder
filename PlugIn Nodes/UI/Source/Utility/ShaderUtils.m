//
//  BlurUtils.m
//  UI
//
//  Created by Zinge on 6/27/16.
//
//

#include <string.h>

#include "ColorUtils.h"

#import "ShaderUtils.h"
#import "cocos2d.h"

static float gaussianFunction(float x, float sigma) {
    const float inv_sqrt_2pi = 0.39894228f;

    float k = x / sigma;
    return inv_sqrt_2pi / sigma * exp(-k * k * 0.5f);
}

static int createBlurVertexShader(int isVertical, float dimension,
                                  int blurRadius, float sigma, char* output) {
    int blurTexCoords = blurRadius * 2;

    int length = 0;

    length += sprintf(output, "#ifdef GL_ES\n"
                              "precision mediump float;\n"
                              "#endif\n"

                              "attribute vec4 a_position;\n"
                              "attribute vec2 a_texCoord;\n"
                              "attribute vec4 a_color;\n"

                              "#ifdef GL_ES\n"
                              "varying lowp vec4 v_fragmentColor;\n"
                              "varying mediump vec2 v_texCoord;\n");
    length +=
        sprintf(output + length, "varying mediump vec2 v_blurTexCoords[%d];\n",
                blurTexCoords);

    length += sprintf(output + length, "#else\n"
                                       "varying vec4 v_fragmentColor;\n"
                                       "varying vec2 v_texCoord;\n");

    length += sprintf(output + length, "varying vec2 v_blurTexCoords[%d];\n",
                      blurTexCoords);

    length += sprintf(output + length,
                      "#endif\n"

                      "void main() {\n"
                      "    gl_Position = CC_MVPMatrix * a_position;\n"
                      "    v_fragmentColor = a_color;\n"
                      "    v_texCoord = a_texCoord;\n");

    int vertexIndex = 0;
    for (int i = blurRadius; i > 0; --i) {
        char offset[100];
        sprintf(offset, "%d.0 / %.10f", -i, dimension);
        length +=
            sprintf(output + length,
                    "    v_blurTexCoords[%d] = v_texCoord + vec2(%s, %s);\n",
                    vertexIndex++, (isVertical ? "0.0" : offset),
                    (isVertical ? offset : "0.0"));
    }

    for (int i = 1; i <= blurRadius; ++i) {
        char offset[100];
        sprintf(offset, "%d.0 / %.10f", i, dimension);
        length +=
            sprintf(output + length,
                    "    v_blurTexCoords[%d] = v_texCoord + vec2(%s, %s);\n",
                    vertexIndex++, (isVertical ? "0.0" : offset),
                    (isVertical ? offset : "0.0"));
    }

    length += sprintf(output + length, "}");

    NSLog(@"%s: %s", __PRETTY_FUNCTION__, output);

    return length;
}

static int createBlurFragmentShader(int blurRadius, float sigma, char* output) {
    int size = blurRadius + 1;

    const int MaxSize = 21;
    float weights[MaxSize];

    assert(size <= MaxSize);

    float sum = 0;
    for (int i = 0; i < size; ++i) {
        weights[i] = gaussianFunction(i, sigma);
        sum += weights[i];
        if (i > 0) {
            sum += weights[i];
        }
    }
    for (int i = 0; i < size; ++i) {
        weights[i] /= sum;
    }

    int blurTexCoords = (size - 1) * 2;

    int length = 0;

    length += sprintf(output, "#ifdef GL_ES\n"
                              "precision mediump float;\n"
                              "#endif\n"

                              "uniform sampler2D CC_Texture0;\n"

                              "#ifdef GL_ES\n"
                              "varying lowp vec4 v_fragmentColor;\n"
                              "varying mediump vec2 v_texCoord;\n");

    length +=
        sprintf(output + length, "varying mediump vec2 v_blurTexCoords[%d];\n",
                blurTexCoords);

    length += sprintf(output + length, "#else\n"
                                       "varying vec4 v_fragmentColor;\n"
                                       "varying vec2 v_texCoord;\n");

    length += sprintf(output + length, "varying vec2 v_blurTexCoords[%d];\n",
                      blurTexCoords);

    length += sprintf(output + length, "#endif\n"

                                       "void main() {\n"
                                       "    gl_FragColor = vec4(0.0);\n");

    int vertexIndex = 0;
    for (int i = size - 1; i > 0; --i) {
        length += sprintf(output + length, "    gl_FragColor += "
                                           "texture2D(CC_Texture0, "
                                           "v_blurTexCoords[%d]) * %.10f;\n",
                          vertexIndex++, weights[i]);
    }

    length += sprintf(
        output + length,
        "    gl_FragColor += texture2D(CC_Texture0, v_texCoord) * %.10f;\n",
        weights[0]);

    for (int i = 1; i < size; ++i) {
        length += sprintf(output + length, "    gl_FragColor += "
                                           "texture2D(CC_Texture0, "
                                           "v_blurTexCoords[%d]) * %.10f;\n",
                          vertexIndex++, weights[i]);
    }

    length += sprintf(output + length,
                      "    gl_FragColor = gl_FragColor * v_fragmentColor;\n"
                      "}");

    NSLog(@"%s: %s", __PRETTY_FUNCTION__, output);

    return length;
}

static CCGLProgram* createBlurProgram(int isVertical, float dimension,
                                      int blurRadius, float sigma) {
    const int MaxShaderSize = 3000;

    char vertexShader[MaxShaderSize];
    createBlurVertexShader(isVertical, dimension, blurRadius, sigma,
                           vertexShader);

    char fragmentShader[MaxShaderSize];
    createBlurFragmentShader(blurRadius, sigma, fragmentShader);

    CCGLProgram* p =
        [CCGLProgram programWithVertexShaderByteArray:vertexShader
                              fragmentShaderByteArray:fragmentShader];

    [p addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [p addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
    [p addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
    [p link];
    [p updateUniforms];
    return p;
}

CCGLProgram* createHorizontalBlurProgram(float width, int blurRadius,
                                         float sigma) {
    CCShaderCache* cache = [CCShaderCache sharedShaderCache];

    char buffer[100];
    sprintf(buffer, "ee_horizontal_blur_%f_%d_%f", width, blurRadius, sigma);

    CCGLProgram* program = [cache programForKey:@(buffer)];
    if (program == nil) {
        program = createBlurProgram(0, width, blurRadius, sigma);
        [cache addProgram:program forKey:@(buffer)];
    }

    return program;
}

CCGLProgram* createVerticalBlurProgram(float height, int blurRadius,
                                       float sigma) {
    CCShaderCache* cache = [CCShaderCache sharedShaderCache];

    char buffer[100];
    sprintf(buffer, "ee_horizontal_blur_%f_%d_%f", height, blurRadius, sigma);

    CCGLProgram* program = [cache programForKey:@(buffer)];
    if (program == nil) {
        program = createBlurProgram(1, height, blurRadius, sigma);
        [cache addProgram:program forKey:@(buffer)];
    }

    return program;
}

CCGLProgram* createHsvProgram(void) {
    CCGLProgram* p = nil;
    // Will be shared!
    // [[CCShaderCache sharedShaderCache] programForKey:@"hsv_program"];
    if (p == nil) {
        p = [CCGLProgram
            programWithVertexShaderByteArray:ccPositionTextureColor_vert
                     fragmentShaderByteArray:hsvFragmentShader()];
        [p addAttribute:kCCAttributeNamePosition
                   index:kCCVertexAttrib_Position];
        [p addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
        [p addAttribute:kCCAttributeNameTexCoord
                   index:kCCVertexAttrib_TexCoords];
        [p link];
        [p updateUniforms];
        // [[CCShaderCache sharedShaderCache] addProgram:p
        // forKey:@"hsv_program"];
    }
    return p;
}
