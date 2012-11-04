/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKSkype.h"

#import <Foundation/NSString.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSTask.h>
#import <Foundation/NSFileManager.h>
#import <Foundation/NSThread.h>
#import <Foundation/NSData.h>
#import <Foundation/NSBundle.h>

#import "SKMessage.h"
#import "SKAccount.h"
#import "SKContactGroup.h"
#import "SKConversation.h"
#import "SKAudioDevice.h"
#import "SKVideoDevice.h"

#import "SkypeBinding.hpp"
#import "AccountBinding.hpp"
#import "ContactGroupBinding.hpp"
#import "ContactBinding.hpp"
#import "MessageBinding.hpp"
#import "ConversationBinding.hpp"
#import "ContactSearchBinding.hpp"

#import <AppKit/NSWorkspace.h>
#import <Foundation/NSFileHandle.h>

#import <skype-embedded_2.h>

@interface SKSkype (Private)

@property (nonatomic, readonly) SkypeImp* skype;

- (void) loadISOMapping;

@end

@implementation SKSkype

@synthesize delegate = _delegate;

+ (BOOL) startRuntime {
    @autoreleasepool {
        NSString* path = [[NSBundle bundleForClass:self] resourcePath];
        NSString* exe = [NSString stringWithFormat:@"%@/SkypeKitRuntimeLauncher",path];
        NSTask* task = [[NSTask alloc] init];
        [task setArguments:[NSArray arrayWithObject:[NSString stringWithFormat:@"%@/mac-x86-skypekit",path]]];
        [task setLaunchPath:exe];
        [task launch];
        [task waitUntilExit];
    }
    
    return YES;
}

- (id) initWithKeyData: (NSData*) data address:(NSString*) address port:(NSUInteger)port logFile:(NSString*) filename {
    self = [super init];
    
    if (self) {
        self->_skype = new SkypeImp();
        self.skype->bind(self);
        
        NSUInteger size = [data length];
        self->_keyBuffer = new char[size + 1];
        memcpy(self->_keyBuffer, [data bytes], size);
        self->_keyBuffer[size] = 0;
        
        self.skype->set_dispatch_all();
        TransportInterface::Status status = self.skype->init(self->_keyBuffer, [address cStringUsingEncoding:NSUTF8StringEncoding], (uint)port, [filename cStringUsingEncoding:NSUTF8StringEncoding]);
        
        if (status != TransportInterface::OK) {
            self = nil;
        }
    }    
    
    return self;
}

+ (id) skypeWithKeyData: (NSData*) data address:(NSString*) address port:(NSUInteger)port logFile:(NSString*) filename {
    return [[[SKSkype alloc] initWithKeyData:data address:address port:port logFile:filename] autorelease];
}

- (SkypeImp*) skype {
    return (SkypeImp*)self->_skype;
}

- (void) start {
    [self skype]->start();
}

- (void) stop {
    [self skype]->stop();
}

- (SKAccount*) accountForName: (NSString*) name{
    SKAccount* result = nil;
    
    AccountRef account;
    if (self.skype->GetAccount([name cStringUsingEncoding:NSUTF8StringEncoding], account)) {
        result = [SKObject resolve:account];
    }; 
    
    return result;
}

- (SKContact *)contactWithIdentity:(NSString *)identity {
    SKContact* result = nil;
    
    ContactRef contact;
    if (self.skype->GetContact([identity UTF8String], contact)) {
        result = [SKObject resolve:contact];
    }
    
    return result;
}

- (SKConversation*) conversationWithParticipants:(NSSet*) participants createIfNonExisting:(BOOL) create igonoreIfBookmarkedOrNamed:(BOOL) bookmarked {
    ConversationRef conversation;
    Sid::List_String participantsList;
    
    for (NSString* participant in participants) {
        participantsList.append([participant cStringUsingEncoding:NSUTF8StringEncoding]);
    }
    
    SKConversation* result = nil;
    
    if (self.skype->GetConversationByParticipants(participantsList, conversation, create, bookmarked)) {
        result = [SKObject resolve:conversation];
    } 

    return result;
}

- (SKConversation*) conversationWithIdentity:(NSString *)identity {
    ConversationRef conversation;
    SKConversation* result = nil;
    
    if (self.skype->GetConversationByIdentity([identity cStringUsingEncoding:NSUTF8StringEncoding], conversation)) {
        result = [SKObject resolve:conversation];
    } 
    
    return result;
}

- (SKContactGroup*) hardwiredContactGroup: (SKContactGroupType) type {
    SKContactGroup* result = nil;
    
    ContactGroup::TYPE groupType;
    
    switch (type) {
        case SKContactGroupTypeSkypeBuddies:
            groupType = ContactGroup::SKYPE_BUDDIES;
            break;
            
        default:
            break;
    }
    
    ContactGroupRef group;
    if (self.skype->GetHardwiredContactGroup(groupType, group)) {
        result = [SKObject resolve:group];
    }
    return result;
}

- (NSArray*) conversations {
    return [self conversationsWithListType:SKConversationListTypeAllConversations];
}

- (NSArray*) conversationsWithListType:(SKConversationListType) listType {
    ConversationRefs conversationRefs;
    NSMutableArray* result = nil;
    
    Conversation::LIST_TYPE type = [SKConversation encodeListType:listType];
    
    if (self.skype->GetConversationList(conversationRefs, type)) {
        NSUInteger size = conversationRefs.size();
        result = [NSMutableArray arrayWithCapacity:size];
        
        for (NSUInteger i=0; i<size; i++) {
            SKConversation* conversation = [SKConversation resolve:conversationRefs[i]];
            [result addObject:conversation];
        }
    }
    
    return result;
}

- (NSArray*) customContactGroups {
    ContactGroupRefs groupRefs;
    NSMutableArray* result = nil;
    
    if (self.skype->GetCustomContactGroups(groupRefs)) {
        NSUInteger size = groupRefs.size();
        result = [NSMutableArray arrayWithCapacity:size];
        
        for (NSUInteger i=0; i<size; i++) {
            SKContactGroup* group = [SKObject resolve:groupRefs[i]];
            [result addObject:group];
        }
    };

    return result;
}

- (SKContactGroup *)createCustomContactGroup {
    ContactGroupRef group;
    SKContactGroup* result = nil;
    
    if (self.skype->CreateCustomContactGroup(group)) {
        result = [SKObject resolve:group];
    }
    
    return result;
}

- (NSArray*) availableOutputDevices {
    Sid::List_String handleList;
    Sid::List_String nameList;
    Sid::List_String productIdList;
    
    NSMutableArray* result = nil;
    
    if (self.skype->GetAvailableOutputDevices(handleList, nameList, productIdList)) {
        NSUInteger size = handleList.size();
        
        result = [NSMutableArray arrayWithCapacity:size];
        for (NSUInteger i=0; i<size; i++) {
            [result addObject:[SKAudioDevice deviceWithHandle:[NSString stringWithCString:handleList[i] encoding:NSUTF8StringEncoding]
                                                         name:[NSString stringWithCString:nameList[i] encoding:NSUTF8StringEncoding]
                                                    productId:[NSString stringWithCString:productIdList[i] encoding:NSUTF8StringEncoding]]];
        }
    }
    
    return result;
}

- (NSArray*) availableRecordingDevices {
    Sid::List_String handleList;
    Sid::List_String nameList;
    Sid::List_String productIdList;
    
    NSMutableArray* result = nil;
    
    if (self.skype->GetAvailableRecordingDevices(handleList, nameList, productIdList)) {
        NSUInteger size = handleList.size();
        
        result = [NSMutableArray arrayWithCapacity:size];
        for (NSUInteger i=0; i<size; i++) {
            [result addObject:[SKAudioDevice deviceWithHandle:[NSString stringWithCString:handleList[i] encoding:NSUTF8StringEncoding]
                                                         name:[NSString stringWithCString:nameList[i] encoding:NSUTF8StringEncoding]
                                                    productId:[NSString stringWithCString:productIdList[i] encoding:NSUTF8StringEncoding]]];
        }
    }
    
    return result;
}

- (NSArray*) availableVideoDevices {
    Sid::List_String deviceNames;
    Sid::List_String devicePaths;
    uint count = 0;
    
    NSMutableArray* result = nil;
    
    if (self.skype->GetAvailableVideoDevices(deviceNames, devicePaths, count)) {        
        result = [NSMutableArray arrayWithCapacity:count];
        for (NSUInteger i=0; i<count; i++) {
            [result addObject:[SKVideoDevice deviceWithName:[NSString stringWithCString:deviceNames[i] encoding:NSUTF8StringEncoding]
                                                       path:[NSString stringWithCString:devicePaths[i] encoding:NSUTF8StringEncoding]]];
        }
    }
    
    return result;
}

- (void) loadISOMapping {
    Sid::List_String countryCodeList;
    Sid::List_String countryNameList;
    Sid::List_uint countryPrefixList;
    Sid::List_String countryDialExampleList;
    
    if (self.skype->GetISOCountryInfo(countryCodeList, countryNameList, countryPrefixList, countryDialExampleList)) {
        NSUInteger size = countryCodeList.size();
        
        NSMutableDictionary* theCountryNameMapping = [NSMutableDictionary dictionaryWithCapacity:size];
        NSMutableDictionary* theCountryPrefixMapping = [NSMutableDictionary dictionaryWithCapacity:size];
        NSMutableDictionary* theCountryDialExampleMapping = [NSMutableDictionary dictionaryWithCapacity:size];
        
        for (NSUInteger i=0; i<size; i++) {
            NSString* isoCode = [NSString stringWithUTF8String:countryCodeList[i]];
            [theCountryNameMapping setObject:[NSString stringWithUTF8String:countryNameList[i]] forKey:isoCode];
            [theCountryPrefixMapping setObject:[NSNumber numberWithUnsignedInteger:countryPrefixList[(unsigned int)i]] forKey:isoCode];
            [theCountryDialExampleMapping setObject:[NSString stringWithUTF8String:countryDialExampleList[i]] forKey:isoCode];
        }
        
        self->_countryNameMapping = [theCountryNameMapping retain];
        self->_countryPrefixMapping = [theCountryPrefixMapping retain];
        self->_countryDialExampleMapping = [theCountryDialExampleMapping retain];
    }
    
    Sid::List_String languageCodeList;
    Sid::List_String languageNameList;
    
    if (self.skype->GetISOLanguageInfo(languageCodeList, languageNameList)) {
        NSUInteger size = languageCodeList.size();
        
        NSMutableDictionary* theLanguageMapping = [NSMutableDictionary dictionaryWithCapacity:size];
        
        for (NSUInteger i=0; i<size; i++) {
            [theLanguageMapping setObject:[NSString stringWithUTF8String:languageNameList[i]] forKey:[NSString stringWithUTF8String:languageCodeList[i]]];
        }
        
        self->_languageMapping = [theLanguageMapping retain];
    }
}

- (NSDictionary *)countryDialExampleMapping {
    if (self->_countryDialExampleMapping == nil) {
        [self loadISOMapping];
    }
    
    return self->_countryDialExampleMapping;
}

- (NSDictionary *)countryNameMapping {
    if (self->_countryNameMapping == nil) {
        [self loadISOMapping];
    }
    
    return self->_countryNameMapping;
}

- (NSDictionary *)countryPrefixMapping {
    if (self->_countryPrefixMapping == nil) {
        [self loadISOMapping];
    }
    
    return self->_countryPrefixMapping;
}

- (NSDictionary *)languageMapping {
    if (self->_languageMapping == nil) {
        [self loadISOMapping];
    }
    
    return self->_languageMapping;
}

- (BOOL) selectCallInDevice:(SKAudioDevice*)inDevice callOutDevice:(SKAudioDevice*) outDevice waveDevice:(SKAudioDevice*) waveDevice {
    return self.skype->SelectSoundDevices([inDevice.handle UTF8String], [outDevice.handle UTF8String], [waveDevice.handle UTF8String]);
}

- (SKContactSearch*) basicContactSearch:(NSString*) searchTerm {
    ContactSearchRef contactSearch;
    SKContactSearch* result = nil;
    
    if (self.skype->CreateBasicContactSearch([searchTerm UTF8String], contactSearch)) {
        result = [SKObject resolve:contactSearch];
    }
    
    return result;
}

- (void) onMessage:(const Message::Ref&) message changesInboxTimestamp:(BOOL)changesInboxTimestamp 
                                              supersedesHistoryMessage:(const Message::Ref&) supersedesHistoryMessage 
                                                          conversation:(const Conversation::Ref&) conversation {
    @autoreleasepool {
        SKMessage* aMessage = [SKObject resolve:message];
        SKConversation* aConversation = [SKObject resolve:conversation];
        
        [self.delegate conversation:aConversation didReceiveMessage:aMessage changesTimestamp:changesInboxTimestamp];
    }
}

- (void)onConversationListChange:(const ConversationRef &)conversation type:(const Conversation::LIST_TYPE &)type added:(const bool &)added {
    @autoreleasepool {
        SKConversation* aConversation = [SKObject resolve:conversation];
        [self.delegate listChangedWithConversation:aConversation type:[SKConversation decodeListType:type] added:added];
    }
}

- (void)dealloc {
    [self->_countryPrefixMapping release];
    [self->_countryDialExampleMapping release];
    [self->_countryNameMapping release];
    [self->_languageMapping release];
    
    delete self->_keyBuffer;
    delete self.skype;
    
    [super dealloc];
}

@end
