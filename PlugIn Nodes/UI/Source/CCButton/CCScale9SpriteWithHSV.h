//
//  CCScale9SpriteWithHSV.h
//  UI
//
//  Created by Zinge on 10/21/16.
//
//

#import "CCScale9Sprite.h"

@interface CCScale9SpriteWithHSV : CCScale9Sprite {
    GLuint hsvLocation_;
    kmMat4 brightnessMatrix_;
}

@property (nonatomic) CGFloat brightness;

@end
