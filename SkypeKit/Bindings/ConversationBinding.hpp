/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ObjectBinding.hpp"

#import "SKConversation.h"

#import <skype-embedded_2.h>

class ConversationImp : public Conversation, public ObjectImp {
public:
    typedef DRef<ConversationImp, Conversation> Ref;
    typedef DRefs<ConversationImp, Conversation> Refs;
    
    ConversationImp(unsigned int oid, SERootObject* root);
    ~ConversationImp();
    
    virtual void OnChange(int prop);
    virtual void OnMessage(const MessageRef &message);
    
protected:
    virtual SEReference coreRef();
};

@interface SKConversation (Binding)

+ (SKConversationListType) decodeListType:(Conversation::LIST_TYPE) type;
+ (Conversation::LIST_TYPE) encodeListType:(SKConversationListType) type;

+ (SKConversationLocalLiveStatus) decodeLocalLiveStatus:(Conversation::LOCAL_LIVESTATUS) status;
+ (Conversation::LOCAL_LIVESTATUS) encodeLocalLiveStatus:(SKConversationLocalLiveStatus) status;

+ (SKConversationMyStatus)decodeMyStatus:(Conversation::MY_STATUS)status;
+ (Conversation::MY_STATUS) encodeMyStatus:(SKConversationMyStatus) status;

- (void)onMessage:(const Message::Ref&)message;

@property (nonatomic, readonly) ConversationImp* coreConversation;

@end
