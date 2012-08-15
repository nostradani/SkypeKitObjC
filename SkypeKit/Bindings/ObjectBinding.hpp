/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import <Foundation/NSObject.h>
#import "SKObject.h"

#import <skype-embedded_2.h>

class ObjectImp {
private:
    Class _objectClass;
protected:
    SKObject* _objectInstance;
    
    virtual SEReference coreRef() = 0;
    
public:
    ObjectImp(Class objectClass);
    ~ObjectImp();
    
    void unbind();
    void bind();
    
    SKObject* getObjectInstance();
};


@interface SKObject (Binding)

- (void) bindReference:(SEReference) reference;
- (void) unbindReference;

- (SEObject*) object;

- (BOOL) isPropertyCached:(NSString*) propertyName;
- (void) markPropertyAsCached:(NSString*) propertyName;

- (void) onChange:(int) prop;

+ (id) resolve:(SEReference) reference;

@end