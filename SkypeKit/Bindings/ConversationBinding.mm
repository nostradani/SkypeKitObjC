/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ConversationBinding.hpp"

#import "SKConversation.h"
#import "SKMessage.h"
#import <Foundation/NSArray.h>

ConversationImp::ConversationImp(unsigned int oid, SERootObject* root) : Conversation(oid, root), ObjectImp([SKConversation class], root){
};

void ConversationImp::OnChange(int prop) {
    [this->_objectInstance onChange:prop];
}

void ConversationImp::OnMessage(const MessageRef &message) {
    [(SKConversation *)(this->_objectInstance) onMessage:message];
}

SEReference ConversationImp::coreRef() {
    return this->ref();
}

ConversationImp::~ConversationImp() {
}

@implementation SKConversation (Binding)

- (ConversationImp*) coreConversation {
    return (ConversationImp*)[self object];
}

- (void)onMessage:(const Message::Ref&)message {
    SKMessage* aMessage = [SKObject resolve:message];
    [self.delegate conversation:self didReceiveMessage:aMessage];
}

+ (SKConversationListType) decodeListType:(Conversation::LIST_TYPE) type {
    SKConversationListType result = SKConversationListTypeReallyAllConversations;
    
    switch (type) {
        case Conversation::ALL_CONVERSATIONS:
            result = SKConversationListTypeAllConversations;
            break;
            
        case Conversation::INBOX_CONVERSATIONS:
            result = SKConversationListTypeInboxConversations;
            break;
            
        case Conversation::BOOKMARKED_CONVERSATIONS:
            result = SKConversationListTypeBookmarkedConversations;
            break;
            
        case Conversation::LIVE_CONVERSATIONS:
            result = SKConversationListTypeLiveConversations;
            break;
            
        default:
            break;
    }
    
    return result;
}

+ (Conversation::LIST_TYPE) encodeListType:(SKConversationListType) type {
    Conversation::LIST_TYPE result = Conversation::REALLY_ALL_CONVERSATIONS;
    
    switch (type) {
        case SKConversationListTypeAllConversations:
            result = Conversation::ALL_CONVERSATIONS;
            break;
            
        case SKConversationListTypeInboxConversations:
            result = Conversation::INBOX_CONVERSATIONS;
            break;
            
        case SKConversationListTypeBookmarkedConversations:
            result = Conversation::BOOKMARKED_CONVERSATIONS;
            break;
            
        case SKConversationListTypeLiveConversations:
            result = Conversation::LIVE_CONVERSATIONS;
            break;
            
        default:
            break;
    }
    
    return result;
}

+ (Conversation::LOCAL_LIVESTATUS) encodeLocalLiveStatus:(SKConversationLocalLiveStatus)status {
    Conversation::LOCAL_LIVESTATUS result = Conversation::NONE;
    
    switch (status) {
        case SKConversationLocalLiveStatusNone: {
            result = Conversation::NONE;
            break;
        }
            
        case SKConversationLocalLiveStatusIMLive: {
            result = Conversation::IM_LIVE;
            break;
        }
            
        case SKConversationLocalLiveStatusOnHoldLocally: {
            result = Conversation::ON_HOLD_LOCALLY;
            break;
        }
            
        case SKConversationLocalLiveStatusOnHoldRemotely: {
            result = Conversation::ON_HOLD_REMOTELY;
            break;
        }
            
        case SKConversationLocalLiveStatusOthersAreLive: {
            result = Conversation::OTHERS_ARE_LIVE;
            break;
        }
            
        case SKConversationLocalLiveStatusOthersAreLiveFull: {
            result = Conversation::OTHERS_ARE_LIVE_FULL;
            break;
        }
            
        case SKConversationLocalLiveStatusPlayingVoiceMessage: {
            result = Conversation::PLAYING_VOICE_MESSAGE;
            break;
        }
            
        case SKConversationLocalLiveStatusRecentlyLive: {
            result = Conversation::RECENTLY_LIVE;
            break;
        }
            
        case SKConversationLocalLiveStatusRecordingVoiceMessage: {
            result = Conversation::RECORDING_VOICE_MESSAGE;
            break;
        }
            
        case SKConversationLocalLiveStatusRingingForMe: {
            result = Conversation::RINGING_FOR_ME;
            break;
        }
            
        case SKConversationLocalLiveStatusStarting: {
            result = Conversation::STARTING;
            break;
        }
            
        case SKConversationLocalLiveStatusTransferring: {
            result = Conversation::TRANSFERRING;
            break;
        }
            
        default: {
            break;
        }
    }
    
    return result;
}

+ (SKConversationLocalLiveStatus)decodeLocalLiveStatus:(Conversation::LOCAL_LIVESTATUS)status {
    SKConversationLocalLiveStatus result = SKConversationLocalLiveStatusUndefined;
    
    switch (status) {
        case Conversation::NONE: {
            result = SKConversationLocalLiveStatusNone;
            break;
        }
            
        case Conversation::IM_LIVE: {
            result = SKConversationLocalLiveStatusIMLive;
            break;
        }
            
        case Conversation::ON_HOLD_LOCALLY: {
            result = SKConversationLocalLiveStatusOnHoldLocally;
            break;
        }
            
        case Conversation::ON_HOLD_REMOTELY: {
            result = SKConversationLocalLiveStatusOnHoldRemotely;
            break;
        }
            
        case Conversation::OTHERS_ARE_LIVE: {
            result = SKConversationLocalLiveStatusOthersAreLive;
            break;
        }
            
        case Conversation::OTHERS_ARE_LIVE_FULL: {
            result = SKConversationLocalLiveStatusOthersAreLiveFull;
            break;
        }
            
        case Conversation::PLAYING_VOICE_MESSAGE: {
            result = SKConversationLocalLiveStatusPlayingVoiceMessage;
            break;
        }
            
        case Conversation::RECENTLY_LIVE: {
            result = SKConversationLocalLiveStatusRecentlyLive;
            break;
        }
            
        case Conversation::RECORDING_VOICE_MESSAGE: {
            result = SKConversationLocalLiveStatusRecordingVoiceMessage;
            break;
        }
            
        case Conversation::RINGING_FOR_ME: {
            result = SKConversationLocalLiveStatusRingingForMe;
            break;
        }
            
        case Conversation::STARTING: {
            result = SKConversationLocalLiveStatusStarting;
            break;
        }
            
        case Conversation::TRANSFERRING: {
            result = SKConversationLocalLiveStatusTransferring;
            break;
        }
            
        default: {
            break;
        }
    }
    
    return result;
}

+ (Conversation::MY_STATUS) encodeMyStatus:(SKConversationMyStatus)status {
    Conversation::MY_STATUS result = Conversation::CONNECTING;
    
    switch (status) {
        case SKConversationMyStatusConnecting: {
            result = Conversation::CONNECTING;
            break;
        }
            
        case SKConversationMyStatusRetryConnecting: {
            result = Conversation::RETRY_CONNECTING;
            break;
        }
            
        case SKConversationMyStatusDownloadingMessages: {
            result = Conversation::DOWNLOADING_MESSAGES;
            break;
        }
            
        case SKConversationMyStatusQueuedToEnter: {
            result = Conversation::QUEUED_TO_ENTER;
            break;
        }
            
        case SKConversationMyStatusApplicant: {
            result = Conversation::APPLICANT;
            break;
        }
            
        case SKConversationMyStatusApplicationDenied: {
            result = Conversation::APPLICATION_DENIED;
            break;
        }
            
        case SKConversationMyStatusInvalidAccessToken: {
            result = Conversation::INVALID_ACCESS_TOKEN;
            break;
        }
            
        case SKConversationMyStatusConsumer: {
            result = Conversation::CONSUMER;
            break;
        }
            
        case SKConversationMyStatusRetiredForcefully: {
            result = Conversation::RETIRED_FORCEFULLY;
            break;
        }
            
        case SKConversationMyStatusRetiredVoluntarily: {
            result = Conversation::RETIRED_VOLUNTARILY;
            break;
        }
                        
        default: {
            break;
        }
    }
    
    return result;
}

+ (SKConversationMyStatus)decodeMyStatus:(Conversation::MY_STATUS)status {
    SKConversationMyStatus result = SKConversationMyStatusUndefined;
    
    switch (status) {
        case Conversation::CONNECTING: {
            result = SKConversationMyStatusConnecting;
            break;
        }
            
        case Conversation::RETRY_CONNECTING: {
            result = SKConversationMyStatusRetryConnecting;
            break;
        }
            
        case Conversation::DOWNLOADING_MESSAGES: {
            result = SKConversationMyStatusDownloadingMessages;
            break;
        }
            
        case Conversation::QUEUED_TO_ENTER: {
            result = SKConversationMyStatusQueuedToEnter;
            break;
        }
            
        case Conversation::APPLICANT: {
            result = SKConversationMyStatusApplicant;
            break;
        }
            
        case Conversation::APPLICATION_DENIED: {
            result = SKConversationMyStatusApplicationDenied;
            break;
        }
            
        case Conversation::INVALID_ACCESS_TOKEN: {
            result = SKConversationMyStatusInvalidAccessToken;
            break;
        }
            
        case Conversation::CONSUMER: {
            result = SKConversationMyStatusConsumer;
            break;
        }
            
        case Conversation::RETIRED_FORCEFULLY: {
            result = SKConversationMyStatusRetiredForcefully;
            break;
        }
            
        case Conversation::RETIRED_VOLUNTARILY: {
            result = SKConversationMyStatusRetiredVoluntarily;
            break;
        }
                        
        default: {
            break;
        }
    }
    
    return result;
}

+(Conversation::TYPE)encodeType:(SKConversationType)type {
    Conversation::TYPE result = Conversation::DIALOG;
    
    switch (type) {
        case SKConversationTypeDialog: {
            result = Conversation::DIALOG;
            break;
        }
            
        case SKConversationTypeConference: {
            result = Conversation::CONFERENCE;
            break;
        }
            
        case SKConversationTypeTerminatedConference: {
            result = Conversation::TERMINATED_CONFERENCE;
            break;
        }
            
        case SKConversationTypeLegacyVoiceConference: {
            result = Conversation::LEGACY_VOICE_CONFERENCE;
            break;
        }
            
        case SKConversationTypeLegacySharedGroup: {
            result = Conversation::LEGACY_SHAREDGROUP;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

+ (SKConversationType)decodeType:(Conversation::TYPE)type {
    SKConversationType result = SKConversationTypeUnknown;
    
    switch (type) {
        case Conversation::CONFERENCE: {
            result = SKConversationTypeConference;
            break;
        }
            
        case Conversation::TERMINATED_CONFERENCE: {
            result = SKConversationTypeTerminatedConference;
            break;
        }
            
        case Conversation::LEGACY_VOICE_CONFERENCE: {
            result = SKConversationTypeLegacyVoiceConference;
            break;
        }
            
        case Conversation::LEGACY_SHAREDGROUP: {
            result = SKConversationTypeLegacySharedGroup;
            break;
        }
            
        case Conversation::DIALOG: {
            result = SKConversationTypeDialog;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

@end
