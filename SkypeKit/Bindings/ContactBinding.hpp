/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ObjectBinding.hpp"

#import "SKContact.h"

#import <skype-embedded_2.h>

class ContactImp : public Contact, public ObjectImp{
public:
    typedef DRef<ContactImp, Contact> Ref;
    typedef DRefs<ContactImp, Contact> Refs;
    
    ContactImp(unsigned int oid, SERootObject* root);
    ~ContactImp();
    
    void OnChange(int prop);
    
protected:
    virtual SEReference coreRef();
};

@interface SKContact (Binding)

@property (nonatomic, readonly) ContactImp* coreContact;

+ (SKContactAvailability) decodeAvailability:(Contact::AVAILABILITY) availability;
+ (Contact::AVAILABILITY) encodeAvailability:(SKContactAvailability) availability;

@end

