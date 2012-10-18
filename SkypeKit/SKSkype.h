/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import <Foundation/NSObject.h>

#import "SKContactGroup.h"
#import "SKConversation.h"

@class SkypeBinding;
@class SKAccount;
@class SKConversation;
@class SKMessage;
@class SKAudioDevice;
@class SKContactSearch;
@class NSDictionary;
@class NSData;
@class NSSet;

@protocol SKAccountDelegate;
@protocol SKContactGroupDelegate;

@protocol SKSkypeDelegate <NSObject>

- (void) conversation:(SKConversation*) conversation didReceiveMessage:(SKMessage*) message changesTimestamp:(BOOL) changesTimestamp;
- (void) listChangedWithConversation:(SKConversation*) conversation type:(SKConversationListType) type added:(BOOL) added;

@end

@interface SKSkype : NSObject {
    void* _skype;
    char* _keyBuffer;
    id<SKSkypeDelegate> _delegate;
    
    NSDictionary* _countryNameMapping;
    NSDictionary* _countryPrefixMapping;
    NSDictionary* _countryDialExampleMapping;
    NSDictionary* _languageMapping;
}

@property (nonatomic, assign) id<SKSkypeDelegate> delegate;
@property (nonatomic, readonly) NSDictionary* countryNameMapping;
@property (nonatomic, readonly) NSDictionary* countryPrefixMapping;
@property (nonatomic, readonly) NSDictionary* countryDialExampleMapping;
@property (nonatomic, readonly) NSDictionary* languageMapping;

- (id) initWithKeyData: (NSData*) data address:(NSString*) address port:(NSUInteger)port logFile:(NSString*) filename;
+ (id) skypeWithKeyData: (NSData*) data address:(NSString*) address port:(NSUInteger)port logFile:(NSString*) filename;

- (void) start;
- (void) stop;

- (SKAccount*) accountForName: (NSString*) name;
- (SKContact*) contactWithIdentity: (NSString*) identity;

- (SKContactGroup*) hardwiredContactGroup: (SKContactGroupType) type;

- (NSArray*) customContactGroups;
- (SKContactGroup*) createCustomContactGroup;

- (SKConversation*) conversationWithParticipants:(NSSet*) participants createIfNonExisting:(BOOL) create igonoreIfBookmarkedOrNamed:(BOOL) bookmarked;
- (SKConversation*) conversationWithIdentity:(NSString*) identity;
- (SKContactSearch*) basicContactSearch:(NSString*) searchTerm;

- (NSArray*) availableOutputDevices;
- (NSArray*) availableRecordingDevices;
- (NSArray*) availableVideoDevices;

- (BOOL) selectCallInDevice:(SKAudioDevice*)inDevice callOutDevice:(SKAudioDevice*) outDevice waveDevice:(SKAudioDevice*) waveDevice;

@end
