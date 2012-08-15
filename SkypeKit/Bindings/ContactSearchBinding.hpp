/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ObjectBinding.hpp"

#import "SKContactSearch.h"

#import <skype-embedded_2.h>

class ContactSearchImp : public ContactSearch, public ObjectImp {
public:
    typedef DRef<ContactSearchImp, ContactSearch> Ref;
    typedef DRefs<ContactSearchImp, ContactSearch> Refs;
    
    ContactSearchImp(unsigned int oid, SERootObject* root);
    ~ContactSearchImp();
    
    virtual void OnChange(int prop);
    virtual void OnNewResult(const ContactRef &contact, const uint &rankValue);
    
protected:
    virtual SEReference coreRef();
};

@interface SKContactSearch (Binding)

+ (SKContactSearchStatus) decodeStatus:(ContactSearch::STATUS) status;

- (void) onNewResult:(const ContactRef &) contact rank:(const uint &)rankValue;

@property (nonatomic, readonly) ContactSearchImp* coreContactSearch;

@end
