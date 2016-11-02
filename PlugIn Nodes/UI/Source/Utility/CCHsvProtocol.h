//
//  EEHsvProtocol.h
//  UI
//
//  Created by Zinge on 11/2/16.
//
//

@protocol CCHsvProtocol <NSObject>

@property (nonatomic) CGFloat hue;
@property (nonatomic) CGFloat saturation;
@property (nonatomic) CGFloat brightness;
@property (nonatomic) CGFloat contrast;

@property (nonatomic, readonly) CGFloat displayedBrightness;

@property (nonatomic, getter=isCascadeHsvEnabled) BOOL cascadeHsvEnabled;

- (void)updateDisplayedBrightness:(CGFloat)parentBrightness;

@end
