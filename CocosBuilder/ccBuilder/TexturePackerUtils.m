//
//  TexturePackerUtils.cpp
//  CocosBuilder
//
//  Created by Zinge on 4/5/17.
//
//

#import "TexturePackerUtils.h"

@implementation TexturePackerUtils

+ (BOOL)pack:(NSString*)src
             destination:(NSString*)dst
    contentProtectionKey:(NSString*)key
                   scale:(CGFloat)scale
            errorMessage:(NSString**)msg {
    NSString* srcExt = [[src pathExtension] lowercaseString];
    if (![srcExt isEqualToString:@"png"]) {
        // Only pack png.
        return NO;
    }

    if ([key length] == 0) {
        // Missing content protection key.
        return NO;
    }

    NSString* const texturePackerPath = @"/usr/local/bin/texturepacker";
    if (![[NSFileManager defaultManager]
            isExecutableFileAtPath:texturePackerPath]) {
        // Texture Packer command line is not installed.
        return NO;
    }

    NSString* currentDir =
        [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];

    NSString* dummyDataFile =
        [[currentDir stringByAppendingPathComponent:@".texture_packer_data"]
            stringByAppendingPathExtension:@"plist"];

    NSString* temporaryPvrCczFile =
        [dst stringByAppendingPathExtension:@"pvr.ccz"];

    // Attempt to pack the image (for encryption) using texture packer.
    NSTask* task = [[[NSTask alloc] init] autorelease];
    [task setCurrentDirectoryPath:[src stringByDeletingLastPathComponent]];
    [task setLaunchPath:texturePackerPath];

    NSArray* arguments = @[
        @"--format",
        @"cocos2d",
        @"--texture-format",
        @"pvr2ccz",
        @"--content-protection",
        key,
        @"--disable-rotation",
        @"--size-constraints",
        @"AnySize",
        @"--scale",
        [NSString stringWithFormat:@"%.2f", scale],
        @"--scale-mode",
        @"Smooth",
        @"--opt",
        @"RGBA8888",
        @"--trim-mode",
        @"None",
        @"--border-padding",
        @"0",
        @"--shape-padding",
        @"0",
        @"--inner-padding",
        @"0",
        @"--sheet",
        temporaryPvrCczFile,
        @"--data",
        dummyDataFile,
        src
    ];
    [task setArguments:arguments];

    NSPipe* outputPipe = [NSPipe pipe];
    [task setStandardError:outputPipe];
    [task launch];
    [task waitUntilExit];

    NSData* outputData =
        [[outputPipe fileHandleForReading] readDataToEndOfFile];
    NSString* outputError =
        [[[NSString alloc] initWithData:outputData
                               encoding:NSUTF8StringEncoding] autorelease];

    if ([outputError length] > 0) {
        if (msg != nil) {
            *msg = [[outputError copy] autorelease];
        }
    }

    NSError* error = nil;
    [[NSFileManager defaultManager] moveItemAtPath:temporaryPvrCczFile
                                            toPath:dst
                                             error:&error];
    if (error != nil) {
        return NO;
    }

    return YES;
}

@end
