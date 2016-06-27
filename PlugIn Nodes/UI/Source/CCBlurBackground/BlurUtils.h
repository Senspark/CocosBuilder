//
//  BlurUtils.h
//  UI
//
//  Created by Zinge on 6/27/16.
//
//

#ifndef BlurUtils_h
#define BlurUtils_h

@class CCGLProgram;

CCGLProgram* createHorizontalBlurProgram(float width, int blurRadius,
                                         float sigma);

CCGLProgram* createVerticalBlurProgram(float height, int blurRadius,
                                       float sigma);

#endif /* BlurUtils_h */
