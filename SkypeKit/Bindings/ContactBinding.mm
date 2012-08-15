/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ContactBinding.hpp"
#import "SKContact.h"


ContactImp::ContactImp(unsigned int oid, SERootObject* root) : Contact(oid, root), ObjectImp([SKContact class]){
};

void ContactImp::OnChange(int prop) {
    [this->_objectInstance onChange:prop];
};

SEReference ContactImp::coreRef() {
    return this->ref();
}

ContactImp::~ContactImp() {
}

@implementation SKContact (Binding)

- (ContactImp*) coreContact {
    return (ContactImp*)[self object];
}

+ (SKContactAvailability) decodeAvailability:(Contact::AVAILABILITY) availability {
    SKContactAvailability result = SKContactAvailabilityUnknown;
    
    switch (availability) {
        case Contact::PENDINGAUTH:
            result = SKContactAvailabilityPendingAuthentication;
            break;
            
        case Contact::BLOCKED:
            result = SKContactAvailabilityBlocked;
            break;
            
        case Contact::BLOCKED_SKYPEOUT:
            result = SKContactAvailabilityBlockedSkypeOut;
            break;
            
        case Contact::SKYPEOUT:
            result = SKContactAvailabilitySkypeOut;
            break;
            
        case Contact::OFFLINE:
            result = SKContactAvailabilityOffline;
            break;
            
        case Contact::OFFLINE_BUT_VM_ABLE:
            result = SKContactAvailabilityOfflineVoiceMail;
            break;
            
        case Contact::OFFLINE_BUT_CF_ABLE:
            result = SKContactAvailabilityOfflineCallForwarding;
            break;
            
        case Contact::ONLINE:
            result = SKContactAvailabilityOnline;
            break;
            
        case Contact::AWAY:
            result = SKContactAvailabilityAway;
            break;
            
        case Contact::NOT_AVAILABLE:
            result = SKContactAvailabilityNotAvailable;
            break;
            
        case Contact::DO_NOT_DISTURB:
            result = SKContactAvailabilityDoNotDisturb;
            break;
            
        case Contact::SKYPE_ME:
            result = SKContactAvailabilitySkypeMe;
            break;
            
        case Contact::INVISIBLE:
            result = SKContactAvailabilityInvisible;
            break;
            
        case Contact::CONNECTING:
            result = SKContactAvailabilityConnecting;
            break;
            
        case Contact::ONLINE_FROM_MOBILE:
            result = SKContactAvailabilityOnlineFromMobile;
            break;
            
        case Contact::AWAY_FROM_MOBILE:
            result = SKContactAvailabilityAwayFromMobile;
            break;
            
        case Contact::NOT_AVAILABLE_FROM_MOBILE:
            result = SKContactAvailabilityNotAvailableFromMobile;
            break;
            
        case Contact::DO_NOT_DISTURB_FROM_MOBILE:
            result = SKContactAvailabilityDoNotDisturbFromMobile;
            break;
            
        case Contact::SKYPE_ME_FROM_MOBILE:
            result = SKContactAvailabilitySkypeMeFromMobile;
            break;
            
        default:
            break;
    }
    
    return result;
}

+ (Contact::AVAILABILITY) encodeAvailability:(SKContactAvailability) availability {
    Contact::AVAILABILITY result = Contact::UNKNOWN;
    
    switch (availability) {
        case SKContactAvailabilityPendingAuthentication:
            result = Contact::PENDINGAUTH;
            break;
            
        case SKContactAvailabilityBlocked:
            result = Contact::BLOCKED;
            break;
            
        case SKContactAvailabilityBlockedSkypeOut:
            result = Contact::BLOCKED_SKYPEOUT;
            break;
            
        case SKContactAvailabilitySkypeOut:
            result = Contact::SKYPEOUT;
            break;
            
        case SKContactAvailabilityOffline:
            result = Contact::OFFLINE;
            break;
            
        case SKContactAvailabilityOfflineVoiceMail:
            result = Contact::OFFLINE_BUT_VM_ABLE;
            break;
            
        case SKContactAvailabilityOfflineCallForwarding:
            result = Contact::OFFLINE_BUT_CF_ABLE;
            break;
            
        case SKContactAvailabilityOnline:
            result = Contact::ONLINE;
            break;
            
        case SKContactAvailabilityAway:
            result = Contact::AWAY;
            break;
            
        case SKContactAvailabilityNotAvailable:
            result = Contact::NOT_AVAILABLE;
            break;
            
        case SKContactAvailabilityDoNotDisturb:
            result = Contact::DO_NOT_DISTURB;
            break;
            
        case SKContactAvailabilitySkypeMe:
            result = Contact::SKYPE_ME;
            break;
            
        case SKContactAvailabilityInvisible:
            result = Contact::INVISIBLE;
            break;
            
        case SKContactAvailabilityConnecting:
            result = Contact::CONNECTING;
            break;
            
        case SKContactAvailabilityOnlineFromMobile:
            result = Contact::ONLINE_FROM_MOBILE;
            break;
            
        case SKContactAvailabilityAwayFromMobile:
            result = Contact::AWAY_FROM_MOBILE;
            break;
            
        case SKContactAvailabilityNotAvailableFromMobile:
            result = Contact::NOT_AVAILABLE_FROM_MOBILE;
            break;
            
        case SKContactAvailabilityDoNotDisturbFromMobile:
            result = Contact::DO_NOT_DISTURB_FROM_MOBILE;
            break;
            
        case SKContactAvailabilitySkypeMeFromMobile:
            result = Contact::SKYPE_ME_FROM_MOBILE;
            break;
            
        default:
            break;
    }
    
    return result;
}

@end
