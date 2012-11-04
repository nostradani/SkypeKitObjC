/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKObject.h"

@class ParticipantBinding;
@class SKContact;
@class SKParticipant;
@class SKConversation;

typedef enum {
    SKParticipantTextStatusTextUnknown,
    SKParticipantTextStatusTextNA,
    SKParticipantTextStatusReading,
    SKParticipantTextStatusWriting,
    SKParticipantTextStatusWritingAsAngry,
    SKParticipantTextStatusWritingAsCat
} SKParticipantTextStatus;

@protocol SKParticipantDelegate <NSObject>

- (void)participant:(SKParticipant *)participant didUpdateTextStatus:(SKParticipantTextStatus) textStatus;

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

- (SKConversation*) conversation;

- (BOOL) ring;
- (BOOL) ringOnLine:(NSString*) line videoEnabled:(BOOL) videoEnabled maxRedial:(NSUInteger) maxRedial retryPeriod:(NSUInteger) redialPeriod voicemail:(BOOL) voiceMail;

@end
