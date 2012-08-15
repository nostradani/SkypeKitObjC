/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "TransferBinding.hpp"


TransferImp::TransferImp(unsigned int oid, SERootObject* root) : Transfer(oid, root), ObjectImp([SKTransfer class]){
};

void TransferImp::OnChange(int prop) {
    [this->_objectInstance onChange:prop];
}

SEReference TransferImp::coreRef() {
    return this->ref();
}

TransferImp::~TransferImp() {
}

@implementation SKTransfer (Binding)

- (TransferImp*) coreTransfer {
    return (TransferImp*)[self object];
}

+ (SKTransferStatus) decodeStatus:(Transfer::STATUS) status {
    SKTransferStatus result = SKTransferStatusUnknown;
    
    switch (status) {
        case Transfer::NEW:
            result = SKTransferStatusNew;
            break;
            
        case Transfer::CONNECTING:
            result = SKTransferStatusConnecting;
            break;
            
        case Transfer::WAITING_FOR_ACCEPT:
            result = SKTransferStatusWaitingForAccept;
            break;
            
        case Transfer::TRANSFERRING:
            result = SKTransferStatusTransferring;
            break;
            
        case Transfer::TRANSFERRING_OVER_RELAY:
            result = SKTransferStatusTransferringOverRelay;
            break;
            
        case Transfer::PAUSED:
            result = SKTransferStatusPaused;
            break;
            
        case Transfer::REMOTELY_PAUSED:
            result = SKTransferStatusRemotelyPaused;
            break;
            
        case Transfer::CANCELLED:
            result = SKTransferStatusCancelled;
            break;
            
        case Transfer::COMPLETED:
            result = SKTransferStatusCompleted;
            break;
            
        case Transfer::FAILED:
            result = SKTransferStatusFailed;
            break;
            
        case Transfer::OFFER_FROM_OTHER_INSTANCE:
            result = SKTransferStatusOfferFromOtherInstance;
            break;
            
        case Transfer::CANCELLED_BY_REMOTE:
            result = SKTransferStatusCancelledByRemote;
            break;
            
        default:
            break;
    }
    
    return result;
}

+ (Transfer::STATUS) encodeStatus:(SKTransferStatus) status {
    Transfer::STATUS result = Transfer::PLACEHOLDER;
    
    switch (status) {
        case SKTransferStatusNew:
            result = Transfer::NEW;
            break;
            
        case SKTransferStatusConnecting:
            result = Transfer::CONNECTING;
            break;
            
        case SKTransferStatusWaitingForAccept:
            result = Transfer::WAITING_FOR_ACCEPT;
            break;
            
        case SKTransferStatusTransferring:
            result = Transfer::TRANSFERRING;
            break;
            
        case SKTransferStatusTransferringOverRelay:
            result = Transfer::TRANSFERRING_OVER_RELAY;
            break;
            
        case SKTransferStatusPaused:
            result = Transfer::PAUSED;
            break;
            
        case SKTransferStatusRemotelyPaused:
            result = Transfer::REMOTELY_PAUSED;
            break;
            
        case SKTransferStatusCancelled:
            result = Transfer::CANCELLED;
            break;
            
        case SKTransferStatusCompleted:
            result = Transfer::COMPLETED;
            break;
            
        case SKTransferStatusFailed:
            result = Transfer::FAILED;
            break;
            
        case SKTransferStatusOfferFromOtherInstance:
            result = Transfer::OFFER_FROM_OTHER_INSTANCE;
            break;
            
        case SKTransferStatusCancelledByRemote:
            result = Transfer::CANCELLED_BY_REMOTE;
            break;
            
        default:
            break;
    }
    
    return result;
}
    
@end
