/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ObjectBinding.hpp"

#import <skype-object.h>

#import "SKObject.h"

ObjectImp::ObjectImp(Class objectClass){
    this->_objectInstance = nil;
    this->_objectClass = objectClass;
}

ObjectImp::~ObjectImp() {
    this->_objectInstance = nil;
}

SKObject* ObjectImp::getObjectInstance() {
    if (this->_objectInstance == nil) {
        this->_objectInstance = [[[this->_objectClass alloc] init] autorelease];
        this->bind();
    }    
    
    return this->_objectInstance;
}

void ObjectImp::bind() {
    SEReference reference = this->coreRef();
    [this->_objectInstance bindReference:reference];
}

void ObjectImp::unbind() {
    this->_objectInstance = nil;
}
