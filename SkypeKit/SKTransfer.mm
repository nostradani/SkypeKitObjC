/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKTransfer.h"

#import <Foundation/NSString.h>
#import <Foundation/NSNumberFormatter.h>

#import "TransferBinding.hpp"


@interface SKTransfer (Private)

- (void) clearTimer;
- (void) notifyDelegate;

- (SKTransferType) coreType;
- (SKTransferStatus) coreStatus;
- (NSString*) coreFileName;
- (unsigned long long) coreFileSize;
- (unsigned long long) coreTransferedBytes;
- (NSUInteger) coreTransferSpeed;
- (SKTransferFailureReason) coreFailureReason;

@property (nonatomic, assign, readwrite) SKTransferType type;
@property (nonatomic, assign, readwrite) SKTransferStatus status;
@property (nonatomic, copy, readwrite) NSString* fileName;
@property (nonatomic, assign, readwrite) unsigned long long fileSize;
@property (nonatomic, assign, readwrite) unsigned long long transferedBytes;
@property (nonatomic, assign, readwrite) NSUInteger transferSpeed;
@property (nonatomic, assign, readwrite) SKTransferFailureReason failureReason;
    
@end

@implementation SKTransfer

@synthesize delegate = _delegate;
@synthesize uniqueId = _uniqueId;

- (SKTransferType) coreType {
    Transfer::TYPE aType;
    SKTransferType result = SKTransferTypeUnknown;
    
    if (self.coreTransfer->GetPropType(aType)) {
        [self markPropertyAsCached:@"type"];
        if (aType == Transfer::INCOMING) {
            result = SKTransferTypeIncoming;
        }
        else {
            result = SKTransferTypeOutgoing;
        }
    }
    
    return result;
}

- (SKTransferStatus) coreStatus {
    Transfer::STATUS aStatus;
    SKTransferStatus result = SKTransferStatusUnknown;
    
    if (self.coreTransfer->GetPropStatus(aStatus)) {
        [self markPropertyAsCached:@"status"];
        result = [SKTransfer decodeStatus:aStatus];
    }
    
    return result;
}

- (NSString*) coreFileName {
    Sid::String name;
    NSString* result = nil;
    
    if (self.coreTransfer->GetPropFilename(name)) {
        [self markPropertyAsCached:@"fileName"];
        result = [NSString stringWithUTF8String:name];
    }
    
    return result;
}

- (unsigned long long) coreFileSize {
    if (self->_fileSize == 0) {
        Sid::String size;
        
        if (self.coreTransfer->GetPropFilesize(size)) {
            [self markPropertyAsCached:@"fileSize"];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            NSNumber *number = [numberFormatter numberFromString:[NSString stringWithUTF8String:size]];
            [numberFormatter release];
            self->_fileSize = [number unsignedLongLongValue];
        }
    }
    
    return self->_fileSize;
}

- (unsigned long long) coreTransferedBytes {
    Sid::String size;
    unsigned long long result = 0;
    
    if (self.coreTransfer->GetPropBytestransferred(size)) {
        [self markPropertyAsCached:@"transferedBytes"];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        NSNumber *number = [numberFormatter numberFromString:[NSString stringWithUTF8String:size]];
        [numberFormatter release];
        result = [number unsignedLongLongValue];
    }
    
    return result;
}

- (NSUInteger) coreTransferSpeed {
    uint speed;
    NSUInteger result = 0;
    
    if (self.coreTransfer->GetPropBytespersecond(speed)) {
        [self markPropertyAsCached:@"transferSpeed"];
        result = speed;
    }
    
    return result;
}

- (SKTransferFailureReason)coreFailureReason {
    Transfer::FAILUREREASON reason;
    SKTransferFailureReason result = SKTransferFailureReasonUnknown;
    
    if (self.coreTransfer->GetPropFailurereason(reason)) {
        [self markPropertyAsCached:@"failureReason"];
        result = [SKTransfer decodeFailureReason:reason];
    }
    
    return result;
}

- (SKTransferStatus) status {
    if (![self isPropertyCached:@"status"]) {
        self->_status = [self coreStatus];
    }
    
    return self->_status;
}

- (void)setStatus:(SKTransferStatus) aStatus {
    if (self->_status != aStatus) {
        self->_status = aStatus;
    }
}

- (SKTransferType) type {
    if (![self isPropertyCached:@"type"]) {
        self->_type = [self coreType];
    }
    
    return self->_type;
}

- (void)setType:(SKTransferType)aType {
    if (self->_type != aType) {
        self->_type = aType;
    }
}

- (NSString *) fileName {
    if (![self isPropertyCached:@"fileName"]) {
        [self->_fileName release];
        self->_fileName = [[self coreFileName] copy];
    }
    
    return self->_fileName;
}

- (void)setFileName:(NSString *) aFileName {
    if (self->_fileName != aFileName) {
        [self->_fileName release];
        self->_fileName = [aFileName copy];
    }
}

- (unsigned long long) fileSize {
    if (![self isPropertyCached:@"fileSize"]) {
        self->_fileSize = [self coreFileSize];
    }
    
    return self->_fileSize;
}

- (void)setFileSize:(unsigned long long) aFileSize {
    if (self->_fileSize != aFileSize) {
        self->_fileSize = aFileSize;
    }
}

- (unsigned long long) transferedBytes {
    if (![self isPropertyCached:@"transferedBytes"]) {
        self->_transferedBytes = [self coreTransferedBytes];
    }
    
    return self->_transferedBytes;
}

- (void)setTransferedBytes:(unsigned long long) aTransferedBytes {
    if (self->_transferedBytes != aTransferedBytes) {
        self->_transferedBytes = aTransferedBytes;
    }
}

- (NSUInteger) transferSpeed {
    if (![self isPropertyCached:@"status"]) {
        self->_transferSpeed = [self coreStatus];
    }
    
    return self->_transferSpeed;
}

- (void)setTransferSpeed:(NSUInteger) aTransferSpeed {
    if (self->_transferSpeed != aTransferSpeed) {
        self->_transferSpeed = aTransferSpeed;
    }
}

- (SKTransferFailureReason)failureReason {
    if (![self isPropertyCached:@"failureReason"]) {
        self->_failureReason = [self coreFailureReason];
    }
    
    return self->_failureReason;
}

- (void)setFailureReason:(SKTransferFailureReason)failureReason {
    if (self->_failureReason != failureReason) {
        self->_failureReason = failureReason;
    }
}

- (BOOL) pause {
    return self.coreTransfer->Pause();
}

- (BOOL) resume {
    return self.coreTransfer->Resume();
}

- (BOOL) cancel {
    return self.coreTransfer->Cancel();
}

- (BOOL) acceptWithPath:(NSString*) filePath {
    BOOL result = NO;
    bool success;
    
    if (self.coreTransfer->Accept([filePath cStringUsingEncoding:NSUTF8StringEncoding],success)) {
        result = (success == true);
    }
    
    return result;
}

- (void)onChange:(int)prop {
    @autoreleasepool {
        switch (prop) {
            case Transfer::P_STATUS: {
                SKTransferStatus status = [self coreStatus];
                
                self.status = status;
                [self.delegate transfer:self didChangeStatus:status];
                break;
            }
                
            case Transfer::P_BYTESTRANSFERRED: {
                unsigned long long transferedBytes = [self coreTransferedBytes];
                
                self.transferedBytes = transferedBytes;
                [self.delegate transfer:self didChangeBytesTransferred:transferedBytes];
                
                break;
            }
                
            case Transfer::P_BYTESPERSECOND: {
                self.transferSpeed = [self coreTransferSpeed];
                break;
            }
                
            case Transfer::P_FAILUREREASON: {
                self.failureReason = [self coreFailureReason];
                break;
            }
                
            default:
                break;
        }
    }
}

- (void)dealloc {
    self.uniqueId = nil;
    
    [self->_fileName release];
    
    [super dealloc];
}

@end
