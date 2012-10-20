/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKConversation.h"

#import <Foundation/NSString.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSSet.h>
#import <Foundation/NSDate.h>
#import <Foundation/NSData.h>

#import <AppKit/NSImage.h>

#import "SKMessage.h"
#import "SKParticipant.h"

#import "ParticipantBinding.hpp"
#import "ConversationBinding.hpp"
#import "MessageBinding.hpp"

@interface SKConversation (Private)

- (NSString*) coreDisplayName;
- (NSString*) coreIdentity;
- (SKConversationType) type;
- (SKConversationMyStatus) myStatus;
- (SKConversationLocalLiveStatus) coreLocalLiveStatus;
- (BOOL) coreBookmarked;
- (NSDate*) coreLastActivityDate;
- (NSData*) coreMetaPictureData;

@property (nonatomic, copy, readwrite) NSString* displayName;
@property (nonatomic, copy, readwrite) NSString* identity;
@property (nonatomic, assign, readwrite) SKConversationType type;
@property (nonatomic, assign, readwrite) SKConversationMyStatus myStatus;
@property (nonatomic, assign, readwrite) SKConversationLocalLiveStatus localLiveStatus;
@property (nonatomic, assign, readwrite, getter=isBookmarked) BOOL bookmarked;
@property (nonatomic, retain, readwrite) NSDate* lastActivityDate;
@property (nonatomic, retain, readwrite) NSData* metaPictureData;

@end

@implementation SKConversation

@synthesize delegate = _delegate;

- (NSString *)description {
    return [self displayName];
}

- (NSString*) coreDisplayName {
    Sid::String name;
    NSString* result = nil;
    
    if (self.coreConversation->GetPropDisplayname(name)) {
        [self markPropertyAsCached:@"displayName"];
        result = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSString*) coreIdentity {
    Sid::String name;
    NSString* result = nil;
    
    if (self.coreConversation->GetPropIdentity(name)) {
        [self markPropertyAsCached:@"identity"];
        result = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (SKConversationMyStatus) coreMyStatus {
    Conversation::MY_STATUS status;
    SKConversationMyStatus result = SKConversationMyStatusUndefined;
    
    if (self.coreConversation->GetPropMyStatus(status)) {
        [self markPropertyAsCached:@"myStatus"];
        result = [SKConversation decodeMyStatus:status];
    }
    
    return result;
}

- (SKConversationLocalLiveStatus)coreLocalLiveStatus {
    Conversation::LOCAL_LIVESTATUS status;
    SKConversationLocalLiveStatus result = SKConversationLocalLiveStatusUndefined;
    
    if (self.coreConversation->GetPropLocalLivestatus(status)) {
        [self markPropertyAsCached:@"localLiveStatus"];
        result = [SKConversation decodeLocalLiveStatus:status];
    }
    
    return result;
}

- (BOOL)coreBookmarked {
    bool result = false;
    
    if (self.coreConversation->GetPropIsBookmarked(result)) {
        [self markPropertyAsCached:@"bookmarked"];
    }
    
    return (BOOL)result;
}

- (NSSet *)participants {
    return [self participantsForFilter:SKParticipantFilterAll];
}

- (NSArray *) lastMessages {
    return [self lastMessagesSinceDate:nil contextMessages:nil];
}

- (NSArray *) lastMessagesSinceDate:(NSDate *)date contextMessages:(__autoreleasing NSArray **)contextMessages{
    MessageRefs unconsumedMessagesRef;
    MessageRefs contextMessagesRef;
    NSMutableArray* result = nil;
    
    const uint timestamp = (date == nil) ? 0 : [date timeIntervalSince1970];
    
    if (self.coreConversation->GetLastMessages(unconsumedMessagesRef, contextMessagesRef, timestamp)) {
        if (contextMessages != nil) {
            NSUInteger size = contextMessagesRef.size();
            NSMutableArray* mutableContextMessages = [NSMutableArray arrayWithCapacity:size];
            
            for (NSUInteger i=0; i<size; i++) {
                SKMessage* message = [SKMessage resolve:contextMessagesRef[i]->ref()];
                [mutableContextMessages addObject:message];
            }
            
            *contextMessages = mutableContextMessages;
        }
        
        NSUInteger unconsumedSize = unconsumedMessagesRef.size();
        result = [NSMutableArray arrayWithCapacity:unconsumedSize];
        
        for (NSUInteger i=0; i<unconsumedSize; i++) {
            SKMessage* message = [SKMessage resolve:unconsumedMessagesRef[i]->ref()];
            [result addObject:message];
        }
    }
    
    return result;
    
}

- (NSData*) coreMetaPictureData {
    Sid::Binary image;
    NSData* result = nil;
    
    if (self.coreConversation->GetPropMetaPicture(image)) {
        [self markPropertyAsCached:@"metaPictureData"];
        result = [NSData dataWithBytes:image.data() length:image.size()];
    }
    
    return result;
}

+ (NSSet *)keyPathsForValuesAffectingMetaPicture {
    return [NSSet setWithObjects:@"metaPictureData", nil];
}

- (NSImage *) metaPicture {
    return [[[NSImage alloc] initWithData:[self metaPictureData]] autorelease];
}

- (NSDate*) coreLastActivityDate {
    uint timestamp;
    NSDate* result = nil;
    
    if (self.coreConversation->GetPropLastActivityTimestamp(timestamp)) {
        [self markPropertyAsCached:@"lastActivityTimestamp"];
        result = [NSDate dateWithTimeIntervalSince1970:timestamp];
    }
    
    return result;
}

- (NSSet*) participantsForFilter:(SKParticipantFilter) filter {
    ParticipantRefs participants;
    NSMutableSet* result = nil;
    
    Conversation::PARTICIPANTFILTER participantFilter = Conversation::ALL;
    
    switch (filter) {
        case SKParticipantFilterApplicants:
            participantFilter = Conversation::APPLICANTS;
            break;
            
        case SKParticipantFilterConsumers:
            participantFilter = Conversation::CONSUMERS;
            break;
            
        case SKParticipantFilterConsumersAndApplications:
            participantFilter = Conversation::CONSUMERS_AND_APPLICANTS;
            break;
            
        case SKParticipantFilterMyself:
            participantFilter = Conversation::MYSELF;
            break;
            
        case SKParticipantFilterOtherConsumers:
            participantFilter = Conversation::OTHER_CONSUMERS;
            break;
            
        default:
            break;
    }
    
    if (self.coreConversation->GetParticipants(participants, participantFilter)) {
        NSUInteger size = participants.size();
        result = [NSMutableSet setWithCapacity:size];
        
        for (NSUInteger i=0; i<size; i++) {
            SKParticipant* participant = [SKObject resolve:participants[i]->ref()];
            [result addObject:participant];
        }
    }
    
    return result;
}

- (SKConversationType) coreType {
    Conversation::TYPE type;
    SKConversationType result = SKConversationTypeDialog;
    
    if (self.coreConversation->GetPropType(type)) {
        [self markPropertyAsCached:@"type"];
        result = [SKConversation decodeType:type];
    }
    
    return result;
}

- (NSString *) displayName {
    if (![self isPropertyCached:@"displayName"]) {
        [self->_displayName release];
        self->_displayName = [[self coreDisplayName] copy];
    }
    return self->_displayName;
}

- (void)setDisplayName:(NSString *) aDisplayName {
    if (self->_displayName != aDisplayName) {
        [self->_displayName release];
        self->_displayName = [aDisplayName copy];
    }
}

- (NSString *) identity {
    if (![self isPropertyCached:@"identity"]) {
        [self->_identity release];
        self->_identity = [[self coreIdentity] copy];
    }
    return self->_identity;
}

- (void)setIdentity:(NSString *) aIdentity {
    if (self->_identity != aIdentity) {
        [self->_identity release];
        self->_identity = [aIdentity copy];
    }
}

- (SKConversationType) type {
    if (![self isPropertyCached:@"type"]) {
        self->_type = [self coreType];
    }
    
    return self->_type;
}

- (void)setType:(SKConversationType) aType {
    if (self->_type != aType) {
        self->_type = aType;
    }
}

- (SKConversationLocalLiveStatus)localLiveStatus {
    if (![self isPropertyCached:@"localLiveStatus"]) {
        self->_localLiveStatus = [self coreLocalLiveStatus];
    }
    
    return self->_localLiveStatus;
}

- (void)setLocalLiveStatus:(SKConversationLocalLiveStatus)localLiveStatus {
    if (self->_localLiveStatus != localLiveStatus) {
        self->_localLiveStatus = localLiveStatus;
    }
}

- (SKConversationMyStatus)myStatus {
    if (![self isPropertyCached:@"myStatus"]) {
        self->_myStatus = [self coreMyStatus];
    }
    
    return self->_myStatus;
}

- (void)setMyStatus:(SKConversationMyStatus)myStatus {
    if (self->_myStatus != myStatus) {
        self->_myStatus = myStatus;
    }
}

- (BOOL) isBookmarked {
    if (![self isPropertyCached:@"bookmarked"]) {
        self->_bookmarked = [self coreBookmarked];
    }
    
    return self->_bookmarked;
}

- (void)setBookmarked:(BOOL)bookmarked {
    if (self->_bookmarked != bookmarked) {
        self->_bookmarked = bookmarked;
    }
}

- (NSData *) metaPictureData {
    if (![self isPropertyCached:@"metaPictureData"]) {
        [self->_metaPictureData release];
        self->_metaPictureData = [[self coreMetaPictureData] retain];
    }
    
    return self->_metaPictureData;
}

- (void)setMetaPictureData:(NSData *) pictureData {
    if (self->_metaPictureData != pictureData) {
        [self->_metaPictureData release];
        self->_metaPictureData = [pictureData retain];
    }
}

- (NSDate *)lastActivityDate {
    if (![self isPropertyCached:@"lastActivityDate"]) {
        [self->_lastActivityDate release];
        self->_lastActivityDate = [[self coreLastActivityDate] retain];
    }
    
    return self->_lastActivityDate;
}

- (void)setLastActivityDate:(NSDate *)lastActivityDate {
    if (self->_lastActivityDate != lastActivityDate) {
        [self->_lastActivityDate release];
        self->_lastActivityDate = [lastActivityDate retain];
    }
}

- (SKMessage*) postText:(NSString*)text isXML:(BOOL)isXML {
    SKMessage* result = nil;
    MessageRef message;
    
    if (self.coreConversation->PostText([text cStringUsingEncoding:NSUTF8StringEncoding], message, isXML)) {
        result = [SKObject resolve:message];
    }
    
    return result;
}

- (BOOL) postFiles:(NSArray*) fileNames text:(NSString*) text {
    Sid::List_Filename files;
    TRANSFER_SENDFILE_ERROR errorCode;
    Sid::Filename errorFile;
    
    for (NSString* name in fileNames) {
        files.append([name cStringUsingEncoding:NSUTF8StringEncoding]);
    }
    
    BOOL result = self.coreConversation->PostFiles(files, [text cStringUsingEncoding:NSUTF8StringEncoding], errorCode, errorFile);
    
    return result;
}

- (BOOL) ringOthers {
    return self.coreConversation->RingOthers();
}

- (BOOL) leaveLiveSession {
    return self.coreConversation->LeaveLiveSession();
}

- (BOOL)joinLiveSession {
    return self.coreConversation->JoinLiveSession();
}

- (void)onChange:(int)prop {
    switch (prop) {
        case Conversation::P_IDENTITY: {
            self.identity = [self coreIdentity];
            break;
        }
            
        case Conversation::P_TYPE: {
            self.type = [self coreType];
            break;
        }
            
        case Conversation::P_DISPLAYNAME: {
            self.displayName = [self coreDisplayName];
            
            if ([self.delegate respondsToSelector:@selector(didUpdateMetaPropertiesForConversation:)]) {
                [self.delegate conversationDidUpdateMetaProperties:self];
            }
            
            break;
        }
            
        case Conversation::P_LOCAL_LIVESTATUS: {
            SKConversationLocalLiveStatus status = [self coreLocalLiveStatus];
            self.localLiveStatus = status;
            [self.delegate conversation:self didChangeLocalLiveStatus:status];
            break;
        }
            
        case Conversation::P_MY_STATUS: {
            SKConversationMyStatus status = [self coreMyStatus];
            self.myStatus = status;
            
            if ([self.delegate respondsToSelector:@selector(conversation:didChangeMyStatus:)]) {
                [self.delegate conversation:self didChangeMyStatus:status];
            }
            
            break;
        }

        case Conversation::P_IS_BOOKMARKED: {
            self.bookmarked = [self coreBookmarked];
            break;
        }
            
        case Conversation::P_LAST_ACTIVITY_TIMESTAMP: {
            self.lastActivityDate = [self coreLastActivityDate];
            break;
        }

        case Conversation::P_META_PICTURE: {
            self.metaPictureData = [self coreMetaPictureData];
            
            if ([self.delegate respondsToSelector:@selector(didUpdateMetaPropertiesForConversation:)]) {
                [self.delegate conversationDidUpdateMetaProperties:self];
            }
            
            break;
        }

        default:
            break;
    }
}

- (void)dealloc {
    [self->_displayName release];
    [self->_identity release];
    [self->_metaPictureData release];

    [super dealloc];
}

@end
