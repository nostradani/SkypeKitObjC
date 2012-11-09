/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ObjectBinding.hpp"

#import "SKTransfer.h"

#import <skype-embedded_2.h>

class TransferImp : public Transfer, public ObjectImp {
public:
    typedef DRef<TransferImp, Transfer> Ref;
    typedef DRefs<TransferImp, Transfer> Refs;
    
    TransferImp(unsigned int oid, SERootObject* root);
    ~TransferImp();
    
    virtual void OnChange(int prop);
    
protected:
    virtual SEReference coreRef();
};

@interface SKTransfer (Binding)

+ (SKTransferStatus) decodeStatus:(Transfer::STATUS) status;
+ (Transfer::STATUS) encodeStatus:(SKTransferStatus) status;

+ (SKTransferFailureReason) decodeFailureReason:(Transfer::FAILUREREASON) reason;
+ (Transfer::FAILUREREASON) encodeFailureReason:(SKTransferFailureReason) reason;

+ (SKTransferSendFileError) decodeSendFileError:(TRANSFER_SENDFILE_ERROR) error;
+ (TRANSFER_SENDFILE_ERROR) encodeSendFileError:(SKTransferSendFileError) error;

@property (nonatomic, readonly) TransferImp* coreTransfer;

@end
