/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKObject.h"

@class ConversationBinding;
@class SKMessage;
@class NSSet;
@class NSArray;

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

@interface SKConversation : SKObject {
    NSString* _displayName;
    NSString* _identity;
    SKConversationType _type;
}

@property (nonatomic, readonly) NSString* displayName;
@property (nonatomic, readonly) NSString* identity;
@property (nonatomic, readonly) SKConversationType type;

- (BOOL) ringOthers;
- (BOOL) leaveLiveSession;

- (NSSet*) participants;
- (SKMessage*) postText:(NSString*)text isXML:(BOOL)isXML;
- (BOOL) postFiles:(NSArray*) fileNames text:(NSString*) text;

- (NSSet*) participantsForFilter:(SKParticipantFilter) filter;

@end
