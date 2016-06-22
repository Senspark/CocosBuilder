//
//  ColorUtils.c
//  UI
//
//  Created by Zinge on 6/21/16.
//
//

#include <math.h>
#include <string.h>

#include "ColorUtils.h"

#include "mat4.h"

const float rwgt = 0.3086;
const float gwgt = 0.6094;
const float bwgt = 0.0820;

static kmMat4* shearZMatrix(kmMat4* m, float dx, float dy) {
    kmMat4Identity(m);
    m->mat[2] = dx;
    m->mat[6] = dy;
    return m;
}

kmMat4* xformRGB(kmMat4* m, float r, float g, float b, float* tr, float* tg,
                 float* tb) {
    float* mat = m->mat;
    *tr = r * mat[0] + g * mat[4] + b * mat[8] + mat[12];
    *tg = r * mat[1] + g * mat[5] + b * mat[9] + mat[13];
    *tb = r * mat[2] + g * mat[6] + b * mat[10] + mat[14];
    return m;
}

kmMat4* scaleRGB(kmMat4* m, float rscale, float gscale, float bscale) {
    memset(m->mat, 0, sizeof(m->mat));
    m->mat[0] = rscale;
    m->mat[5] = gscale;
    m->mat[10] = bscale;
    m->mat[15] = 1;
    return m;
}

kmMat4* convertToLuminance(kmMat4* m) {
    memset(m->mat, 0, sizeof(m->mat));
    float* mat = m->mat;
    mat[0] = mat[1] = mat[2] = rwgt;
    mat[4] = mat[5] = mat[6] = gwgt;
    mat[8] = mat[9] = mat[10] = bwgt;
    mat[15] = 1;
    return m;
}

kmMat4* modifySaturation(kmMat4* m, float s) {
    memset(m->mat, 0, sizeof(m->mat));
    float* mat = m->mat;

    mat[0] = (1.0 - s) * rwgt + s;
    mat[1] = (1.0 - s) * rwgt;
    mat[2] = (1.0 - s) * rwgt;

    mat[4] = (1.0 - s) * gwgt;
    mat[5] = (1.0 - s) * gwgt + s;
    mat[6] = (1.0 - s) * gwgt;

    mat[8] = (1.0 - s) * bwgt;
    mat[9] = (1.0 - s) * bwgt;
    mat[10] = (1.0 - s) * bwgt + s;

    mat[15] = 1;
    return m;
}

kmMat4* offsetRGB(kmMat4* m, float r, float g, float b) {
    kmMat4Identity(m);
    m->mat[12] = r;
    m->mat[13] = g;
    m->mat[14] = b;
    return m;
}

kmMat4* hueRotation(kmMat4* m, float r) {
    kmMat4 mat0;
    kmMat4 mat1;
    kmMat4 temp;

    // Make an identity matrix.
    kmMat4Identity(&mat0);

    // Rotate the grey vector into positive Z.
    // Sin = 1/sqrt(2).
    // Cos = 1/sqrt(2).
    kmMat4RotationX(&temp, M_PI_4);
    kmMat4Multiply(&mat1, &temp, &mat0);

    // Sin = -1/sqrt(3).
    // Cos = sqrt(2/3).
    kmMat4RotationY(&temp, -0.615479709);
    kmMat4Multiply(&mat0, &temp, &mat1);

    // Shear the space to make the luminance plane horizontal.
    float lx, ly, lz;
    xformRGB(&mat0, rwgt, gwgt, bwgt, &lx, &ly, &lz);

    float zsx = lx / lz;
    float zsy = ly / lz;
    shearZMatrix(&temp, zsx, zsy);
    kmMat4Multiply(&mat1, &temp, &mat0);

    // Rotate the hue.
    float rad = r * M_PI / 180;
    kmMat4RotationZ(&temp, rad);
    kmMat4Multiply(&mat0, &temp, &mat1);

    // Unshear the space to put the luminance plane back.
    shearZMatrix(&temp, -zsx, -zsy);
    kmMat4Multiply(&mat1, &temp, &mat0);

    // Rotate the grey vector back into place.
    // Sin = 1/sqrt(3).
    // Cos = sqrt(2/3);
    kmMat4RotationY(&temp, 0.615479709);
    kmMat4Multiply(&mat0, &temp, &mat1);

    // Sin = -1/sqrt(2).
    // Cos = 1/sqrt(2).
    kmMat4RotationX(&temp, -M_PI_4);
    kmMat4Multiply(&mat1, &temp, &mat0);

    kmMat4Fill(m, mat1.mat);
    return m;
}