/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ContactSearchBinding.hpp"


ContactSearchImp::ContactSearchImp(unsigned int oid, SERootObject* root) : ContactSearch(oid, root), ObjectImp([SKContactSearch class]){
};

void ContactSearchImp::OnChange(int prop) {
    [this->_objectInstance onChange:prop];
}

void ContactSearchImp::OnNewResult(const ContactRef &contact, const uint &rankValue) {
    [(SKContactSearch*)this->_objectInstance onNewResult:contact rank:rankValue];
}

SEReference ContactSearchImp::coreRef() {
    return this->ref();
}

ContactSearchImp::~ContactSearchImp() {
}

@implementation SKContactSearch (Binding)

- (ContactSearchImp*) coreContactSearch {
    return (ContactSearchImp*)[self object];
}

+ (SKContactSearchStatus) decodeStatus:(ContactSearch::STATUS) status {
    SKContactSearchStatus result = SKContactSearchStatusUnknown;
    
    switch (status) {
        case ContactSearch::CONSTRUCTION :
            result = SKContactSearchStatusConstruction;
            break;
            
        case ContactSearch::PENDING:
            result = SKContactSearchStatusPending;
            break;
            
        case ContactSearch::EXTENDABLE:
            result = SKContactSearchStatusExtendable;
            break;
            
        case ContactSearch::FINISHED:
            result = SKContactSearchStatusFinished;
            break;
            
        case ContactSearch::FAILED:
            result = SKContactSearchStatusFailed;
            break;
            
        default:
            break;
    }
    
    return result;
}

- (void)onNewResult:(const ContactRef &)contact rank:(const uint &)rankValue {
    @autoreleasepool {
        SKContact* object = [SKObject resolve:contact];
        [self.delegate contactSearch:self didGetNewResult:object];
    }
}

@end
