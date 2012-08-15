/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKObject.h"

@class MessageBinding;
@class SKContact;
@class NSArray;

typedef enum {
    SKMessageTypeSetMetadata,
    SKMessageTypeSpawendConference,
    SKMessageTypeAddedConsumers,
    SKMessageTypeAddedApplicants,
    SKMessageTypeRetiredOthers,
    SKMessageTypeRetired,
    SKMessageTypeSetRank,
    SKMessageTypeStartedLiveSession,
    SKMessageTypeEndedLiveSession,
    SKMessageTypeRequestedAuthorization,
    SKMessageTypeGrantedAuthorization,
    SKMessageTypePostedText,
    SKMessageTypePostedEmote,
    SKMessageTypePostedContacts,
    SKMessageTypePostedSMS,
    SKMessageTypePostedAlert,   //Deprecated
    SKMessageTypePostedVoiceMessage,
    SKMessageTypePostedFiles,
    SKMessageTypePostedInvoice,
    SKMessageTypeHasBirthday
} SKMessageType; 

@interface SKMessage : SKObject {
    NSString* _body;
    NSString* _author;
    NSString* _authorDisplayName;
    SKMessageType _type;
}

@property (nonatomic, readonly) NSString* body;
@property (nonatomic, readonly) NSString* author;
@property (nonatomic, readonly) NSString* authorDisplayName;
@property (nonatomic, readonly) SKMessageType type;

- (NSArray*) transfers;


@end
