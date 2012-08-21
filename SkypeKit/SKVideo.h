/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKObject.h"

@class NSArray;
@class SKConversation;
@class SKVideoDevice;

typedef enum {
    SKVideoStatusUndefined,
    SKVideoStatusNotAvailable,
    SKVideoStatusAvailable,
    SKVideoStatusStarting,
    SKVideoStatusRejected,
    SKVideoStatusRunning,
    SKVideoStatusStopping,
    SKVideoStatusPaused,
    SKVideoStatusNotStarted,
    SKVideoStatusHintIsVideocallReceived,
    SKVideoStatusUnknown,
    SKVideoStatusRendering,
    SKVideoStatusCheckingSubscription,
    SKVideoStatusSwitchingDevice
} SKVideoStatus;

typedef enum {
    SKVideoMediaTypeUndefined,
    SKVideoMediaTypeScreenSharing,
    SKVideoMediaTypeVideo
} SKVideoMediaType;

typedef enum {
    SKVideoVideoDeviceCapabilityUndefined,
    SKVideoVideoDeviceCapabilityHQCapable,
    SKVideoVideoDeviceCapabilityHQCertified,
    SKVideoVideoDeviceCapabilityREQDriverUpdate,
    SKVideoVideoDeviceCapabilityUSBHighspeed
} SKVideoVideoDeviceCapability;

@interface SKVideo : SKObject {
    SKVideoStatus _status;
    NSString* _error;
    NSArray* _debugInfo;
    SKVideoMediaType _mediaType;
    SKConversation* _conversation;
    NSString* _devicePath;
}

@property (nonatomic, assign, readonly) SKVideoStatus status;
@property (nonatomic, copy, readonly) NSString* error;
@property (nonatomic, copy, readonly) NSArray* debugInfo;
@property (nonatomic, assign, readonly) SKVideoMediaType mediaType;
@property (nonatomic, retain, readonly) SKConversation* conversation;
@property (nonatomic, copy, readonly) NSString* devicePath;

- (BOOL) start;
- (BOOL) stop;

- (BOOL) selectVideoSourceWithMediaType:(SKVideoMediaType) mediaType device:(SKVideoDevice*) device updateSetup:(BOOL) updateSetup;

@end
