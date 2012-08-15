/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKObject.h"

@class ParticipantBinding;

@interface SKParticipant : SKObject {
    NSString* _identity;
    NSUInteger _soundLevel;
}

@property(nonatomic, readonly) NSString* identity;
@property(nonatomic, readonly) NSUInteger soundLevel;

- (BOOL) ring;
- (BOOL) ringOnLine:(NSString*) line videoEnabled:(BOOL) videoEnabled maxRedial:(NSUInteger) maxRedial retryPeriod:(NSUInteger) redialPeriod voicemail:(BOOL) voiceMail;

@end
