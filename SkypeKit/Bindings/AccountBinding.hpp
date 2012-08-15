/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ObjectBinding.hpp"

#import "SKAccount.h"

#import <skype-embedded_2.h>

class AccountImp : public Account, public ObjectImp {
public:
    typedef DRef<AccountImp, Account> Ref;
    typedef DRefs<AccountImp, Account> Refs;
    
    AccountImp(unsigned int oid, SERootObject* root);
    ~AccountImp();
    
    void OnChange(int prop);
    
protected:
    virtual SEReference coreRef();
};

@interface SKAccount (Binding)
 
@property (nonatomic, readonly) AccountImp* coreAccount;

@end

