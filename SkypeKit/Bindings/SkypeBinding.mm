/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SkypeBinding.hpp"

#import "AccountBinding.hpp"
#import "ContactBinding.hpp"
#import "ContactGroupBinding.hpp"
#import "MessageBinding.hpp"
#import "ConversationBinding.hpp"
#import "ParticipantBinding.hpp"
#import "TransferBinding.hpp"
#import "ContactSearchBinding.hpp"
#import "VideoBinding.hpp"

#import "SKSkype.h"

Account* SkypeImp::newAccount(int oid) {
    return new AccountImp(oid, this);
}

ContactGroup* SkypeImp::newContactGroup(int oid) {
    return new ContactGroupImp(oid, this);
}

Contact* SkypeImp::newContact(int oid) {
    return new ContactImp(oid, this);
}


Message* SkypeImp::newMessage(int oid){
    return new MessageImp(oid, this);
}

Conversation* SkypeImp::newConversation(int oid){
    return new ConversationImp(oid, this);
}

Participant* SkypeImp::newParticipant(int oid){
    return new ParticipantImp(oid, this);
}

Transfer* SkypeImp::newTransfer(int oid){
    return new TransferImp(oid, this);
}

ContactSearch* SkypeImp::newContactSearch(int oid) {
    return new ContactSearchImp(oid, this);
}

Video* SkypeImp::newVideo(int oid) {
    return new VideoImp(oid, this);
}

void SkypeImp::OnMessage(const Message::Ref& message, const bool& changesInboxTimestamp, 
                         const Message::Ref& supersedesHistoryMessage, const Conversation::Ref& conversation) {
    [this->_instance onMessage:message changesInboxTimestamp:changesInboxTimestamp supersedesHistoryMessage: supersedesHistoryMessage conversation:conversation];
}

void SkypeImp::OnConversationListChange(const ConversationRef &conversation, const Conversation::LIST_TYPE &type, const bool &added) {
    [this->_instance onConversationListChange:conversation type:type added:added];
}

void SkypeImp::bind(SKSkype *instance) {
    this->_instance = instance;
}
