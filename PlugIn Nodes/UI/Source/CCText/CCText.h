//
//  CCText.h
//  UI
//
//  Created by Zinge on 5/5/16.
//
//

#ifndef CCText_h
#define CCText_h

#import "CCWidget.h"

@class CCLabelTTF;

@interface CCText : CCWidget {
    CCLabelTTF* labelRenderer_;
    
    BOOL labelRendererAdaptDirty_;
}

@property (nonatomic, assign) NSString* string;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) NSString* fontName;

@property (nonatomic, assign) BOOL touchScaleChangeEnabled;
@property (nonatomic, assign) CGSize textAreaSize;

@property (nonatomic, assign) CCTextAlignment textHorizontalAlignment;
@property (nonatomic, assign) CCVerticalTextAlignment textVerticalAlignment;

@property (nonatomic, assign) ccColor3B textColor;

@property (nonatomic, readonly) CGSize autoRenderSize;

@property (nonatomic, assign) BOOL shadowEnabled;
@property (nonatomic, assign) NSInteger shadowOpacity;
@property (nonatomic, assign) ccColor3B shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) NSInteger shadowBlurRadius;

@property (nonatomic, assign) BOOL outlineEnabled;
@property (nonatomic, assign) NSInteger outlineOpacity;
@property (nonatomic, assign) ccColor3B outlineColor;
@property (nonatomic, assign) NSInteger outlineSize;

@end

#endif /* CCText_h */
