/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ContactGroupBinding.hpp"

ContactGroupImp::ContactGroupImp(unsigned int oid, SERootObject* root) : ContactGroup(oid, root), ObjectImp([SKContactGroup class]){
};


void ContactGroupImp::OnChange(ContactRef const&) {
    
};

SEReference ContactGroupImp::coreRef() {
    return this->ref();
}


void ContactGroupImp::OnChange(int prop) {
    [this->_objectInstance onChange:prop];
};

ContactGroupImp::~ContactGroupImp() {
}

@implementation SKContactGroup (Binding)

- (ContactGroupImp*) coreContactGroup {
    return (ContactGroupImp*)[self object];
}

@end