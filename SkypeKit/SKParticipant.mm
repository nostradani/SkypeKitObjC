/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKParticipant.h"

#import <Foundation/NSString.h>

#import "ParticipantBinding.hpp"

@interface SKParticipant (Private)

- (NSUInteger) coreSoundLevel;
- (NSString*) coreIdentity;

@property (nonatomic, assign) NSUInteger soundLevel;
@property (nonatomic, copy) NSString* identity;

@end

@implementation SKParticipant

- (NSString*) identity {
    if (![self isPropertyCached:@"identity"]) {
        self.identity = [self coreIdentity];
    }
    
    return self->_identity;
}

- (NSString*) coreIdentity {
    Sid::String name;
    NSString* result = nil;
    
    if (self.coreParticipant->GetPropIdentity(name)) {
        result = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (void)setIdentity:(NSString *) aIdentity {
    if (![self->_identity isEqualToString:aIdentity]) {
        [self->_identity release];
        self->_identity = [aIdentity copy];
    }
}

- (NSUInteger) soundLevel {
    if (![self isPropertyCached:@"soundLevel"]) {
        self.soundLevel = [self coreSoundLevel];
    }
    
    return self->_soundLevel;
}

- (void) setSoundLevel:(NSUInteger)level {
    if (self->_soundLevel != level) {
        self->_soundLevel = level;
    }
}

- (NSUInteger) coreSoundLevel {
    uint level = 0;
    if (self.coreParticipant->GetPropSoundLevel(level)) {
        [self markPropertyAsCached:@"soundLevel"];
    }
    
    return level;
}

- (void)onChange:(int)prop {
    switch (prop) {
        case Participant::P_SOUND_LEVEL:
            self.soundLevel = [self coreSoundLevel];
            break;
        case Participant::P_IDENTITY:
            self.identity = [self coreIdentity];
            break;
            
        default:
            break;
    }
}

- (BOOL) ring {
    return [self ringOnLine:self.identity videoEnabled:NO maxRedial:1 retryPeriod:10 voicemail:NO];
}

- (BOOL) ringOnLine:(NSString*) line videoEnabled:(BOOL) videoEnabled maxRedial:(NSUInteger) maxRedial retryPeriod:(NSUInteger) redialPeriod voicemail:(BOOL) voiceMail {
    return self.coreParticipant->Ring([line UTF8String], videoEnabled, (uint)maxRedial, (uint)redialPeriod, voiceMail);
}

- (void)dealloc {
    [self->_identity release];
    
    [super dealloc];
}

@end
