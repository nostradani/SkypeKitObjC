/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKAudioDevice.h"


@implementation SKAudioDevice

@synthesize handle = _handle;
@synthesize name = _name;
@synthesize productId = _productId;

- (id)initWithHandle:(NSString*) aHandle name:(NSString*) aName productId:(NSString*) aProductId {
    self = [super init];
    
    if (self) {
        self->_handle = [aHandle copy];
        self->_name = [aName copy];
        self->_productId = [aProductId copy];
    }
    
    return self;
}

+ (id) deviceWithHandle:(NSString*) aHandle name:(NSString*) aName productId:(NSString*) aProductId {
    return [[[SKAudioDevice alloc] initWithHandle:aHandle name:aName productId:aProductId] autorelease];
}

- (void)dealloc {
    [self->_handle release];
    [self->_name release];
    [self->_productId release];

    [super dealloc];
}

@end
