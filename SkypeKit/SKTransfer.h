/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKObject.h"

@class TransferBinding;
@class SKTransfer;

typedef enum {
    SKTransferTypeUnknown,
    SKTransferTypeIncoming,
    SKTransferTypeOutgoing
} SKTransferType;

typedef enum {
    SKTransferFailureReasonUnknown,
    SKTransferFailureReasonSenderNotAuthorized,
    SKTransferFailureReasonRemotelyCancelled,
    SKTransferFailureReasonFailedRead,
    SKTransferFailureReasonFailedRemoteRead,
    SKTransferFailureReasonFailedWrite,
    SKTransferFailureReasonFailedRemoteWrite,
    SKTransferFailureReasonRemoteDoesNotSupportFt,
    SKTransferFailureReasonRemoteOfflineForTooLong,
    SKTransferFailureReasonTooManyParallel,
    SKTransferFailureReasonPlaceholderTimeout,
} SKTransferFailureReason;

typedef enum {
    SKTransferStatusUnknown,
    SKTransferStatusNew,
    SKTransferStatusConnecting,
    SKTransferStatusWaitingForAccept,
    SKTransferStatusTransferring,
    SKTransferStatusTransferringOverRelay,
    SKTransferStatusPaused,
    SKTransferStatusRemotelyPaused,
    SKTransferStatusCancelled,
    SKTransferStatusCompleted,
    SKTransferStatusFailed,
    SKTransferStatusPlaceholder,
    SKTransferStatusOfferFromOtherInstance,
    SKTransferStatusCancelledByRemote
} SKTransferStatus;

@protocol SKTransferDelegate <NSObject>

- (void)transfer:(SKTransfer *)transfer didChangeBytesTransferred:(unsigned long long) bytes;
- (void)transfer:(SKTransfer *)transfer didChangeStatus:(SKTransferStatus)status;

@end

@interface SKTransfer : SKObject {
    id<SKTransferDelegate> _delegate;
    id _uniqueId;
    
    SKTransferType _type;
    SKTransferStatus _status;
    NSString* _fileName;
    unsigned long long _fileSize;
    unsigned long long _transferedBytes;
    NSUInteger _transferSpeed;
    SKTransferFailureReason _failureReason;
}

@property (nonatomic, readwrite, retain) id uniqueId;
@property (nonatomic, assign) id<SKTransferDelegate> delegate;

@property (nonatomic, readonly) SKTransferType type;
@property (nonatomic, readonly) SKTransferStatus status;
@property (nonatomic, readonly) NSString* fileName;
@property (nonatomic, readonly) unsigned long long fileSize;
@property (nonatomic, readonly) unsigned long long transferedBytes;
@property (nonatomic, readonly) NSUInteger transferSpeed;
@property (nonatomic, readonly) SKTransferFailureReason failureReason;

- (BOOL) pause;
- (BOOL) resume;
- (BOOL) cancel;

- (BOOL) acceptWithPath:(NSString*) filePath;

@end
