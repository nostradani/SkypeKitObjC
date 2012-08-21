/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKVideoDevice.h"


@implementation SKVideoDevice

@synthesize path = _path;
@synthesize name = _name;

- (id)initWithName:(NSString *)name path:(NSString *)path {
    self = [super init];
    
    if (self) {
        self->_path = [path copy];
        self->_name = [name copy];
    }
    
    return self;
}

+ (id) deviceWithName:(NSString *)name path:(NSString *)path {
    return [[[SKVideoDevice alloc] initWithName:name path:path] autorelease];
}

- (void)dealloc {
    [self->_path release];
    [self->_name release];

    [super dealloc];
}

@end
