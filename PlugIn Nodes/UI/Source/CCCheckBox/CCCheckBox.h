//
//  CCCheckBox.h
//  UI
//
//  Created by Zinge on 5/27/16.
//
//

#import "CCWidget.h"

@class CCSprite;
@class CCSpriteFrame;

typedef NS_ENUM(NSInteger, CCCheckBoxBackgroundState) {
    CCCheckBoxBackgroundStateNormal     = 1 << 1,
    CCCheckBoxBackgroundStatePressed    = 1 << 2,
    CCCheckBoxBackgroundStateDisabled   = 1 << 3
};

typedef NS_ENUM(NSInteger, CCCheckBoxCrossState) {
    CCCheckBoxCrossStateNormal    = 1 << 1,
    CCCheckBoxCrossStateDisabled  = 1 << 2
};

@interface CCCheckBox : CCWidget {
    NSMutableDictionary<NSNumber*, CCSprite*>* backgroundRenderers_;
    NSMutableDictionary<NSNumber*, NSNumber*>* backgroundRenderersEnabled_;
    NSMutableDictionary<NSNumber*, NSNumber*>* backgroundRenderersAdaptDirty_;
    
    NSMutableDictionary<NSNumber*, CCSprite*>* crossRenderers_;
    NSMutableDictionary<NSNumber*, NSNumber*>* crossRenderersEnabled_;
    NSMutableDictionary<NSNumber*, NSNumber*>* crossRenderersAdaptDirty_;
}

@property (nonatomic) BOOL selected;
@property (nonatomic) CGFloat zoomScale;

@property (nonatomic) BOOL normalBackgroundSpriteFrameEnabled;
@property (nonatomic) BOOL pressedBackgroundSpriteFrameEnabled;
@property (nonatomic) BOOL disabledBackgroundSpriteFrameEnabled;


- (void) setBackgroundSpriteEnabled:(BOOL) enabled
                           forState:(CCCheckBoxBackgroundState) state;

- (BOOL) backgroundSpriteEnabledForState:(CCCheckBoxBackgroundState) state;

- (void) setBackgroundSprite:(CCSprite*) sprite
                    forState:(CCCheckBoxBackgroundState) state;

- (void) setBackgroundSpriteFrame:(CCSpriteFrame*) spriteFrame
                         forState:(CCCheckBoxBackgroundState) state;

- (CCSprite*) backgroundSpriteForState:(CCCheckBoxBackgroundState) state;

@property (nonatomic) BOOL normalCrossSpriteFrameEnabled;
@property (nonatomic) BOOL disabledCrossSpriteFrameEnabled;

- (void) setCrossSpriteFrameEnabled:(BOOL) enabled
                           forState:(CCCheckBoxCrossState) state;

- (BOOL) crossSpriteEnabledForState:(CCCheckBoxCrossState) state;

- (void) setCrossSprite:(CCSprite*) sprite
               forState:(CCCheckBoxCrossState) state;

- (void) setCrossSpriteFrame:(CCSpriteFrame*) spriteFrame
                    forState:(CCCheckBoxCrossState) state;

- (CCSprite*) crossSpriteForState:(CCCheckBoxCrossState) state;

@end