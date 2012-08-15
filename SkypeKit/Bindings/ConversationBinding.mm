/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ConversationBinding.hpp"

#import "SKConversation.h"


ConversationImp::ConversationImp(unsigned int oid, SERootObject* root) : Conversation(oid, root), ObjectImp([SKConversation class]){
};

void ConversationImp::OnChange(int prop) {
    [this->_objectInstance onChange:prop];
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

@end
