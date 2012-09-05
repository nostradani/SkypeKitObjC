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

+ (SKParticipantTextStatus)decodeTextStatus:(Participant::TEXT_STATUS)textStatus {
    SKParticipantTextStatus result = SKParticipantTextStatusTextUnknown;
    
    switch (textStatus) {
        case Participant::TEXT_NA: {
            result = SKParticipantTextStatusTextNA;
            break;
        }
            
        case Participant::READING: {
            result = SKParticipantTextStatusReading;
            break;
        }
            
        case Participant::WRITING: {
            result = SKParticipantTextStatusWriting;
            break;
        }
            
        case Participant::WRITING_AS_ANGRY: {
            result = SKParticipantTextStatusWritingAsAngry;
            break;
        }
            
        case Participant::WRITING_AS_CAT: {
            result = SKParticipantTextStatusWritingAsCat;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

+ (Participant::TEXT_STATUS)encodeTextStatus:(SKParticipantTextStatus)textStatus {
    Participant::TEXT_STATUS result = Participant::TEXT_UNKNOWN;
    
    switch (textStatus) {
        case SKParticipantTextStatusTextNA: {
            result = Participant::TEXT_NA;
            break;
        }
            
        case SKParticipantTextStatusReading: {
            result = Participant::READING;
            break;
        }
            
        case SKParticipantTextStatusWriting: {
            result = Participant::WRITING;
            break;
        }
            
        case SKParticipantTextStatusWritingAsAngry: {
            result = Participant::WRITING_AS_ANGRY;
            break;
        }
            
        case SKParticipantTextStatusWritingAsCat: {
            result = Participant::WRITING_AS_CAT;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

@end

