//
//  ColorUtils.h
//  UI
//
//  Created by Zinge on 6/21/16.
//
//

#ifndef CCB_COLOR_UTILS_H_
#define CCB_COLOR_UTILS_H_

#include <OpenGL/gltypes.h>

/// Reference:
/// http://graficaobscura.com/matrix/index.html
/// https://gist.github.com/lprhodes/1872328
/// http://opensource.apple.com//source/cups/cups-91/filter/image-colorspace.c
/// https://docs.rainmeter.net/tips/colormatrix-guide/

struct kmMat4;
typedef struct kmMat4 kmMat4;

/// Color transformation.
kmMat4* xformRGB(kmMat4* m, float r, float g, float b, float* tr, float* tg,
                 float* tb);

/// Changes constrast.
kmMat4* scaleRGB(kmMat4* m, float rscale, float gscale, float bscale);

/// Converts to luminance.
kmMat4* convertToLuminance(kmMat4* m);

/// Changes saturation.
kmMat4* modifySaturation(kmMat4* m, float s);

/// Changes contrast.
kmMat4* offsetRGB(kmMat4* m, float r, float g, float b);

/// Rotates the hue components by @c r degrees.
kmMat4* hueRotation(kmMat4* m, float r);

GLchar* hsvFragmentShader(void);

#endif /* CCB_COLOR_UTILS_H_ */
