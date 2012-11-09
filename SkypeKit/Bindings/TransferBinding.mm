/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "TransferBinding.hpp"


TransferImp::TransferImp(unsigned int oid, SERootObject* root) : Transfer(oid, root), ObjectImp([SKTransfer class], root){
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
            
            
        case Transfer::PLACEHOLDER:
            result = SKTransferStatusPlaceholder;
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

+ (SKTransferFailureReason)decodeFailureReason:(Transfer::FAILUREREASON)reason {
    SKTransferFailureReason result = SKTransferFailureReasonUnknown;
    
    switch (reason) {
        case Transfer::FAILED_READ: {
            result = SKTransferFailureReasonFailedRead;
            break;
        }
            
        case Transfer::FAILED_REMOTE_READ: {
            result = SKTransferFailureReasonFailedRemoteRead;
            break;
        }
            
        case Transfer::FAILED_REMOTE_WRITE: {
            result = SKTransferFailureReasonFailedRemoteWrite;
            break;
        }
            
        case Transfer::FAILED_WRITE: {
            result = SKTransferFailureReasonFailedWrite;
            break;
        }
        case Transfer::PLACEHOLDER_TIMEOUT: {
            result = SKTransferFailureReasonPlaceholderTimeout;
            break;
        }
        case Transfer::REMOTE_DOES_NOT_SUPPORT_FT: {
            result = SKTransferFailureReasonRemoteDoesNotSupportFt;
            break;
        }
            
        case Transfer::REMOTELY_CANCELLED: {
            result = SKTransferFailureReasonRemotelyCancelled;
            break;
        }
            
        case Transfer::REMOTE_OFFLINE_FOR_TOO_LONG: {
            result = SKTransferFailureReasonRemoteOfflineForTooLong;
            break;
        }
            
        case Transfer::SENDER_NOT_AUTHORISED: {
            result = SKTransferFailureReasonSenderNotAuthorized;
            break;
        }
            
        case Transfer::TOO_MANY_PARALLEL: {
            result = SKTransferFailureReasonTooManyParallel;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

+ (Transfer::FAILUREREASON)encodeFailureReason:(SKTransferFailureReason)reason {
    Transfer::FAILUREREASON result = Transfer::SENDER_NOT_AUTHORISED;
    
    switch (reason) {
        case SKTransferFailureReasonFailedRead: {
            result = Transfer::FAILED_READ;
            break;
        }
            
        case SKTransferFailureReasonFailedRemoteRead: {
            result = Transfer::FAILED_REMOTE_READ;
            break;
        }
            
        case SKTransferFailureReasonFailedRemoteWrite: {
            result = Transfer::FAILED_REMOTE_WRITE;
            break;
        }
            
        case SKTransferFailureReasonFailedWrite: {
            result = Transfer::FAILED_WRITE;
            break;
        }
        case SKTransferFailureReasonPlaceholderTimeout: {
            result = Transfer::PLACEHOLDER_TIMEOUT;
            break;
        }
        case SKTransferFailureReasonRemoteDoesNotSupportFt: {
            result = Transfer::REMOTE_DOES_NOT_SUPPORT_FT;
            break;
        }
            
        case SKTransferFailureReasonRemotelyCancelled: {
            result = Transfer::REMOTELY_CANCELLED;
            break;
        }
            
        case SKTransferFailureReasonRemoteOfflineForTooLong: {
            result = Transfer::REMOTE_OFFLINE_FOR_TOO_LONG;
            break;
        }
            
        case SKTransferFailureReasonSenderNotAuthorized: {
            result = Transfer::SENDER_NOT_AUTHORISED;
            break;
        }
            
        case SKTransferFailureReasonTooManyParallel: {
            result = Transfer::TOO_MANY_PARALLEL;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

+ (SKTransferSendFileError)decodeSendFileError:(TRANSFER_SENDFILE_ERROR)error {
    SKTransferSendFileError result = SKTransferSendFileErrorUnknown;
    
    switch (error) {
        case TRANSFER_BAD_FILENAME: {
            result = SKTransferSendFileErrorBadFileName;
            break;
        }
            
        case TRANSFER_OPEN_FAILED: {
            result = SKTransferSendFileErrorOpenFailed;
            break;
        }
            
        case TRANSFER_TOO_MANY_PARALLEL: {
            result = SKTransferSendFileErrorTooManyParallel;
            break;
        }
            
        case TRANSFER_OPEN_SUCCESS: {
            result = SKTransferSendFileErrorOpenSuccess;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

+ (TRANSFER_SENDFILE_ERROR)encodeSendFileError:(SKTransferSendFileError)error {
    TRANSFER_SENDFILE_ERROR result = TRANSFER_OPEN_FAILED;
    
    switch (error) {
        case SKTransferSendFileErrorBadFileName: {
            result = TRANSFER_BAD_FILENAME;
            break;
        }
            
        case SKTransferSendFileErrorOpenFailed: {
            result = TRANSFER_OPEN_FAILED;
            break;
        }
            
        case SKTransferSendFileErrorTooManyParallel: {
            result = TRANSFER_TOO_MANY_PARALLEL;
            break;
        }
            
        case SKTransferSendFileErrorOpenSuccess: {
            result = TRANSFER_OPEN_SUCCESS;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}
    
@end
