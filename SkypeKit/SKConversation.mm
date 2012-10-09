/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKConversation.h"

#import <Foundation/NSString.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSSet.h>
#import <Foundation/NSDate.h>

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
- (NSData*) corePictureData;

@property (nonatomic, copy, readwrite) NSString* displayName;
@property (nonatomic, copy, readwrite) NSString* identity;
@property (nonatomic, assign, readwrite) SKConversationType type;
@property (nonatomic, assign, readwrite) SKConversationMyStatus myStatus;
@property (nonatomic, assign, readwrite) SKConversationLocalLiveStatus localLiveStatus;
@property (nonatomic, assign, readwrite) BOOL bookmarked;
@property (nonatomic, retain, readwrite) NSDate* lastActivityDate;
@property (nonatomic, retain, readwrite) NSData* pictureData;

@end

@implementation SKConversation

@synthesize delegate = _delegate;

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

- (SKConversationMyStatus)coreMyStatus {
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

- (bool)coreBookmarked {
    bool result = false;
    
    if (self.coreConversation->GetPropIsBookmarked(result)) {
        [self markPropertyAsCached:@"bookmarked"];
    }
    
    return result;
}

- (NSSet *)participants {
    return [self participantsForFilter:SKParticipantFilterAll];
}

- (NSArray *) lastMessages {
    return [self lastMessagesSinceDate:[NSDate dateWithTimeIntervalSinceNow:-(60*60*24*7)]];
}

- (NSArray *) lastMessagesSinceDate:(NSDate *)date {
    
    MessageRefs unconsumedMessageRefs;
    MessageRefs consumedMessageRefs;
    NSMutableArray* result = nil;
    NSMutableArray* unconsumed = nil;
    
    if (self.coreConversation->GetLastMessages(consumedMessageRefs, unconsumedMessageRefs, [date timeIntervalSince1970])) {
        NSUInteger size = consumedMessageRefs.size();
        result = [NSMutableArray arrayWithCapacity:size];
        
        for (NSUInteger i=0; i<size; i++) {
            SKMessage* message = [SKMessage resolve:consumedMessageRefs[i]->ref()];
            [result addObject:message];
        }
        
        NSUInteger unconsumedSize = unconsumedMessageRefs.size();
        unconsumed = [NSMutableArray arrayWithCapacity:unconsumedSize];
        
        for (NSUInteger i=0; i<unconsumedSize; i++) {
            SKMessage* message = [SKMessage resolve:unconsumedMessageRefs[i]->ref()];
            [unconsumed addObject:message];
        }
        
        if ([unconsumed count]) {
            [self.delegate conversation:self didReceiveMessages:unconsumed];
        }
        
    }
    
    return result;
    
}

- (NSArray *) unconsumedMessages {
    return [self unconsumedMessagesSinceDate:[NSDate dateWithTimeIntervalSinceNow:-(60*60*24*7)]];
}

- (NSArray *) unconsumedMessagesSinceDate:(NSDate *)date {
    
    MessageRefs unconsumedMessageRefs;
    MessageRefs consumedMessageRefs;
    NSMutableArray* result = nil;
    
    if (self.coreConversation->GetLastMessages(consumedMessageRefs, unconsumedMessageRefs, [date timeIntervalSince1970])) {
        NSUInteger unconsumedSize = unconsumedMessageRefs.size();
        result = [NSMutableArray arrayWithCapacity:unconsumedSize];
        
        for (NSUInteger i=0; i<unconsumedSize; i++) {
            SKMessage* message = [SKMessage resolve:unconsumedMessageRefs[i]->ref()];
            [result addObject:message];
        }
        
    }
    
    return result;
    
}

- (NSData*) corePictureData {
    Sid::Binary image;
    NSData* result = nil;
    
    if (self.coreConversation->GetPropMetaPicture(image)) {
        [self markPropertyAsCached:@"picture"];
        result = [NSData dataWithBytes:image.data() length:image.size()];
    }
    
    return result;
}

- (NSImage *) picture {
    return [[[NSImage alloc] initWithData:[self pictureData]] autorelease];
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
    Conversation::TYPE aType;
    SKConversationType result = SKConversationTypeDialog;
    
    if (self.coreConversation->GetPropType(aType)) {
        [self markPropertyAsCached:@"type"];
        switch (aType) {
            case Conversation::CONFERENCE:
                result = SKConversationTypeConference;
                break;
                
            case Conversation::TERMINATED_CONFERENCE:
                result = SKConversationTypeTerminatedConference;
                break;
                
            case Conversation::LEGACY_VOICE_CONFERENCE:
                result = SKConversationTypeLegacyVoiceConference;
                break;
                
            case Conversation::LEGACY_SHAREDGROUP:
                result = SKConversationTypeLegacySharedGroup;
                break;
                
            default:
                break;
        }
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

- (BOOL)bookmarked {
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

- (NSData *)pictureData {
    if (![self isPropertyCached:@"pictureData"]) {
        [self->_pictureData release];
        self->_pictureData = [[self corePictureData] retain];
    }
    
    return self->_pictureData;
}

- (void)setPictureData:(NSData *) aPictureData {
    if (self->_pictureData != aPictureData) {
        [self->_pictureData release];
        self->_pictureData = [aPictureData retain];
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
            [self.delegate didUpdateMetaPropertiesForConversation:self];
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
            [self.delegate conversation:self didChangeMyStatus:status];
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
            self.pictureData = [self corePictureData];
            [self.delegate didUpdateMetaPropertiesForConversation:self];
            break;
        }

        default:
            break;
    }
}

- (void)dealloc {
    [self->_displayName release];
    [self->_identity release];
    [self->_pictureData release];

    [super dealloc];
}

@end
