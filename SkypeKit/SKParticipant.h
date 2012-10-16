/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKObject.h"

@class ParticipantBinding;
@class SKContact;
@class SKParticipant;

typedef enum {
    SKParticipantTextStatusTextUnknown,
    SKParticipantTextStatusTextNA,
    SKParticipantTextStatusReading,
    SKParticipantTextStatusWriting,
    SKParticipantTextStatusWritingAsAngry,
    SKParticipantTextStatusWritingAsCat
} SKParticipantTextStatus;

@protocol SKParticipantDelegate <NSObject>

- (void)participantUpdatedTextStatus:(SKParticipant *)participant;

@end

@interface SKParticipant : SKObject {
    NSString* _identity;
    NSUInteger _soundLevel;
    SKParticipantTextStatus _textStatus;
    id _delegate;
}

@property(nonatomic, readonly) NSString* identity;
@property(nonatomic, readonly) NSUInteger soundLevel;
@property(nonatomic, readonly) SKParticipantTextStatus textStatus;

@property (nonatomic, readonly) SKContact* contact;

@property (nonatomic, assign) id <SKParticipantDelegate> delegate;

- (BOOL) ring;
- (BOOL) ringOnLine:(NSString*) line videoEnabled:(BOOL) videoEnabled maxRedial:(NSUInteger) maxRedial retryPeriod:(NSUInteger) redialPeriod voicemail:(BOOL) voiceMail;

@end
