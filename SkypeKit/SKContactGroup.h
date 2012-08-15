/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKObject.h"

@class ContactGroupBinding;
@class NSArray;
@class SKContact;

typedef enum {
    SKContactGroupTypeAllKnownContacts,
    SKContactGroupTypeSkypeBuddies
} SKContactGroupType;

@interface SKContactGroup : SKObject {
    NSString* _displayName;
    NSString* _customGroupId;
}

@property (nonatomic, readwrite, copy) NSString* displayName;
@property (nonatomic, readonly) NSString* customGroupId;

- (NSArray*) contacts;
- (BOOL) removeContact:(SKContact*) contact;
- (BOOL) addContact:(SKContact*) contact;

@end
