/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "ObjectBinding.hpp"

#import "SKVideo.h"

#import <skype-embedded_2.h>

class VideoImp : public Video, public ObjectImp {
public:
    typedef DRef<VideoImp, Video> Ref;
    typedef DRefs<VideoImp, Video> Refs;
    
    VideoImp(unsigned int oid, SERootObject* root);
    ~VideoImp();
    
    virtual void OnChange(int prop);
    
protected:
    virtual SEReference coreRef();
};

@interface SKVideo (Binding)

+ (SKVideoStatus) decodeStatus:(Video::STATUS) status;
+ (SKVideoMediaType) decodeMediaType:(Video::MEDIATYPE) mediaType;
+ (Video::MEDIATYPE) encodeMediaType:(SKVideoMediaType) mediaType;
+ (SKVideoVideoDeviceCapability) decodeVideoDeviceCapability:(Video::VIDEO_DEVICE_CAPABILITY) deviceCapability;

@property (nonatomic, readonly) VideoImp* coreVideo;

@end
