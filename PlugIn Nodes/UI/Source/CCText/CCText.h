//
//  CCText.h
//  UI
//
//  Created by Zinge on 5/5/16.
//
//

#import "CCWidget.h"

@class CCLabelTTF;

@interface CCText : CCWidget {
    CCLabelTTF* labelRenderer_;
    
    BOOL labelRendererAdaptDirty_;
}

@property (nonatomic, assign) NSString* string;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic, assign) NSString* fontName;

@property (nonatomic) BOOL touchScaleChangeEnabled;
@property (nonatomic) CGSize textAreaSize;

@property (nonatomic) CCTextAlignment textHorizontalAlignment;
@property (nonatomic) CCVerticalTextAlignment textVerticalAlignment;

@property (nonatomic) ccColor3B textColor;

@property (nonatomic, readonly) CGSize autoRenderSize;

@property (nonatomic) BOOL shadowEnabled;
@property (nonatomic) GLubyte shadowOpacity;
@property (nonatomic) ccColor3B shadowColor;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic) NSInteger shadowBlurRadius;

@property (nonatomic) BOOL outlineEnabled;
@property (nonatomic) GLubyte outlineOpacity;
@property (nonatomic) ccColor3B outlineColor;
@property (nonatomic) NSInteger outlineSize;

@end