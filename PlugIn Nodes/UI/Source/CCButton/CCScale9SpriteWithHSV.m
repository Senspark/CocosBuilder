//
//  CCScale9SpriteWithHSV.m
//  UI
//
//  Created by Zinge on 10/21/16.
//
//

#import "CCScale9SpriteWithHSV.h"

#import "cocos2d.h"
#import "ShaderUtils.h"

#include "ColorUtils.h"

@interface CCScale9Sprite ()

- (void)updateWithBatchNode:(CCSpriteBatchNode*)batchnode
                       rect:(CGRect)rect
                    rotated:(BOOL)rotated
                  capInsets:(CGRect)capInsets;

@end

@implementation CCScale9SpriteWithHSV

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    [self setBrightness:0];
    return self;
}

- (void)updateWithBatchNode:(CCSpriteBatchNode*)batchnode
                       rect:(CGRect)rect
                    rotated:(BOOL)rotated
                  capInsets:(CGRect)capInsets {
    [super updateWithBatchNode:batchnode
                          rect:rect
                       rotated:rotated
                     capInsets:capInsets];
    CCGLProgram* p = createHsvProgram();
    hsvLocation_ = [p uniformLocationForName:@"u_hsv"];
    [scale9Image setShaderProgram:p];
}

- (void)updateColorMatrix {
    kmMat4 mat0, mat1;
    kmMat4Identity(&mat0);
    kmMat4Multiply(&mat1, &brightnessMatrix_, &mat0);
    [[scale9Image shaderProgram] use];
    [[scale9Image shaderProgram] setUniformLocation:hsvLocation_
                                      withMatrix4fv:mat1.mat
                                              count:1];
}

- (void)updateBrightnessMatrix {
    CGFloat brightness = [self brightness];
    offsetRGB(&brightnessMatrix_, brightness, brightness, brightness);
}

- (void)setBrightness:(CGFloat)brightness {
    _brightness = brightness;
    [self updateBrightnessMatrix];
}

- (void)visit {
    if ([self visible]) {
        [self updateColorMatrix];
    }
    [super visit];
}

@end
