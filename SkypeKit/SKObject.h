/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import <Foundation/NSObject.h>

@class ObjectBinding;
@class NSMutableDictionary;
@class SkypeReference;


@interface SKObject : NSObject {
    SkypeReference* _reference;
    NSMutableDictionary* _cachedValues;
}

@end
