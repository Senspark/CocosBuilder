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

#import "CCNodeV3.h"

@class SkeletonAnimation;

@interface CCSkeletonAnimation : CCNodeV3 {
    SkeletonAnimation* skeleton_;

    NSMutableArray<NSString*>* availableSkins_;
    NSMutableArray<NSString*>* availableAnimations_;
}

@property (nonatomic, readonly) SkeletonAnimation* skeleton;

@property (nonatomic, copy) NSString* dataFile;
@property (nonatomic, copy) NSString* atlasFile;
@property (nonatomic) CGFloat animationScale;

@property (nonatomic, readonly) NSArray<NSString*>* animationList;
@property (nonatomic, copy) NSString* animation;
@property (nonatomic, getter=isLoop) BOOL loop;
@property (nonatomic) CGFloat timeScale;

@property (nonatomic, readonly) NSArray<NSString*>* skinList;
@property (nonatomic, copy) NSString* skin;

@property (nonatomic) BOOL debugBonesEnabled;
@property (nonatomic) BOOL debugSlotsEnabled;

@end