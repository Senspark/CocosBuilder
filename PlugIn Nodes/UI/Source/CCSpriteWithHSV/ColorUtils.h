//
//  ColorUtils.h
//  UI
//
//  Created by Zinge on 6/21/16.
//
//

#ifndef CCB_COLOR_UTILS_H_
#define CCB_COLOR_UTILS_H_

/// Reference:
/// http://graficaobscura.com/matrix/index.html
/// https://gist.github.com/lprhodes/1872328
/// http://opensource.apple.com//source/cups/cups-91/filter/image-colorspace.c

struct kmMat4;
typedef struct kmMat4 kmMat4;

/// Color transformation.
kmMat4* xformRGB(kmMat4* m, float r, float g, float b, float* tr, float* tg,
                 float* tb);

/// Change brightness.
kmMat4* changeBrightness(kmMat4* m, float rscale, float gscale, float bscale);

/// Convert to luminance.
kmMat4* convertToLuminance(kmMat4* m);

kmMat4* modifySaturation(kmMat4* m, float s);

kmMat4* offsetRGB(kmMat4* m, float r, float g, float b);

/// Rotates the hue components by @c r degrees.
kmMat4* hueRotation(kmMat4* m, float r);

#endif /* CCB_COLOR_UTILS_H_ */
