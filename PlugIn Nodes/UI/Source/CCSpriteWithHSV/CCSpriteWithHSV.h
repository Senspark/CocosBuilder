//
//  CCSpriteWithHSV.h
//  UI
//
//  Created by Zinge on 6/20/16.
//
//

#import "CCSprite.h"

@interface CCSpriteWithHSV : CCSprite {
    GLuint hsvLocation_;
    kmMat4 hueMatrix_;
    kmMat4 saturationMatrix_;
    kmMat4 brightnessMatrix_;
    kmMat4 contrastMatrix_;
}

@property (nonatomic) CGFloat hue;
@property (nonatomic) CGFloat saturation;
@property (nonatomic) CGFloat brightness;
@property (nonatomic) CGFloat contrast;

@end