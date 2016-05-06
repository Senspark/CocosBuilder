//
//  CCText.m
//  UI
//
//  Created by Zinge on 5/5/16.
//
//

#import "CCText.h"

#import "CCLabelTTF.h"

@implementation CCText

- (void) dealloc {
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self setIgnoreContentAdaptWithSize:YES];
    
    [self setShadowEnabled:NO];
    [self setShadowOpacity:255];
    [self setShadowColor:ccBLACK];
    [self setShadowOffset:CGSizeMake(2, -2)];
    [self setShadowBlurRadius:0];
    
    [self setOutlineEnabled:NO];
    [self setOutlineOpacity:255];
    [self setOutlineColor:ccBLACK];
    [self setOutlineSize:1];
    
    return self;
}

- (void) initRenderer {
    labelRenderer_ = [CCLabelTTF labelWithString:@"Sample text"
                                        fontName:@"Helvetica"
                                        fontSize:12];
    [self addChild:labelRenderer_ z:-1];
}

- (void) setString:(NSString*) string {
//    if ([string isEqualToString:[labelRenderer_ string]]) {
//        return;
//    }
    [labelRenderer_ setString:string];
    [self updateContentSizeWithTextureSize:[labelRenderer_ contentSize]];
    labelRendererAdaptDirty_ = YES;
}

- (NSString*) string {
    return [labelRenderer_ string];
}

- (void) setFontSize:(CGFloat) fontSize {
    [labelRenderer_ setFontSize:fontSize];
    [self updateContentSizeWithTextureSize:[labelRenderer_ contentSize]];
    labelRendererAdaptDirty_ = YES;
}

- (CGFloat) fontSize {
    return [labelRenderer_ fontSize];
}

- (void) setFontName:(NSString*) fontName {
    [labelRenderer_ setFontName:fontName];
    [self updateContentSizeWithTextureSize:[labelRenderer_ contentSize]];
    labelRendererAdaptDirty_ = YES;
}

- (NSString*) fontName {
    return [labelRenderer_ fontName];
}

- (void) setTextAreaSize:(CGSize) size {
    [labelRenderer_ setDimensions:size];
    if ([self ignoreContentAdaptWithSize] == NO) {
        customSize_ = size;
    }
    [self updateContentSizeWithTextureSize:[labelRenderer_ contentSize]];
    labelRendererAdaptDirty_ = YES;
}

- (CGSize) textAreaSize {
    return [labelRenderer_ dimensions];
}

- (void) setTextHorizontalAlignment:(CCTextAlignment) textHorizontalAlignment {
    [labelRenderer_ setHorizontalAlignment:textHorizontalAlignment];
}

- (CCTextAlignment) textHorizontalAlignment {
    return [labelRenderer_ horizontalAlignment];
}

- (void) setTextVerticalAlignment:(CCVerticalTextAlignment) textVerticalAlignment {
    [labelRenderer_ setVerticalAlignment:textVerticalAlignment];
}

- (CCVerticalTextAlignment) textVerticalAlignment {
    return [labelRenderer_ verticalAlignment];
}

- (void) updateTextColorState {
    if ([self outlineEnabled] || [self shadowEnabled]) {
        [labelRenderer_ setFontFillColor:[self textColor] updateImage:YES];
        [labelRenderer_ setColor:ccWHITE];
    } else {
        [labelRenderer_ setColor:[self textColor]];
    }
}

- (void) setTextColor:(ccColor3B) textColor {
    _textColor = textColor;
    [self updateTextColorState];
}

- (void) onSizeChanged {
    [super onSizeChanged];
    labelRendererAdaptDirty_ = YES;
}

- (void) adaptRenderers {
    if (labelRendererAdaptDirty_) {
        [self labelScaleChangedWithSize];
        labelRendererAdaptDirty_ = NO;
    }
}

- (CGSize) virtualRendererSize {
    return [labelRenderer_ contentSize];
}

- (CGSize) autoRenderSize {
    CGSize virtualSize = [labelRenderer_ contentSize];
    if ([self ignoreContentAdaptWithSize] == NO) {
        [labelRenderer_ setDimensions:CGSizeZero];
        virtualSize = [labelRenderer_ contentSize];
        [labelRenderer_ setDimensions:[self contentSize]];        
    }
    return virtualSize;
}

- (void) labelScaleChangedWithSize {
    if ([self ignoreContentAdaptWithSize]) {
        [labelRenderer_ setScale:1];
    } else {
        [labelRenderer_ setDimensions:[self contentSize]];
        CGSize textureSize = [labelRenderer_ contentSize];
        if (textureSize.width <= 0 || textureSize.height <= 0) {
            [labelRenderer_ setScale:1];
            return;
        }
        CGFloat scaleX = [self contentSize].width / textureSize.width;
        CGFloat scaleY = [self contentSize].height / textureSize.height;
        [labelRenderer_ setScaleX:scaleX];
        [labelRenderer_ setScaleY:scaleY];
    }
    [labelRenderer_ setPosition:CGPointMake([self contentSize].width / 2,
                                            [self contentSize].height / 2)];
}

- (void) updateShadowState {
    if ([self shadowEnabled]) {
        [labelRenderer_ enableShadowWithOffset:[self shadowOffset]
                                       opacity:[self shadowOpacity] / 255.0
                                         color:[self shadowColor]
                                          blur:[self shadowBlurRadius]
                                   updateImage:YES];
    } else {
        [labelRenderer_ disableShadowAndUpdateImage:YES];
    }
    [self updateTextColorState];
    [self updateContentSizeWithTextureSize:[labelRenderer_ contentSize]];
    labelRendererAdaptDirty_ = YES;
}

- (void) setShadowEnabled:(BOOL) enabled {
    _shadowEnabled = enabled;
    [self updateShadowState];
}

- (void) setShadowOffset:(CGSize) offset {
    _shadowOffset = offset;
    [self updateShadowState];
}

- (void) setShadowOpacity:(NSInteger) opacity {
    _shadowOpacity = opacity;
    [self updateShadowState];
}

- (void) setShadowColor:(ccColor3B) color {
    _shadowColor = color;
    [self updateShadowState];
}

- (void) setShadowBlurRadius:(NSInteger) blurRadius {
    _shadowBlurRadius = blurRadius;
    [self updateShadowState];
}

- (void) updateOutlineState {
    if ([self outlineEnabled]) {
        [labelRenderer_ enableStrokeWithColor:[self outlineColor]
                                      opacity:[self outlineOpacity] / 255.0
                                         size:[self outlineSize]
                                  updateImage:YES];
    } else {
        [labelRenderer_ disableStrokeAndUpdateImage:YES];
    }
    [self updateTextColorState];
    [self updateContentSizeWithTextureSize:[labelRenderer_ contentSize]];
    labelRendererAdaptDirty_ = YES;
}

- (void) setOutlineEnabled:(BOOL) enabled {
    _outlineEnabled = enabled;
    [self updateOutlineState];
}

- (void) setOutlineOpacity:(NSInteger) opacity {
    _outlineOpacity = opacity;
    [self updateOutlineState];
}

- (void) setOutlineColor:(ccColor3B) color {
    _outlineColor = color;
    [self updateOutlineState];
}

- (void) setOutlineSize:(NSInteger) size {
    _outlineSize = size;
    [self updateOutlineState];
}

@end