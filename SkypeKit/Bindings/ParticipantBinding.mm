/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ParticipantBinding.hpp"


ParticipantImp::ParticipantImp(unsigned int oid, SERootObject* root) : Participant(oid, root), ObjectImp([SKParticipant class]){
};

void ParticipantImp::OnChange(int prop) {
    [this->_objectInstance onChange:prop];
};

SEReference ParticipantImp::coreRef() {
    return this->ref();
}

ParticipantImp::~ParticipantImp() {
}

@implementation SKParticipant (Binding)

- (ParticipantImp*) coreParticipant {
    return (ParticipantImp*)[self object];
}

@end

