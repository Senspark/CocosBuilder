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

#import "CCWidget.h"

@class CCSpriteWithHSV;
@class CCScale9Sprite;
@class CCScale9SpriteWithHSV;
@class CCLabelTTF;
@class CCSpriteFrame;

typedef NS_ENUM(NSInteger, CCButtonState) {
    CCButtonStateNormal = 1 << 1,
    CCButtonStatePressed = 1 << 2,
    CCButtonStateDisabled = 1 << 3
};

@interface CCButton : CCWidget {
    CCLabelTTF* titleRenderer_;

    CCScale9Sprite* buttonNormalRenderer_;
    CCScale9SpriteWithHSV* buttonPressedRenderer_;
    CCScale9Sprite* buttonDisabledRenderer_;

    CCSpriteFrame* normalFrame_;
    CCSpriteFrame* pressedFrame_;
    CCSpriteFrame* disabledFrame_;

    BOOL normalTextureAdaptDirty_;
    BOOL pressedTextureAdaptDirty_;
    BOOL disabledTextureAdaptDirty_;

    CGSize normalTextureSize_;
    CGSize pressedTextureSize_;
    CGSize disabledTextureSize_;

    BOOL normalTextureLoaded_;
    BOOL pressedTextureLoaded_;
    BOOL disabledTextureLoaded_;

    BOOL prevIgnoreSize_;
}

@property (nonatomic) BOOL pressedActionEnabled;
@property (nonatomic) CGFloat zoomScale;

@property (nonatomic, assign) NSString* titleText;
@property (nonatomic) ccColor3B titleColor;
@property (nonatomic) CGFloat titleFontSize;
@property (nonatomic, assign) NSString* fontName;

@property (nonatomic) BOOL scale9Enabled;

@property (nonatomic) BOOL normalSpriteFrameEnabled;
@property (nonatomic) BOOL pressedSpriteFrameEnabled;
@property (nonatomic) BOOL disabledSpriteFrameEnabled;

@property (nonatomic) CGFloat pressedSpriteFrameBrightness;

@property (nonatomic, readonly) CCLabelTTF* titleRenderer;
@property (nonatomic, readonly) CCScale9Sprite* normalRenderer;
@property (nonatomic, readonly) CCScale9SpriteWithHSV* pressedRenderer;
@property (nonatomic, readonly) CCScale9Sprite* disabledRenderer;

@property (nonatomic, readonly) CGSize normalSize;

@end
