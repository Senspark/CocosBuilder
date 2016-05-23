/*
 * CocosBuilder: http://www.cocosbuilder.com
 *
 * Copyright (c) 2012 Zynga Inc.
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

#import "InspectorListBox.h"
#import "TexturePropertySetter.h"
#import "CCBGlobals.h"
#import "ResourceManager.h"
#import "ResourceManagerUtil.h"
#import "CocosBuilderAppDelegate.h"
#import "CCNode+NodeInfo.h"

@implementation InspectorListBox

- (void) willBeAdded {
//    NSString* sf = [selection extraPropForKey:propertyName];
    
    [self refresh];
}

- (void) selectedResource:(id) sender {
    NSString* itemName = [sender title];
    
    NSString* propName = [[propertyName componentsSeparatedByString:@"|"] objectAtIndex:0];
    if (itemName != nil) {
        [selection setExtraProp:itemName forKey:propName];
        [selection setValue:itemName forKey:propName];
    }
    
    [self updateAffectedProperties];
}

- (void) refresh {
    NSString* propName = [[propertyName componentsSeparatedByString:@"|"] objectAtIndex:0];
    NSString* listPropName = [[propertyName componentsSeparatedByString:@"|"] objectAtIndex:1];
    
    NSMenu* menu = [popup menu];
    [menu removeAllItems];
    
    NSArray<NSString*>* list = [selection valueForKey:listPropName];
    for (NSString* itemName in list) {
        NSMenuItem* menuItem = [[NSMenuItem alloc] initWithTitle:itemName
                                                          action:@selector(selectedResource:)
                                                   keyEquivalent:@""];
        [menuItem setTarget:self];
        [menu addItem:menuItem];
    }
    
    NSString* selected = [selection valueForKey:propName];
    [popup setTitle:selected];
}

@end
