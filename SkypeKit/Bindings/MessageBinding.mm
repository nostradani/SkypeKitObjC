/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "MessageBinding.hpp"

MessageImp::MessageImp(unsigned int oid, SERootObject* root) : Message(oid, root), ObjectImp([SKMessage class], root){
};

MessageImp::~MessageImp() {
}

void MessageImp::OnChange(int prop) {
    [this->_objectInstance onChange:prop];
};

SEReference MessageImp::coreRef() {
    return this->ref();
}

@implementation SKMessage (Binding)

- (MessageImp*) coreMessage {
    return (MessageImp*)[self object];
}

+ (SKMessageType) decodeType:(Message::TYPE) type {
    SKMessageType result = SKMessageTypePostedAlert;
    
    switch (type) {
        case Message::SET_METADATA:
            result = SKMessageTypeSetMetadata;
            break;
            
        case Message::SPAWNED_CONFERENCE:
            result = SKMessageTypeSpawendConference;
            break;
            
        case Message::ADDED_CONSUMERS:
            result = SKMessageTypeAddedConsumers;
            break;
            
        case Message::ADDED_APPLICANTS:
            result = SKMessageTypeAddedApplicants;
            break;
            
        case Message::RETIRED_OTHERS:
            result = SKMessageTypeRetiredOthers;
            break;
            
        case Message::RETIRED:
            result = SKMessageTypeRetired;
            break;
            
        case Message::SET_RANK:
            result = SKMessageTypeSetRank;
            break;
            
        case Message::STARTED_LIVESESSION:
            result = SKMessageTypeStartedLiveSession;
            break;
            
        case Message::ENDED_LIVESESSION:
            result = SKMessageTypeEndedLiveSession;
            break;
            
        case Message::REQUESTED_AUTH:
            result = SKMessageTypeRequestedAuthorization;
            break;
            
        case Message::GRANTED_AUTH:
            result = SKMessageTypeGrantedAuthorization;
            break;
            
        case Message::POSTED_TEXT:
            result = SKMessageTypePostedText;
            break;
            
        case Message::POSTED_EMOTE:
            result = SKMessageTypePostedEmote;
            break;
            
        case Message::POSTED_CONTACTS:
            result = SKMessageTypePostedContacts;
            break;
            
        case Message::POSTED_SMS:
            result = SKMessageTypePostedSMS;
            break;
            
        case Message::POSTED_VOICE_MESSAGE:
            result = SKMessageTypePostedVoiceMessage;
            break;
            
        case Message::POSTED_FILES:
            result = SKMessageTypePostedFiles;
            break;
            
        case Message::POSTED_INVOICE:
            result = SKMessageTypePostedInvoice;
            break;
            
        case Message::HAS_BIRTHDAY:
            result = SKMessageTypeHasBirthday;
            break;
            
        default:
            break;
    }
    
    return result;
}

+ (Message::TYPE) encodeType:(SKMessageType) type {
    Message::TYPE result = Message::POSTED_ALERT;
    
    switch (type) {
        case SKMessageTypeSetMetadata:
            result = Message::SET_METADATA;
            break;
            
        case SKMessageTypeSpawendConference:
            result = Message::SPAWNED_CONFERENCE;
            break;
            
        case SKMessageTypeAddedConsumers:
            result = Message::ADDED_CONSUMERS;
            break;
            
        case SKMessageTypeAddedApplicants:
            result = Message::ADDED_APPLICANTS;
            break;
            
        case SKMessageTypeRetiredOthers:
            result = Message::RETIRED_OTHERS;
            break;
            
        case SKMessageTypeRetired:
            result = Message::RETIRED;
            break;
            
        case SKMessageTypeSetRank:
            result = Message::SET_RANK;
            break;
            
        case SKMessageTypeStartedLiveSession:
            result = Message::STARTED_LIVESESSION;
            break;
            
        case SKMessageTypeEndedLiveSession:
            result = Message::ENDED_LIVESESSION;
            break;
            
        case SKMessageTypeRequestedAuthorization:
            result = Message::REQUESTED_AUTH;
            break;
            
        case SKMessageTypeGrantedAuthorization:
            result = Message::GRANTED_AUTH;
            break;
            
        case SKMessageTypePostedText:
            result = Message::POSTED_TEXT;
            break;
            
        case SKMessageTypePostedEmote:
            result = Message::POSTED_EMOTE;
            break;
            
        case SKMessageTypePostedContacts:
            result = Message::POSTED_CONTACTS;
            break;
            
        case SKMessageTypePostedSMS:
            result = Message::POSTED_SMS;
            break;
            
        case SKMessageTypePostedVoiceMessage:
            result = Message::POSTED_VOICE_MESSAGE;
            break;
            
        case SKMessageTypePostedFiles:
            result = Message::POSTED_FILES;
            break;
            
        case SKMessageTypePostedInvoice:
            result = Message::POSTED_INVOICE;
            break;
            
        case SKMessageTypeHasBirthday:
            result = Message::HAS_BIRTHDAY;
            break;
            
        default:
            break;
    }
    
    return result;
}

@end
