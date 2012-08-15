/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKContactGroup.h"

#import "ContactGroupBinding.hpp"
#import "ContactBinding.hpp"

#import "SKContact.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>

#import <skype-embedded_2.h>

@interface SKContactGroup (Private)

- (NSString*) coreDisplayName;
- (BOOL) setCoreDisplayName:(NSString*) aDisplayName;

- (NSString*) coreCustomGroupId;

@property (nonatomic, copy, readwrite) NSString* displayName;
@property (nonatomic, copy, readwrite) NSString* customGroupId;

@end

@implementation SKContactGroup

- (NSArray*) contacts {
    
    ContactRefs contactList;
    self.coreContactGroup->GetContacts(contactList);
    
    NSUInteger size = contactList.size();
    
    NSMutableArray* contacts = [NSMutableArray arrayWithCapacity:size]; 
    
    for (NSUInteger i=0; i<size; i++) {
        SKContact* contact = [SKObject resolve:contactList[i]->ref()];
        [contacts addObject:contact];
    }
    
    return contacts;
}

- (BOOL) setCoreDisplayName:(NSString *) aDisplayName {
    return self.coreContactGroup->GiveDisplayName([aDisplayName cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (NSString*) coreDisplayName {
    Sid::String name;
    NSString* result = nil;
    
    if (self.coreContactGroup->GetPropGivenDisplayname(name)) {
        [self markPropertyAsCached:@"displayName"];
        result = [NSString stringWithUTF8String:name];
    }
        
    return result;
}

- (NSString *) coreCustomGroupId {
    uint uid;
    NSString* result = nil;
    
    if (self.coreContactGroup->GetPropCustomGroupId(uid)) {
        [self markPropertyAsCached:@"customGroupId"];
        result = [NSString stringWithFormat:@"%d", uid];
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
    /** - ensure that right value is cached*/
    if (![self isPropertyCached:@"displayName"]) {
        [self->_displayName release];
        self->_displayName = [[self coreDisplayName] copy];
    }
    
    if (self->_displayName != aDisplayName) {
        /** - set displayName at Skype runtime*/
        if ([self setCoreDisplayName:aDisplayName]) {
            /** - if that was successful, we also change the cached value*/
            [self->_displayName release];
            self->_displayName = [aDisplayName copy];
        }
        
    }
}

- (NSString *) customGroupId {
    if (![self isPropertyCached:@"customGroupId"]) {
        [self->_customGroupId release];
        self->_customGroupId = [[self coreCustomGroupId] copy];
    }
    return self->_customGroupId;
}

- (void)setCustomGroupId:(NSString *) aCustomGroupId {
    if (self->_customGroupId != aCustomGroupId) {
        [self->_customGroupId release];
        self->_customGroupId = [aCustomGroupId copy];
    }
}

- (BOOL) removeContact:(SKContact*) contact {
    return self.coreContactGroup->RemoveContact(contact.coreContact->ref());
}

- (BOOL) addContact:(SKContact*) contact {
    return self.coreContactGroup->AddContact(contact.coreContact->ref());
}

- (void)onChange:(int) prop {
    switch (prop) {
        case ContactGroup::P_CUSTOM_GROUP_ID:
            self.customGroupId = [self coreCustomGroupId];
            break;
            
        case ContactGroup::P_GIVEN_DISPLAYNAME:
            self.displayName = [self coreDisplayName];
        default:
            break;
    }
}

- (void)dealloc {
    [self->_displayName release];
    [self->_customGroupId release];
    
    [super dealloc];
}

@end
