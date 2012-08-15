/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKObject.h"

#import <Foundation/Foundation.h>

#import "ObjectBinding.hpp"

@interface SkypeReference : NSObject {
    SEReference _objectRef;
}

@property (nonatomic, readwrite) SEReference objectRef;

@end

@implementation SkypeReference

@synthesize objectRef = _objectRef;

- (void)dealloc {
    self->_objectRef = NULL;
    
    [super dealloc];
}

@end

@implementation SKObject
    
- (id) init {
    self = [super init];
    
    if (self != nil) {
        self->_cachedValues = [NSMutableDictionary new];
    }
    
    return self;
}

- (BOOL) isPropertyCached:(NSString*) propertyName {
    return [[self->_cachedValues objectForKey:propertyName] boolValue];
}

- (void) markPropertyAsCached:(NSString*) propertyName {
    [self->_cachedValues setObject:[NSNumber numberWithBool:YES] forKey:propertyName];
}

- (void) onChange:(int) prop {
    
}

- (SEObject*) object {
    return self->_reference.objectRef.fetch();
}

- (void) dealloc {
    [self unbindReference];

    [self->_cachedValues release];
    
    [super dealloc];
}

+ (id)resolve:(SEReference)reference {
    ObjectImp* object = dynamic_cast<ObjectImp*>(reference.fetch());
    return object->getObjectInstance();
}

- (void)bindReference:(SEReference)reference {
    [self->_reference release];
    self->_reference = [[SkypeReference alloc] init];
    self->_reference.objectRef = reference;
}

- (void)unbindReference {
    ObjectImp* object = dynamic_cast<ObjectImp*>(self->_reference.objectRef.fetch());
    object->unbind();
    
    self->_reference.objectRef = NULL;
}

@end
