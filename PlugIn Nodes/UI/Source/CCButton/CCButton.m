/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "CCButton.h"
#import "CCScale9Sprite.h"
#import "ShaderUtils.h"
#import "cocos2d.h"

#include "ColorUtils.h"

const NSInteger kBackgroundSpriteZOrder = -2;
const NSInteger kTitleZOrder = -1;

@implementation CCButton

@synthesize normalRenderer = buttonNormalRenderer_;
@synthesize pressedRenderer = buttonPressedRenderer_;
@synthesize disabledRenderer = buttonDisabledRenderer_;

- (void)dealloc {
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }

    _zoomScale = 0.1;
    prevIgnoreSize_ = YES;
    _scale9Enabled = NO;
    _pressedActionEnabled = NO;

    [self setInsetLeft:0];
    [self setInsetTop:0];
    [self setInsetRight:0];
    [self setInsetBottom:0];

    normalTextureAdaptDirty_ = YES;
    pressedTextureAdaptDirty_ = YES;
    disabledTextureAdaptDirty_ = YES;

    normalTextureLoaded_ = NO;
    pressedTextureLoaded_ = NO;
    disabledTextureLoaded_ = NO;

    [self setTouchEnabled:YES];
    [self setSwallowTouches:YES];

    [self createTitleRenderer];

    return self;
}

- (void)initRenderer {
    buttonNormalRenderer_ = [[[CCScale9Sprite alloc] init] autorelease];
    buttonPressedRenderer_ = [[[CCScale9Sprite alloc] init] autorelease];
    buttonDisabledRenderer_ = [[[CCScale9Sprite alloc] init] autorelease];

    [self addChild:buttonNormalRenderer_ z:kBackgroundSpriteZOrder];
    [self addChild:buttonPressedRenderer_ z:kBackgroundSpriteZOrder];
    [self addChild:buttonDisabledRenderer_ z:kBackgroundSpriteZOrder];
}

- (void)createTitleRenderer {
    titleRenderer_ =
        [CCLabelTTF labelWithString:@"Title" fontName:@"Helvetica" fontSize:12];
    [titleRenderer_ setAnchorPoint:CGPointMake(0.5, 0.5)];
    [self addChild:titleRenderer_ z:kTitleZOrder];
}

- (void)setupNormalTexture:(BOOL)textureLoaded {
    normalTextureSize_ = [buttonNormalRenderer_ contentSize];
    [self updateChildrenDisplayRGBA];
    if ([self unifySizeEnabled]) {
        if ([self scale9Enabled] == NO) {
            [self updateContentSizeWithTextureSize:[self normalSize]];
        }
    } else {
        [self updateContentSizeWithTextureSize:normalTextureSize_];
    }
    normalTextureLoaded_ = textureLoaded;
    normalTextureAdaptDirty_ = YES;
}

- (void)setupPressedTexture:(BOOL)textureLoaded {
    pressedTextureSize_ = [buttonPressedRenderer_ contentSize];
    [self updateChildrenDisplayRGBA];
    pressedTextureLoaded_ = textureLoaded;
    pressedTextureAdaptDirty_ = YES;
}

- (void)setupDisabledTexture:(BOOL)textureLoaded {
    disabledTextureSize_ = [buttonDisabledRenderer_ contentSize];
    [self updateChildrenDisplayRGBA];
    disabledTextureLoaded_ = textureLoaded;
    disabledTextureAdaptDirty_ = YES;
}

- (void)onPressStateChangedToNormal {
    [buttonNormalRenderer_ setVisible:YES];
    [buttonPressedRenderer_ setVisible:NO];
    [buttonDisabledRenderer_ setVisible:NO];
    ///
}

- (void)onPressStateChangedToPressed {
    if (pressedTextureLoaded_) {
        [buttonNormalRenderer_ setVisible:NO];
        [buttonPressedRenderer_ setVisible:YES];
        [buttonDisabledRenderer_ setVisible:NO];
    } else {
        [buttonNormalRenderer_ setVisible:YES];
        [buttonPressedRenderer_ setVisible:YES];
        [buttonDisabledRenderer_ setVisible:NO];
    }
}

- (void)onPressStateChangedToDisabled {
    if (disabledTextureLoaded_ == NO) {
        if (normalTextureLoaded_) {
            ///
        }
    } else {
        [buttonNormalRenderer_ setVisible:NO];
        [buttonDisabledRenderer_ setVisible:YES];
    }
    [buttonPressedRenderer_ setVisible:NO];
}

- (void)updateTitleLocation {
    CGFloat width = [self contentSize].width;
    CGFloat height = [self contentSize].height;
    [titleRenderer_ setPosition:CGPointMake(width / 2, height / 2)];
}

- (void)updateContentSize {
    if ([self unifySizeEnabled]) {
        if ([self scale9Enabled]) {
            [super setContentSize_super:[self customSize]];
        } else {
            CGSize s = [self normalSize];
            [super setContentSize_super:s];
        }
        return [self onSizeChanged];
    }
    if ([self ignoreContentAdaptWithSize]) {
        [self setContentSize:[self virtualRendererSize]];
    }
}

- (void)onSizeChanged {
    [super onSizeChanged];
    [self updateTitleLocation];
    normalTextureAdaptDirty_ = YES;
    pressedTextureAdaptDirty_ = YES;
    disabledTextureAdaptDirty_ = YES;

    [self textureScaleChangedWithSize:buttonNormalRenderer_];
}

- (void)adaptRenderers {
    if (normalTextureAdaptDirty_) {
        [self textureScaleChangedWithSize:buttonNormalRenderer_];
        normalTextureAdaptDirty_ = NO;
    }
    if (pressedTextureAdaptDirty_) {
        [self textureScaleChangedWithSize:buttonPressedRenderer_];
        pressedTextureAdaptDirty_ = NO;
    }
    if (disabledTextureAdaptDirty_) {
        [self textureScaleChangedWithSize:buttonDisabledRenderer_];
        disabledTextureAdaptDirty_ = NO;
    }
}

- (void)textureScaleChangedWithSize:(CCScale9Sprite*)button {
    CGFloat width = [self contentSize].width;
    CGFloat height = [self contentSize].height;

    CGFloat originalWidth = [button originalSize].width;
    CGFloat originalHeight = [button originalSize].height;

    if (originalWidth < width) {
        [button setInsetLeft:originalWidth / 3];
        [button setInsetRight:originalWidth / 3];
    } else {
        [button setInsetLeft:width / 3];
        [button setInsetRight:width / 3];
    }

    if (originalHeight < height) {
        [button setInsetTop:originalHeight / 3];
        [button setInsetBottom:originalHeight / 3];
    } else {
        [button setInsetTop:height / 3];
        [button setInsetBottom:height / 3];
    }

    [button setPreferedSize:[self contentSize]];

    //    [button setPosition:CGPointMake([self contentSize].width / 2,
    //                                    [self contentSize].height / 2)];
}

- (void)setTitleText:(NSString*)text {
    if ([text isEqualToString:[self titleText]]) {
        return;
    }
    [titleRenderer_ setString:text];
    [self updateContentSize];
    [self updateTitleLocation];
}

- (NSString*)titleText {
    return [titleRenderer_ string];
}

- (void)setTitleColor:(ccColor3B)color {
    [titleRenderer_ setColor:color];
}

- (ccColor3B)titleColor {
    return [titleRenderer_ color];
}

- (void)setTitleFontSize:(CGFloat)size {
    [titleRenderer_ setFontSize:size];
    [self updateContentSize];
}

- (CGFloat)titleFontSize {
    return [titleRenderer_ fontSize];
}

- (void)setTitleAnchorPoint:(CGPoint)anchorPoint {
    [titleRenderer_ setAnchorPoint:anchorPoint];
}

- (CGPoint)titleAnchorPoint {
    return [titleRenderer_ anchorPoint];
}

- (void)setTitleFontName:(NSString*)fontName {
    if ([fontName length] > 0) {
        [titleRenderer_ setFontName:fontName];
        [self updateContentSize];
    }
}

- (NSString*)titleFontName {
    return [titleRenderer_ fontName];
}

- (void)setIgnoreContentAdaptWithSize:(BOOL)ignore {
    if ([self unifySizeEnabled]) {
        return [self updateContentSize];
    }
    if ([self scale9Enabled] == NO || ([self scale9Enabled] && ignore == NO)) {
        [super setIgnoreContentAdaptWithSize:ignore];
        prevIgnoreSize_ = ignore;
    }
}

- (void)setScale9Enabled:(BOOL)enabled {
    if ([self scale9Enabled] == enabled) {
        return;
    }
    _scale9Enabled = enabled;
    if ([self scale9Enabled]) {
        BOOL ignoreBefore = [self ignoreContentAdaptWithSize];
        [self setIgnoreContentAdaptWithSize:NO];
        prevIgnoreSize_ = ignoreBefore;
    } else {
        [self setIgnoreContentAdaptWithSize:prevIgnoreSize_];
    }
    brightStyle_ = CCWidgetBrightStyleNone;
    [self setBright:[self bright]];

    normalTextureAdaptDirty_ = YES;
    pressedTextureAdaptDirty_ = YES;
    disabledTextureAdaptDirty_ = YES;
}

- (void)setInsetLeft:(CGFloat)inset {
    _insetLeft = inset;
    if ([self normalSpriteFrameEnabled]) {
        [buttonNormalRenderer_ setInsetLeft:inset];
    }
    if ([self pressedSpriteFrameEnabled]) {
        [buttonPressedRenderer_ setInsetLeft:inset];
    }
    if ([self disabledSpriteFrameEnabled]) {
        [buttonDisabledRenderer_ setInsetLeft:inset];
    }
}

- (void)setInsetTop:(CGFloat)inset {
    _insetTop = inset;
    if ([self normalSpriteFrameEnabled]) {
        [buttonNormalRenderer_ setInsetTop:inset];
    }
    if ([self pressedSpriteFrameEnabled]) {
        [buttonPressedRenderer_ setInsetTop:inset];
    }
    if ([self disabledSpriteFrameEnabled]) {
        [buttonDisabledRenderer_ setInsetTop:inset];
    }
}

- (void)setInsetRight:(CGFloat)inset {
    _insetRight = inset;
    if ([self normalSpriteFrameEnabled]) {
        [buttonNormalRenderer_ setInsetRight:inset];
    }
    if ([self pressedSpriteFrameEnabled]) {
        [buttonPressedRenderer_ setInsetRight:inset];
    }
    if ([self disabledSpriteFrameEnabled]) {
        [buttonDisabledRenderer_ setInsetRight:inset];
    }
}

- (void)setInsetBottom:(CGFloat)inset {
    _insetBottom = inset;
    if ([self normalSpriteFrameEnabled]) {
        [buttonNormalRenderer_ setInsetBottom:inset];
    }
    if ([self pressedSpriteFrameEnabled]) {
        [buttonPressedRenderer_ setInsetBottom:inset];
    }
    if ([self disabledSpriteFrameEnabled]) {
        [buttonDisabledRenderer_ setInsetBottom:inset];
    }
}

- (void)updateInsets:(CCScale9Sprite*)renderer {
    [renderer setInsetLeft:[self insetLeft]];
    [renderer setInsetTop:[self insetTop]];
    [renderer setInsetRight:[self insetRight]];
    [renderer setInsetBottom:[self insetBottom]];
}

- (CCNode*)virtualRenderer {
    if ([self bright]) {
        switch (brightStyle_) {
        case CCWidgetBrightStyleNormal:
            return [self normalRenderer];
        case CCWidgetBrightStyleHighlight:
            return [self pressedRenderer];
        default:
            return nil;
        }
    }
    return [self disabledRenderer];
}

- (CGSize)virtualRendererSize {
    if ([self unifySizeEnabled]) {
        return [self normalSize];
    }
    CGSize titleSize = [titleRenderer_ contentSize];
    if (normalTextureLoaded_ == NO && [[titleRenderer_ string] length] > 0) {
        return titleSize;
    }
    return normalTextureSize_;
}

- (void)resetNormalRenderer {
    normalTextureSize_ = CGSizeZero;
    normalTextureLoaded_ = NO;
    normalTextureAdaptDirty_ = NO;
}

- (void)resetPressedRenderer {
    pressedTextureSize_ = CGSizeZero;
    pressedTextureLoaded_ = NO;
    pressedTextureAdaptDirty_ = NO;
}

- (void)resetDisabledRenderer {
    disabledTextureSize_ = CGSizeZero;
    disabledTextureLoaded_ = NO;
    disabledTextureAdaptDirty_ = NO;
}

- (CCLabelTTF*)titleRenderer {
    return titleRenderer_;
}

- (CGSize)normalSize {
    CGSize titleSize = [titleRenderer_ contentSize];
    CGSize imageSize = [[self normalRenderer] contentSize];
    return CGSizeMake(max(titleSize.width, imageSize.width),
                      max(titleSize.height, imageSize.height));
}

- (void)setNormalSpriteFrameEnabled:(BOOL)enabled {
    _normalSpriteFrameEnabled = enabled;
    [buttonNormalRenderer_ setVisible:enabled];
    if (enabled) {
        [self setNormalSpriteFrame:normalFrame_];
    } else {
        [self resetNormalRenderer];
    }
    [self updateContentSize];
}

- (void)setPressedSpriteFrameEnabled:(BOOL)enabled {
    _pressedSpriteFrameEnabled = enabled;
    [buttonPressedRenderer_ setVisible:enabled];
    if (enabled) {
        [self setPressedSpriteFrame:pressedFrame_];
    } else {
        [self resetPressedRenderer];
    }
}

- (void)setDisabledSpriteFrameEnabled:(BOOL)enabled {
    _disabledSpriteFrameEnabled = enabled;
    [buttonDisabledRenderer_ setVisible:enabled];
    if (enabled) {
        [self setDisabledSpriteFrame:disabledFrame_];
    } else {
        [self resetDisabledRenderer];
    }
}

- (void)setNormalSpriteFrame:(CCSpriteFrame*)frame {
    NSCAssert(frame != nil, @"...");
    [normalFrame_ autorelease];
    normalFrame_ = [frame retain];
    [buttonNormalRenderer_ setSpriteFrame:frame];
    [buttonNormalRenderer_ setVisible:[self normalSpriteFrameEnabled]];
    [self updateInsets:buttonNormalRenderer_];
    [self setupNormalTexture:YES];
}

- (void)setPressedSpriteFrame:(CCSpriteFrame*)frame {
    NSCAssert(frame != nil, @"...");
    [pressedFrame_ autorelease];
    pressedFrame_ = [frame retain];
    [buttonPressedRenderer_ setSpriteFrame:frame];
    [buttonPressedRenderer_ setVisible:[self pressedSpriteFrameEnabled]];
    [self updateInsets:buttonPressedRenderer_];
    [self setupPressedTexture:YES];
}

- (void)setDisabledSpriteFrame:(CCSpriteFrame*)frame {
    NSCAssert(frame != nil, @"...");
    [disabledFrame_ autorelease];
    disabledFrame_ = [frame retain];
    [buttonDisabledRenderer_ setSpriteFrame:frame];
    [buttonDisabledRenderer_ setVisible:[self disabledSpriteFrameEnabled]];
    [self updateInsets:buttonDisabledRenderer_];
    [self setupDisabledTexture:YES];
}

@end
