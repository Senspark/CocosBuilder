//
//  EEButton.cpp
//  UI
//
//  Created by Zinge on 10/24/16.
//
//

#import "EEButton.h"
#import "CCScale9SpriteWithHsv.h"

@implementation EEButton

- (void)initRenderer {
    buttonNormalRenderer_ = [[[CCScale9SpriteWithHsv alloc] init] autorelease];
    buttonPressedRenderer_ = [[[CCScale9SpriteWithHsv alloc] init] autorelease];
    buttonDisabledRenderer_ =
        [[[CCScale9SpriteWithHsv alloc] init] autorelease];

    [self addChild:buttonNormalRenderer_ z:-2];
    [self addChild:buttonPressedRenderer_ z:-2];
    [self addChild:buttonDisabledRenderer_ z:-2];
}

- (CGFloat)pressedSpriteFrameBrightness {
    return [(CCScale9SpriteWithHsv*)[self pressedRenderer] brightness];
}

- (void)setPressedSpriteFrameBrightness:(CGFloat)brightness {
    [(CCScale9SpriteWithHsv*)[self pressedRenderer] setBrightness:brightness];
}

@end
