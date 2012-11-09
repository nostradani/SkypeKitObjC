/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKParticipant.h"
#import "SKTransfer.h"

@class ConversationBinding;
@class SKMessage;
@class NSSet;
@class NSArray;
@class NSDate;
@class NSData;
@class NSImage;
@class SKConversation;

typedef enum {
    SKParticipantFilterAll,    
    SKParticipantFilterConsumers,	
    SKParticipantFilterApplicants, 	
    SKParticipantFilterConsumersAndApplications,    
    SKParticipantFilterMyself,    
    SKParticipantFilterOtherConsumers    
} SKParticipantFilter;

typedef enum {
    SKConversationTypeUnknown,
    SKConversationTypeDialog,
    SKConversationTypeConference,
    SKConversationTypeTerminatedConference,
    SKConversationTypeLegacyVoiceConference,
    SKConversationTypeLegacySharedGroup
} SKConversationType;

typedef enum {
    SKConversationListTypeAllConversations,
    SKConversationListTypeInboxConversations,
    SKConversationListTypeBookmarkedConversations,
    SKConversationListTypeLiveConversations,
    SKConversationListTypeReallyAllConversations
} SKConversationListType;

typedef enum {
    SKConversationLocalLiveStatusUndefined,
    SKConversationLocalLiveStatusNone,
    SKConversationLocalLiveStatusStarting,
    SKConversationLocalLiveStatusRingingForMe,
    SKConversationLocalLiveStatusIMLive,
    SKConversationLocalLiveStatusOnHoldLocally,
    SKConversationLocalLiveStatusOnHoldRemotely,
    SKConversationLocalLiveStatusOthersAreLive,
    SKConversationLocalLiveStatusOthersAreLiveFull,
    SKConversationLocalLiveStatusPlayingVoiceMessage,
    SKConversationLocalLiveStatusRecordingVoiceMessage,
    SKConversationLocalLiveStatusRecentlyLive,
    SKConversationLocalLiveStatusTransferring,
} SKConversationLocalLiveStatus;

typedef enum {
    SKConversationMyStatusUndefined,
    SKConversationMyStatusConnecting,
    SKConversationMyStatusDownloadingMessages,
    SKConversationMyStatusRetryConnecting,
    SKConversationMyStatusQueuedToEnter,
    SKConversationMyStatusApplicant,
    SKConversationMyStatusApplicationDenied,
    SKConversationMyStatusInvalidAccessToken,
    SKConversationMyStatusConsumer,
    SKConversationMyStatusRetiredForcefully,
    SKConversationMyStatusRetiredVoluntarily,
} SKConversationMyStatus;

@protocol SKConversationDelegate <NSObject>

@required
- (void) conversation:(SKConversation*) conversation didChangeLocalLiveStatus:(SKConversationLocalLiveStatus) status;
- (void) conversation:(SKConversation*) conversation didReceiveMessage:(SKMessage *) message;

@optional
- (void) conversation:(SKConversation*) conversation didChangeMyStatus:(SKConversationMyStatus) status;
- (void) conversationDidUpdateMetaProperties:(SKConversation*) conversation;

@end

@interface SKConversation : SKObject {
    NSString* _displayName;
    NSString* _identity;
    SKConversationType _type;
    SKConversationLocalLiveStatus _localLiveStatus;
    SKConversationMyStatus _myStatus;
    BOOL _bookmarked;
    NSDate* _lastActivityDate;
    NSData* _metaPictureData;
    id<SKConversationDelegate> _delegate;
}

@property (nonatomic, assign) id<SKConversationDelegate> delegate;
@property (nonatomic, readonly) NSString* displayName;
@property (nonatomic, readonly) NSString* identity;
@property (nonatomic, readonly) SKConversationType type;
@property (nonatomic, readonly) SKConversationLocalLiveStatus localLiveStatus;
@property (nonatomic, readonly) SKConversationMyStatus myStatus;
@property (nonatomic, readonly, getter=isBookmarked) BOOL bookmarked;
@property (nonatomic, readonly) NSDate *lastActivityDate;
@property (nonatomic, readonly) NSData* metaPictureData;

- (BOOL) ringOthers;

- (BOOL) joinLiveSession;
- (BOOL) leaveLiveSession;

- (BOOL) setMyTextStatus:(SKParticipantTextStatus) textStatus;

- (NSSet*) participants;

- (NSImage *) metaPicture;

- (SKMessage*) postText:(NSString*)text isXML:(BOOL)isXML;

- (SKMessage*) postFiles:(NSArray*) fileNames
                    text:(NSString*) text
               errorCode:(SKTransferSendFileError*) errorCode
               errorFile:(NSString**) errorFile;

- (NSSet*) participantsForFilter:(SKParticipantFilter) filter;

/**
 * Returns a list of unconsumed messages for the last 24h.
 */
- (NSArray *) lastMessages;

/**
 * Returns the last (unconsumed) messages of a conersation.
 *
 * This message can also retrieve a list of context messages.
 * Those are messages received before the requested last messages to set them into a context.
 *
 * @param date The date of the earliest message to retrieve. If set to nil, messages of the last 24h are retrieved.
 * @param contextMessages An array pointer to retrieve the context messages.
 *
 * @return A list of unsconsumed messages.
 */
- (NSArray *) lastMessagesSinceDate:(NSDate *)date contextMessages:(NSArray**) contextMessages;

@end
