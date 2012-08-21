/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import <Foundation/NSObject.h>


@interface SKVideoDevice : NSObject {
    NSString* _name;
    NSString* _path;
}

- (id) initWithName:(NSString*) name path:(NSString*) path;
+ (id) deviceWithName:(NSString*) name path:(NSString*) path;

@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* path;

@end
