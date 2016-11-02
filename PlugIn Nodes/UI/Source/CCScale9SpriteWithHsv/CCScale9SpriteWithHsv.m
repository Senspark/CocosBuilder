//
//  CCScale9SpriteWithHSV.m
//  UI
//
//  Created by Zinge on 10/21/16.
//
//

#import "CCScale9SpriteWithHsv.h"

#import "cocos2d.h"
#import "ShaderUtils.h"

#include "ColorUtils.h"

@interface CCScale9Sprite ()

- (void)updateWithBatchNode:(CCSpriteBatchNode*)batchnode
                       rect:(CGRect)rect
                    rotated:(BOOL)rotated
                  capInsets:(CGRect)capInsets;

@end

@implementation CCScale9SpriteWithHsv

@synthesize brightness = brightness_;
@synthesize displayedBrightness = displayedBrightness_;

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }

    [self setBrightness:0];

    matrixDirty_ = YES;
    brightnessMatrixDirty_ = YES;

    [self updateMatrix];

    return self;
}

- (void)initShader {
    CCGLProgram* p = createHsvProgram();
    hsvLocation_ = [p uniformLocationForName:@"u_hsv"];

    [scale9Image setShaderProgram:p];
}

- (void)updateWithBatchNode:(CCSpriteBatchNode*)batchnode
                       rect:(CGRect)rect
                    rotated:(BOOL)rotated
                  capInsets:(CGRect)capInsets {
    [super updateWithBatchNode:batchnode
                          rect:rect
                       rotated:rotated
                     capInsets:capInsets];
    [self initShader];
}

- (void)updateMatrix {
    [self updateBrightnessMatrix];

    if (matrixDirty_) {
        matrixDirty_ = NO;
        kmMat4 mat0, mat1;
        kmMat4Identity(&mat0);
        kmMat4Multiply(&mat1, &brightnessMatrix_, &mat0);
        [[scale9Image shaderProgram] use];
        [[scale9Image shaderProgram] setUniformLocation:hsvLocation_
                                          withMatrix4fv:mat1.mat
                                                  count:1];
    }
}

- (void)updateBrightnessMatrix {
    if (brightnessMatrixDirty_) {
        brightnessMatrixDirty_ = NO;
        CGFloat brightness = [self displayedBrightness];
        offsetRGB(&brightnessMatrix_, brightness, brightness, brightness);
    }
}

- (void)setBrightness:(CGFloat)brightness {
    if (brightness_ == [self brightness]) {
        return;
    }
    displayedBrightness_ = brightness_ = brightness;
    matrixDirty_ = brightnessMatrixDirty_ = YES;
}

- (void)draw {
    [self updateMatrix];
    [super draw];
}

@end
