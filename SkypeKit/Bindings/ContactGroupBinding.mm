/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ContactGroupBinding.hpp"

ContactGroupImp::ContactGroupImp(unsigned int oid, SERootObject* root) : ContactGroup(oid, root), ObjectImp([SKContactGroup class], root){
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

- (void) onContactChange:(const ContactRef&) contact {
    @autoreleasepool {
        [self.delegate contactGroup:self didAddContact:[SKObject resolve:contact->ref()]];
    }
}

+ (SKContactGroupType)decodeType:(ContactGroup::TYPE)type {
    SKContactGroupType result = SKContactGroupTypeUndefined;
    
    switch (type) {
        case ContactGroup::ALL_KNOWN_CONTACTS: {
            result = SKContactGroupTypeAllKnownContacts;
            break;
        }
            
        case ContactGroup::ALL_BUDDIES: {
            result = SKContactGroupTypeAllBuddies;
            break;
        }
            
        case ContactGroup::CONTACTS_AUTHORIZED_BY_ME: {
            result = SKContactGroupTypeContactsAuthorizedByMe;
            break;
        }
            
        case ContactGroup::CONTACTS_BLOCKED_BY_ME: {
            result = SKContactGroupTypeContactsBlockedByMe;
            break;
        }
            
        case ContactGroup::CONTACTS_WAITING_MY_AUTHORIZATION: {
            result = SKContactGroupTypeContactsWaitingMyAuthorization;
            break;
        }
            
        case ContactGroup::CUSTOM_GROUP: {
            result = SKContactGroupTypeCustomGroup;
            break;
        }
            
        case ContactGroup::EXTERNAL_CONTACTS: {
            result = SKContactGroupTypeExternalContacts;
            break;
        }
            
        case ContactGroup::ONLINE_BUDDIES: {
            result = SKContactGroupTypeOnlineBuddies;
            break;
        }
            
        case ContactGroup::PROPOSED_SHARED_GROUP: {
            result = SKContactGroupTypeProposedSharedGroup;
            break;
        }
            
        case ContactGroup::RECENTLY_CONTACTED_CONTACTS: {
            result = SKContactGroupTypeRecentlyContactedContacts;
            break;
        }
            
        case ContactGroup::SHARED_GROUP: {
            result = SKContactGroupTypeSharedGroup;
            break;
        }
            
        case ContactGroup::SKYPE_BUDDIES: {
            result = SKContactGroupTypeSkypeBuddies;
            break;
        }
            
        case ContactGroup::SKYPEOUT_BUDDIES : {
            result = SKContactGroupTypeSkypeOutBuddies;
            break;
        }
            
        case ContactGroup::UNGROUPED_BUDDIES: {
            result = SKContactGroupTypeUngroupedBuddies;
            break;
        }
            
        case ContactGroup::UNKNOWN_OR_PENDINGAUTH_BUDDIES: {
            result = SKContactGroupTypeUnknownOrPendingAuthBuddies;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

+ (ContactGroup::TYPE)encodeType:(SKContactGroupType)type {
    ContactGroup::TYPE result = ContactGroup::ALL_KNOWN_CONTACTS;
    
    switch (type) {
        case SKContactGroupTypeAllKnownContacts: {
            result = ContactGroup::ALL_KNOWN_CONTACTS;
            break;
        }
            
        case SKContactGroupTypeAllBuddies: {
            result = ContactGroup::ALL_BUDDIES;
            break;
        }
            
        case SKContactGroupTypeContactsAuthorizedByMe: {
            result = ContactGroup::CONTACTS_AUTHORIZED_BY_ME;
            break;
        }
            
        case SKContactGroupTypeContactsBlockedByMe: {
            result = ContactGroup::CONTACTS_BLOCKED_BY_ME;
            break;
        }
            
        case SKContactGroupTypeContactsWaitingMyAuthorization: {
            result = ContactGroup::CONTACTS_WAITING_MY_AUTHORIZATION;
            break;
        }
            
        case SKContactGroupTypeCustomGroup: {
            result = ContactGroup::CUSTOM_GROUP;
            break;
        }
            
        case SKContactGroupTypeExternalContacts: {
            result = ContactGroup::EXTERNAL_CONTACTS;
            break;
        }
            
        case SKContactGroupTypeOnlineBuddies: {
            result = ContactGroup::ONLINE_BUDDIES;
            break;
        }
            
        case SKContactGroupTypeProposedSharedGroup: {
            result = ContactGroup::PROPOSED_SHARED_GROUP;
            break;
        }
            
        case SKContactGroupTypeRecentlyContactedContacts: {
            result = ContactGroup::RECENTLY_CONTACTED_CONTACTS;
            break;
        }
            
        case SKContactGroupTypeSharedGroup: {
            result = ContactGroup::SHARED_GROUP;
            break;
        }
            
        case SKContactGroupTypeSkypeBuddies: {
            result = ContactGroup::SKYPE_BUDDIES;
            break;
        }
            
        case SKContactGroupTypeSkypeOutBuddies: {
            result = ContactGroup::SKYPEOUT_BUDDIES;
            break;
        }
            
        case SKContactGroupTypeUngroupedBuddies: {
            result = ContactGroup::UNGROUPED_BUDDIES;
            break;
        }
            
        case SKContactGroupTypeUnknownOrPendingAuthBuddies: {
            result = ContactGroup::UNKNOWN_OR_PENDINGAUTH_BUDDIES;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

@end