/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKObject.h"
#import <Foundation/NSDate.h>

@class ConversationBinding;
@class SKMessage;
@class NSSet;
@class NSArray;
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

@protocol SKConversationDelegate <NSObject>

- (void) conversation:(SKConversation*) conversation didChangeLocalLiveStatus:(SKConversationLocalLiveStatus) status;
- (void) conversation:(SKConversation*) conversation didReceiveMessages:(NSArray *) messages;

@end

@interface SKConversation : SKObject {
    NSString* _displayName;
    NSString* _identity;
    SKConversationType _type;
    SKConversationLocalLiveStatus _localLiveStatus;
    id<SKConversationDelegate> _delegate;
}

@property (nonatomic, assign) id<SKConversationDelegate> delegate;
@property (nonatomic, readonly) NSString* displayName;
@property (nonatomic, readonly) NSString* identity;
@property (nonatomic, readonly) SKConversationType type;
@property (nonatomic, readonly) SKConversationLocalLiveStatus localLiveStatus;

- (BOOL) ringOthers;

- (BOOL) joinLiveSession;
- (BOOL) leaveLiveSession;

- (NSSet*) participants;

- (NSArray *) lastMessages;
- (NSArray *) lastMessagesSinceDate:(NSDate *)date;

- (SKMessage*) postText:(NSString*)text isXML:(BOOL)isXML;
- (BOOL) postFiles:(NSArray*) fileNames text:(NSString*) text;

- (NSSet*) participantsForFilter:(SKParticipantFilter) filter;

@end
