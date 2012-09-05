/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ObjectBinding.hpp"

#import <skype-object.h>

#import "SKObject.h"

ObjectImp::ObjectImp(Class objectClass, SERootObject* skype){
    this->_objectInstance = nil;
    this->_objectClass = objectClass;
    this->_skype = dynamic_cast<Skype*>(skype);
}

ObjectImp::~ObjectImp() {
    this->_objectInstance = nil;
}

Skype* ObjectImp::getSkype() {
    return this->_skype;
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
