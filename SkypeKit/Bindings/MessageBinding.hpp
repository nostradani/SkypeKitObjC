/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ObjectBinding.hpp"

#import "SKMessage.h"

#import <skype-embedded_2.h>
    
class MessageImp : public Message, public ObjectImp {
public:
    typedef DRef<MessageImp, Message> Ref;
    typedef DRefs<MessageImp, Message> Refs;
    
    MessageImp(unsigned int oid, SERootObject* root);
    ~MessageImp();
    
    void OnChange(int prop);
    
protected:
    virtual SEReference coreRef();
};

@interface SKMessage (Binding)

+ (SKMessageType) decodeType:(Message::TYPE) type;
+ (Message::TYPE) encodeType:(SKMessageType) type;

@property (nonatomic, readonly) MessageImp* coreMessage;

@end
