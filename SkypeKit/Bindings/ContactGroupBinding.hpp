/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ObjectBinding.hpp"

#import <skype-embedded_2.h>

#import "SKContactGroup.h"

class ContactGroupImp : public ContactGroup, public ObjectImp {
public:
    typedef DRef<ContactGroupImp, ContactGroup> Ref;
    typedef DRefs<ContactGroupImp, ContactGroup> Refs;
    
    ContactGroupImp(unsigned int oid, SERootObject* root);
    ~ContactGroupImp();
    
    void OnChange(const ContactRef& contact);
    void OnChange(int prop);
    
protected:
    virtual SEReference coreRef();
};

@interface SKContactGroup (Binding)

@property (nonatomic, readonly) ContactGroupImp* coreContactGroup;

@end
