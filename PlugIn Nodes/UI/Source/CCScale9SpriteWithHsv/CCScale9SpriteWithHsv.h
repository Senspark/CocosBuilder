//
//  CCScale9SpriteWithHSV.h
//  UI
//
//  Created by Zinge on 10/21/16.
//
//

#import "CCScale9Sprite.h"
#import "CCHsvProtocol.h"

@interface CCScale9SpriteWithHsv : CCScale9Sprite <CCHsvProtocol> {
    GLuint hsvLocation_;
    kmMat4 brightnessMatrix_;

    BOOL matrixDirty_;
    BOOL brightnessMatrixDirty_;
}

@end
