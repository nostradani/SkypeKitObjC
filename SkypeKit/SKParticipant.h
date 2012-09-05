/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKObject.h"

@class ParticipantBinding;
@class SKContact;

typedef enum {
    SKParticipantTextStatusTextUnknown,
    SKParticipantTextStatusTextNA,
    SKParticipantTextStatusReading,
    SKParticipantTextStatusWriting,
    SKParticipantTextStatusWritingAsAngry,
    SKParticipantTextStatusWritingAsCat
} SKParticipantTextStatus;

@interface SKParticipant : SKObject {
    NSString* _identity;
    NSUInteger _soundLevel;
    SKParticipantTextStatus _textStatus;
}

@property(nonatomic, readonly) NSString* identity;
@property(nonatomic, readonly) NSUInteger soundLevel;
@property(nonatomic, readonly) SKParticipantTextStatus textStatus;

@property (nonatomic, readonly) SKContact* contact;

- (BOOL) ring;
- (BOOL) ringOnLine:(NSString*) line videoEnabled:(BOOL) videoEnabled maxRedial:(NSUInteger) maxRedial retryPeriod:(NSUInteger) redialPeriod voicemail:(BOOL) voiceMail;

@end
