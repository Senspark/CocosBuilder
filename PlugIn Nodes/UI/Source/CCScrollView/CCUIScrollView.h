//
//  CCUiScrollView.h
//  UI
//
//  Created by Zinge on 5/6/16.
//
//

#ifndef CCUiScrollView_h
#define CCUiScrollView_h

#import "CCLayout.h"

typedef NS_ENUM(NSInteger, CCUIScrollViewDirection) {
    CCUIScrollViewDirectionNone,
    CCUIScrollViewDirectionVertical,
    CCUIScrollViewDirectionHorizontal,
    CCUIScrollViewDirectionBoth
};

@interface CCUIScrollView : CCLayout

@property (nonatomic) CCUIScrollViewDirection direction;
@property (nonatomic) BOOL bounceEnabled;
@property (nonatomic) BOOL inertiaScrollEnabled;

@property (nonatomic) BOOL scrollBarEnabled;
@property (nonatomic) CGPoint scrollBarPositionFromCornerForVertical;
@property (nonatomic) CGPoint scrollBarPositionFromCornerForHorizontal;
@property (nonatomic) CGFloat scrollBarWidth;
@property (nonatomic) ccColor3B scrollBarColor;
@property (nonatomic) GLubyte scrollBarOpacity;
@property (nonatomic) BOOL scrollBarAutoHideEnabled;
@property (nonatomic) CGFloat scrollBarAutoHideTime;

- (void) setScrollBarPositionFromCorner:(CGPoint) positionFromCorner;

@property (nonatomic, readonly) CCLayout* innerContainer;
@property (nonatomic) CGSize innerContainerSize;
@property (nonatomic) CGPoint innerContainerPosition;

@end

#endif /* CCUiScrollView_h */
