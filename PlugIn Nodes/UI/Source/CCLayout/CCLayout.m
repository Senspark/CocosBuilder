//
//  CCLayout.m
//  UI
//
//  Created by Zinge on 5/6/16.
//
//

#import "CCLayout.h"
#import "CCLayer.h"

@implementation CCLayout

- (id) init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self setIgnoreContentAdaptWithSize:NO];
    [self setContentSize:CGSizeZero];
    [self setAnchorPoint:CGPointZero];
    
    [self setBackgroundColorOpacity:255];
    [self setBackgroundColor:ccWHITE];
    [self setBackgroundColorType:CCLayoutBackgroundColorSolid];
    
    return self;
}

- (void) onSizeChanged {
    [super onSizeChanged];
    if (colorRender_ != nil) {
        [colorRender_ setContentSize:[self contentSize]];
    }
}

- (void) setBackgroundColorType:(CCLayoutBackgroundColor) type {
    if (_backgroundColorType == type) {
        return;
    }
    switch (_backgroundColorType) {
        case CCLayoutBackgroundColorNone: {
            [self removeChild:colorRender_];
            colorRender_ = nil;
            break;
        }
        case CCLayoutBackgroundColorSolid: {
            [self removeChild:colorRender_];
            colorRender_ = nil;
            break;
        }
    }
    
    _backgroundColorType = type;
    switch (_backgroundColorType) {
        case CCLayoutBackgroundColorNone:
            break;
            
        case CCLayoutBackgroundColorSolid: {
            ccColor4B color;
            color.r = [self backgroundColor].r;
            color.g = [self backgroundColor].g;
            color.b = [self backgroundColor].b;
            color.a = [self backgroundColorOpacity];
            colorRender_ = [CCLayerColor layerWithColor:color];
            [colorRender_ setContentSize:[self contentSize]];
            [self addChild:colorRender_ z:-1];
            break;
        }
    }
}

- (void) setBackgroundColor:(ccColor3B) color {
    _backgroundColor = color;
    [colorRender_ setColor:color];
}

- (void) setBackgroundColorOpacity:(GLubyte) opacity {
    _backgroundColorOpacity = opacity;
    [colorRender_ setOpacity:opacity];
}

@end