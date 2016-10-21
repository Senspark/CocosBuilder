//
//  BlurUtils.h
//  UI
//
//  Created by Zinge on 6/27/16.
//
//

@class CCGLProgram;

CCGLProgram* createHorizontalBlurProgram(float width, int blurRadius,
                                         float sigma);

CCGLProgram* createVerticalBlurProgram(float height, int blurRadius,
                                       float sigma);

CCGLProgram* createHsvProgram(void);
