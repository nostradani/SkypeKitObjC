/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ObjectBinding.hpp"

#import <skype-embedded_2.h>

#import "SKParticipant.h"

class ParticipantImp : public Participant, public ObjectImp {
public:
    typedef DRef<ParticipantImp, Participant> Ref;
    typedef DRefs<ParticipantImp, Participant> Refs;
    
    ParticipantImp(unsigned int oid, SERootObject* root);
    ~ParticipantImp();

    void OnChange(int prop);
    
protected:
    virtual SEReference coreRef();
};

@interface SKParticipant (Binding)

+ (SKParticipantTextStatus) decodeTextStatus:(Participant::TEXT_STATUS) textStatus;
+ (Participant::TEXT_STATUS) encodeTextStatus:(SKParticipantTextStatus) textStatus;

@property (nonatomic, readonly) ParticipantImp* coreParticipant;

@end
