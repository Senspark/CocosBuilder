//
//  CCSpriteWithHSV.h
//  UI
//
//  Created by Zinge on 6/20/16.
//
//

#import "CCSprite.h"
#import "CCHsvProtocol.h"

@interface CCSpriteWithHSV : CCSprite<CCHsvProtocol> {
    GLuint hsvLocation_;
    kmMat4 hueMatrix_;
    kmMat4 saturationMatrix_;
    kmMat4 brightnessMatrix_;
    kmMat4 contrastMatrix_;
    
    BOOL matrixDirty_;
    BOOL hueMatrixDirty_;
    BOOL saturationMatrixDirty_;
    BOOL brightnessMatrixDirty_;
    BOOL contrastMatrixDirty_;
}

@end
