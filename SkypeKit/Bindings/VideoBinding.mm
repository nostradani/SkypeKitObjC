/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "VideoBinding.hpp"


VideoImp::VideoImp(unsigned int oid, SERootObject* root) : Video(oid, root), ObjectImp([SKVideo class]){
};

void VideoImp::OnChange(int prop) {
    [this->_objectInstance onChange:prop];
}

SEReference VideoImp::coreRef() {
    return this->ref();
}

VideoImp::~VideoImp() {
}

@implementation SKVideo (Binding)

- (VideoImp*) coreVideo {
    return (VideoImp*)[self object];
}

+ (SKVideoStatus) decodeStatus:(Video::STATUS) status {
    SKVideoStatus result = SKVideoStatusUndefined;
    
    switch (status) {
        case Video::NOT_AVAILABLE: {
            result = SKVideoStatusNotAvailable;
            break;
        }
            
        case Video::AVAILABLE: {
            result = SKVideoStatusAvailable;
            break;
        }
            
        case Video::STARTING: {
            result = SKVideoStatusStarting;
            break;
        }
            
        case Video::REJECTED: {
            result = SKVideoStatusRejected;
            break;
        }
            
        case Video::RUNNING: {
            result = SKVideoStatusRunning;
            break;
        }
            
        case Video::STOPPING: {
            result = SKVideoStatusStopping;
            break;
        }
            
        case Video::PAUSED: {
            result = SKVideoStatusPaused;
            break;
        }
            
        case Video::NOT_STARTED: {
            result = SKVideoStatusNotStarted;
            break;
        }
            
        case Video::HINT_IS_VIDEOCALL_RECEIVED: {
            result = SKVideoStatusHintIsVideocallReceived;
            break;
        }
            
        case Video::UNKNOWN: {
            result = SKVideoStatusUnknown;
            break;
        }
            
        case Video::RENDERING: {
            result = SKVideoStatusRendering;
            break;
        }
            
        case Video::CHECKING_SUBSCRIPTION: {
            result = SKVideoStatusCheckingSubscription;
            break;
        }
            
        case Video::SWITCHING_DEVICE: {
            result = SKVideoStatusSwitchingDevice;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

+ (SKVideoMediaType)decodeMediaType:(Video::MEDIATYPE)mediaType {
    SKVideoMediaType result = SKVideoMediaTypeUndefined;
    
    switch (mediaType) {
        case Video::MEDIA_SCREENSHARING: {
            result = SKVideoMediaTypeScreenSharing;
            break;
        }
            
        case Video::MEDIA_VIDEO: {
            result = SKVideoMediaTypeVideo;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

+ (Video::MEDIATYPE)encodeMediaType:(SKVideoMediaType)mediaType {
    Video::MEDIATYPE result = Video::MEDIA_VIDEO;
    
    switch (mediaType) {
        case SKVideoMediaTypeScreenSharing: {
            result = Video::MEDIA_SCREENSHARING;
            break;
        }
            
        case SKVideoMediaTypeVideo: {
            result = Video::MEDIA_VIDEO;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

+ (SKVideoVideoDeviceCapability)decodeVideoDeviceCapability:(Video::VIDEO_DEVICE_CAPABILITY)deviceCapability {
    SKVideoVideoDeviceCapability result = SKVideoVideoDeviceCapabilityUndefined;
    
    switch (deviceCapability) {
        case Video::VIDEOCAP_HQ_CAPABLE: {
            result = SKVideoVideoDeviceCapabilityHQCapable;
            break;
        }
            
        case Video::VIDEOCAP_HQ_CERTIFIED: {
            result = SKVideoVideoDeviceCapabilityHQCertified;
            break;
        }
            
        case Video::VIDEOCAP_REQ_DRIVERUPDATE: {
            result = SKVideoVideoDeviceCapabilityREQDriverUpdate;
            break;
        }
            
        case Video::VIDEOCAP_USB_HIGHSPEED: {
            result = SKVideoVideoDeviceCapabilityUSBHighspeed;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

@end
