/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKVideo.h"
#import "SKConversation.h"
#import "SKVideoDevice.h"

#import "VideoBinding.hpp"

#import <Foundation/NSString.h>

@interface SKVideo (Private)

- (SKVideoStatus) coreStatus;
- (NSString*) coreError;
- (NSArray*) coreDebugInfo;
- (SKVideoMediaType) coreMediaType;
- (SKConversation*) conversation;
- (NSString*) coreDevicePath;

@property (nonatomic, assign, readwrite) SKVideoStatus status;
@property (nonatomic, copy, readwrite) NSString* error;
@property (nonatomic, copy, readwrite) NSArray* debugInfo;
@property (nonatomic, assign, readwrite) SKVideoMediaType mediaType;
@property (nonatomic, retain, readwrite) SKConversation* conversation;
@property (nonatomic, copy, readwrite) NSString* devicePath;

@end

@implementation SKVideo

/* core accessors */
- (SKVideoStatus)coreStatus {
    Video::STATUS status;
    SKVideoStatus result = SKVideoStatusUndefined;
    
    if (self.coreVideo->GetPropStatus(status)) {
        [self markPropertyAsCached:@"status"];
        result = [SKVideo decodeStatus:status];
    }
    
    return result;
}

- (NSString*) coreError {
    Sid::String error;
    NSString* result = nil;
    
    if (self.coreVideo->GetPropError(error)) {
        [self markPropertyAsCached:@"error"];
        result = [NSString stringWithCString:error encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSArray*) coreDebugInfo {
    Sid::String debugInfo;
    NSArray* result = nil;
    
    if (self.coreVideo->GetPropDebuginfo(debugInfo)) {
        [self markPropertyAsCached:@"debugInfo"];
        NSString* debugString = [NSString stringWithCString:debugInfo encoding:NSUTF8StringEncoding];
        result = [debugString componentsSeparatedByString:@" "];
    }
    
    return result;
}

- (SKVideoMediaType) coreMediaType {
    Video::MEDIATYPE mediaType;
    SKVideoMediaType result = SKVideoMediaTypeUndefined;
    
    if (self.coreVideo->GetPropMediaType(mediaType)) {
        [self markPropertyAsCached:@"mediaType"];
        result = [SKVideo decodeMediaType:mediaType];
    }
    
    return result;
}


- (SKConversation*) coreConversation {
    ConversationRef conversation;
    SKConversation* result = nil;
    
    if (self.coreVideo->GetPropConvoId(conversation)) {
        [self markPropertyAsCached:@"conversation"];
        result = [SKObject resolve:conversation];
    }
    
    return result;
}

- (NSString*) coreDevicePath {
    Sid::String devicePath;
    NSString* result = nil;
    
    if (self.coreVideo->GetPropDevicePath(devicePath)) {
        [self markPropertyAsCached:@"devicePath"];
        result = [NSString stringWithCString:devicePath encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

/* standard accessors */
- (SKVideoStatus)status {
    if (![self isPropertyCached:@"status"]) {
        self->_status = [self coreStatus];
    }
    
    return self->_status;
}

- (NSString*) error {
    if (![self isPropertyCached:@"error"]) {
        [self->_error release];
        self->_error = [[self coreError] copy];
    }
    
    return self->_error;
}

- (NSArray*) debugInfo {
    if (![self isPropertyCached:@"debugInfo"]) {
        [self->_debugInfo release];
        self->_debugInfo = [[self coreDebugInfo] copy];
    }
    
    return self->_debugInfo;
}

- (SKVideoMediaType) mediaType {
    if (![self isPropertyCached:@"mediaType"]) {
        self->_mediaType = [self coreMediaType];
    }
    
    return self->_mediaType;
}

- (SKConversation*) conversation {
    if (![self isPropertyCached:@"conversation"]) {
        [self->_conversation release];
        self->_conversation = [[self coreConversation] retain];
    }
    
    return self->_conversation;
}

- (NSString*) devicePath {
    if (![self isPropertyCached:@"devicePath"]) {
        [self->_devicePath release];
        self->_devicePath = [[self coreDevicePath] copy];
    }
    
    return self->_devicePath;
}

/* methods */
- (BOOL)start {
    return self.coreVideo->Start();
}

- (BOOL)stop {
    return self.coreVideo->Stop();
}

- (BOOL)selectVideoSourceWithMediaType:(SKVideoMediaType)mediaType device:(SKVideoDevice *)device updateSetup:(BOOL)updateSetup {
    Video::MEDIATYPE type = [SKVideo encodeMediaType:mediaType];
    Sid::String deviceName = [device.name UTF8String];
    Sid::String devicePath = [device.path UTF8String];
    
    return self.coreVideo->SelectVideoSource(type, deviceName, devicePath, updateSetup);
}

/* callbacks */
- (void)onChange:(Video::PROPERTY)prop {
    switch (prop) {
        case Video::P_STATUS: {
            self.status = [self coreStatus];
            break;
        }
            
        case Video::P_ERROR: {
            self.error = [self coreError];
            break;
        }
            
        case Video::P_DEBUGINFO: {
            self.debugInfo = [self coreDebugInfo];
            break;
        }
            
        case Video::P_MEDIA_TYPE: {
            self.mediaType = [self coreMediaType];
            break;
        }
            
        case Video::P_CONVO_ID: {
            self.conversation = [self coreConversation];
            break;
        }
            
        case Video::P_DEVICE_PATH: {
            self.devicePath = [self coreDevicePath];
            break;
        }
            
        default:
            break;
    }
}

- (void)dealloc {
    [self->_conversation release];
    [self->_error release];
    [self->_debugInfo release];
    [self->_devicePath release];
    
    [super dealloc];
}

@end
