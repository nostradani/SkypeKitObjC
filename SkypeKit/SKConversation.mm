/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKConversation.h"

#import <Foundation/NSString.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSSet.h>

#import "SKMessage.h"
#import "SKParticipant.h"

#import "ParticipantBinding.hpp"
#import "ConversationBinding.hpp"
#import "MessageBinding.hpp"

@interface SKConversation (Private)

- (NSString*) coreDisplayName;
- (NSString*) coreIdentity;
- (SKConversationType) type;
- (SKConversationLocalLiveStatus) coreLocalLiveStatus;

@property (nonatomic, copy, readwrite) NSString* displayName;
@property (nonatomic, copy, readwrite) NSString* identity;
@property (nonatomic, assign, readwrite) SKConversationType type;
@property (nonatomic, assign, readwrite) SKConversationLocalLiveStatus localLiveStatus;

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

- (SKConversationLocalLiveStatus)coreLocalLiveStatus {
    Conversation::LOCAL_LIVESTATUS status;
    SKConversationLocalLiveStatus result = SKConversationLocalLiveStatusUndefined;
    
    if (self.coreConversation->GetPropLocalLivestatus(status)) {
        [self markPropertyAsCached:@"localLiveStatus"];
        result = [SKConversation decodeLocalLiveStatus:status];
    }
    
    return result;
}

- (NSSet *)participants {
    return [self participantsForFilter:SKParticipantFilterAll];
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
            break;
        }
            
        case Conversation::P_LOCAL_LIVESTATUS: {
            SKConversationLocalLiveStatus status = [self coreLocalLiveStatus];
            self.localLiveStatus = status;
            [self.delegate conversation:self didChangeLocalLiveStatus:status];
            break;
        }
            
        default:
            break;
    }
}

- (void)dealloc {
    [self->_displayName release];
    [self->_identity release];
    
    [super dealloc];
}

@end
