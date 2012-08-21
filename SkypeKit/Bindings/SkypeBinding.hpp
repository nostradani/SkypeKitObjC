/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import <Foundation/NSObject.h>

#import <skype-embedded_2.h>

#import "SKSkype.h"

class SkypeImp : public Skype {
    Account* newAccount(int oid);
    ContactGroup* newContactGroup(int oid);
    Contact* newContact(int oid);
    Message* newMessage(int oid);
    Conversation* newConversation(int oid);
    Participant* newParticipant(int oid);
    Transfer* newTransfer(int oid);
    ContactSearch* newContactSearch(int oid);
    Video* newVideo(int oid);
    
    SKSkype* _instance;
public:    
    
    virtual void OnMessage(const Message::Ref& message, const bool& changesInboxTimestamp, 
                           const Message::Ref& supersedesHistoryMessage, const Conversation::Ref& conversation);
    
    void OnConversationListChange(const ConversationRef &conversation, const Conversation::LIST_TYPE &type, const bool &added);
    void bind(SKSkype* instance);
};

@interface SKSkype (Binding)

- (void) onMessage:(const Message::Ref&) message changesInboxTimestamp:(BOOL)changesInboxTimestamp 
                                              supersedesHistoryMessage:(const Message::Ref&) supersedesHistoryMessage 
                                                          conversation:(const Conversation::Ref&) conversation;

- (void) onConversationListChange:(const ConversationRef &) conversation type:(const Conversation::LIST_TYPE &)type added:(const bool &)added;

@property (nonatomic, readonly) SkypeImp* skype;

@end
