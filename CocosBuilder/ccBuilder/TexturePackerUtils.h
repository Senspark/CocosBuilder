//
//  TexturePackerUtils.hpp
//  CocosBuilder
//
//  Created by Zinge on 4/5/17.
//
//

#import <Foundation/Foundation.h>

@interface TexturePackerUtils : NSObject

+ (BOOL)pack:(NSString*)src
             destination:(NSString*)dst
    contentProtectionKey:(NSString*)key
                   scale:(CGFloat)scale
            errorMessage:(NSString**)msg;

@end
