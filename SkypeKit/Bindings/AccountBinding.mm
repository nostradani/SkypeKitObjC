/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "AccountBinding.hpp"

AccountImp::AccountImp(unsigned int oid, SERootObject* root) : ObjectImp([SKAccount class]), Account(oid, root){
};

AccountImp::~AccountImp() {
}

SEReference AccountImp::coreRef() {
    return this->ref();
}

void AccountImp::OnChange(int prop) {
    [this->_objectInstance onChange:prop];
};

@implementation SKAccount (Binding)

- (AccountImp*) coreAccount {
    return (AccountImp*)[self object];
}

@end