//
//  EEButton.hpp
//  UI
//
//  Created by Zinge on 10/24/16.
//
//

#import "CCButton.h"

@interface EEButton : CCButton

@property (nonatomic) CGFloat pressedSpriteFrameBrightness;

@property (nonatomic, getter=isPressedSpriteFrameCascadeHsvEnabled)
    BOOL pressedSpriteFrameCascadeHsvEnabled;

@end
