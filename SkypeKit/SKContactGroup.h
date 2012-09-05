/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKObject.h"

@class ContactGroupBinding;
@class NSArray;
@class SKContact;
@class SKContactGroup;

typedef enum {
    SKContactGroupTypeUndefined,
    SKContactGroupTypeAllKnownContacts,
    SKContactGroupTypeAllBuddies,
    SKContactGroupTypeSkypeBuddies,
    SKContactGroupTypeSkypeOutBuddies,
    SKContactGroupTypeOnlineBuddies,
    SKContactGroupTypeUnknownOrPendingAuthBuddies,
    SKContactGroupTypeRecentlyContactedContacts,
    SKContactGroupTypeContactsWaitingMyAuthorization,
    SKContactGroupTypeContactsAuthorizedByMe,
    SKContactGroupTypeContactsBlockedByMe,
    SKContactGroupTypeUngroupedBuddies,
    SKContactGroupTypeCustomGroup,
    SKContactGroupTypeProposedSharedGroup,
    SKContactGroupTypeSharedGroup,
    SKContactGroupTypeExternalContacts
} SKContactGroupType;

@protocol SKContactGroupDelegate <NSObject>

- (void) contactGroup:(SKContactGroup*) contactGroup didAddContact:(SKContact*) contact;

@end

@interface SKContactGroup : SKObject {
    NSString* _displayName;
    NSString* _customGroupId;
    SKContactGroupType _type;
    
    id<SKContactGroupDelegate> _delegate;
}

@property (nonatomic, readwrite, copy) NSString* displayName;
@property (nonatomic, readonly) NSString* customGroupId;
@property (nonatomic, readonly) SKContactGroupType type;
@property (nonatomic, readwrite, assign) id<SKContactGroupDelegate> delegate;

- (NSArray*) contacts;
- (BOOL) removeContact:(SKContact*) contact;
- (BOOL) addContact:(SKContact*) contact;

@end
