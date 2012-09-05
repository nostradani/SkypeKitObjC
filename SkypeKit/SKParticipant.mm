/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKParticipant.h"
#import "SKContact.h"

#import <Foundation/NSString.h>

#import "ParticipantBinding.hpp"

@interface SKParticipant (Private)

- (NSUInteger) coreSoundLevel;
- (NSString*) coreIdentity;
- (SKParticipantTextStatus) coreTextStatus;

@property (nonatomic, assign) NSUInteger soundLevel;
@property (nonatomic, copy) NSString* identity;
@property (nonatomic, assign) SKParticipantTextStatus textStatus;

@end

@implementation SKParticipant

- (NSString*) coreIdentity {
    Sid::String name;
    NSString* result = nil;
    
    if (self.coreParticipant->GetPropIdentity(name)) {
        [self markPropertyAsCached:@"identity"];
        result = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (SKParticipantTextStatus)coreTextStatus {
    Participant::TEXT_STATUS status;
    SKParticipantTextStatus result = SKParticipantTextStatusTextUnknown;
    
    if (self.coreParticipant->GetPropTextStatus(status)) {
        [self markPropertyAsCached:@"textStatus"];
        result = [SKParticipant decodeTextStatus:status];
    }
    
    return result;
}

- (NSUInteger) coreSoundLevel {
    uint level = 0;
    if (self.coreParticipant->GetPropSoundLevel(level)) {
        [self markPropertyAsCached:@"soundLevel"];
    }
    
    return level;
}

- (NSString*) identity {
    if (![self isPropertyCached:@"identity"]) {
        self.identity = [self coreIdentity];
    }
    
    return self->_identity;
}

- (void)setIdentity:(NSString *) aIdentity {
    if (![self->_identity isEqualToString:aIdentity]) {
        [self->_identity release];
        self->_identity = [aIdentity copy];
    }
}

- (NSUInteger) soundLevel {
    if (![self isPropertyCached:@"soundLevel"]) {
        self->_soundLevel = [self coreSoundLevel];
    }
    
    return self->_soundLevel;
}

- (void) setSoundLevel:(NSUInteger)level {
    if (self->_soundLevel != level) {
        self->_soundLevel = level;
    }
}

- (void)setTextStatus:(SKParticipantTextStatus)textStatus {
    if (self->_textStatus != textStatus) {
        self->_textStatus = textStatus;
    }
}

- (SKParticipantTextStatus)textStatus {
    if (![self isPropertyCached:@"soundLevel"]) {
        self->_textStatus = [self coreTextStatus];
    }
    
    return self->_textStatus;
}

- (SKContact*) contact {
    Sid::String identity = [self.identity UTF8String];
    ContactRef coreContact;
    SKContact* result = nil;
    
    if (self.coreParticipant->getSkype()->GetContact(identity, coreContact)) {
        result = [SKObject resolve:coreContact->ref()];
    }
    
    return result;
}

- (void)onChange:(int)prop {
    switch (prop) {
        case Participant::P_SOUND_LEVEL: {
            self.soundLevel = [self coreSoundLevel];
            break;
        }
            
        case Participant::P_IDENTITY: {
            self.identity = [self coreIdentity];
            break;
        }
            
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
