//
//  CCSpriteWithHSV.h
//  UI
//
//  Created by Zinge on 6/20/16.
//
//

#import "CCSprite.h"

@interface CCSpriteWithHSV : CCSprite {
    GLuint hueLocation_;
}

@property (nonatomic) CGFloat hue;
@property (nonatomic) CGFloat saturation;
@property (nonatomic) CGFloat brightness;

@end