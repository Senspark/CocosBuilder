//
//  CCLayout.h
//  UI
//
//  Created by Zinge on 5/6/16.
//
//

#ifndef CCLayout_h
#define CCLayout_h

#import "CCWidget.h"

@class CCScale9Sprite;
@class CCSpriteFrame;
@class CCLayerColor;

//typedef NS_ENUM(NSInteger, CCLayoutClipping) {
//    CCLayoutClippingTypeStencil,
//    CCLayoutClippingTypeScissor
//};
//
typedef NS_ENUM(NSInteger, CCLayoutBackgroundColor) {
    CCLayoutBackgroundColorNone,
    CCLayoutBackgroundColorSolid
};

@interface CCLayout : CCWidget {
    CCLayerColor*   colorRender_;
}

@property (nonatomic, assign) CCLayoutBackgroundColor backgroundColorType;
@property (nonatomic, assign) ccColor3B backgroundColor;
@property (nonatomic, assign) GLubyte backgroundColorOpacity;

//@property (nonatomic, assign) BOOL backgroundImageScale9Enabled;
//@property (nonatomic, assign) ccColor3B backgroundImageColor;
//@property (nonatomic, assign) GLubyte backgroundImageOpacity;
//
//@property (nonatomic, assign) BOOL clippingEnabled;
//
//- (void) setBackgroundImageWithSprite:(CCScale9Sprite*) sprite;
//- (void) setBackgroundImageWithSpriteFrame:(CCSpriteFrame*) spriteFrame;
//- (void) removeBackgroundImage;
//- (CGSize) backgroundImageTextureSize;

@end

#endif /* CCLayout_h */
