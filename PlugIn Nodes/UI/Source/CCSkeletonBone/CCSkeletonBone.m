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

#import "CCSkeletonBone.h"
#import "CCSkeletonAnimation.h"

#import "spine/spine-cocos2d-iphone.h"

@implementation CCSkeletonBone

@synthesize boneList = availableBones_;
@synthesize bone = bone_;

- (void) dealloc {
    [availableBones_ release];
    availableBones_ = nil;
    
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    bone_ = nil;
    parentSkeleton_ = nil;
    
    [self scheduleUpdate];
    
    return self;
}

- (void) setParent:(CCNode*) parent {
    [super setParent:parent];
    
    if (parent == nil) {
        parentSkeleton_ = nil;
        [self updateAvailableBones];
    }
    
    if ([parent isKindOfClass:[CCSkeletonAnimation class]]) {
        CCSkeletonAnimation* skeleton = (CCSkeletonAnimation*) parent;
        if (skeleton != parentSkeleton_) {
            parentSkeleton_ = skeleton;
            [self updateAvailableBones];
        }
    }
}

- (void) update:(ccTime) delta {
    if (parentSkeleton_ == nil || [[self bone] length] == 0) {
        return;
    }
    
    spBone* bone = [[parentSkeleton_ skeleton] findBone:[self bone]];
    [self setPosition:CGPointMake(bone->worldX, bone->worldY)];
    [self setRotation:bone->worldRotation];
    [self setScaleX:bone->worldScaleX];
    [self setScaleY:bone->worldScaleY];
}

- (void) updateAvailableBones {
    if (parentSkeleton_ == nil) {
        [availableBones_ removeAllObjects];
        return;
    }
    
    [availableBones_ release];
    availableBones_ = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[parentSkeleton_ skeleton] skeleton]->data->bonesCount; ++i) {
        [availableBones_ addObject:@([[parentSkeleton_ skeleton] skeleton]->data->bones[i]->name)];
    }
}

- (void) setBone:(NSString*) bone {
    if ([bone_ isEqualToString:bone]) {
        return;
    }
    [bone_ autorelease];
    bone_ = [bone copy];
}

@end
