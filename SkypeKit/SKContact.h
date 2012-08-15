/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKObject.h"

@class SKContact;
@class SKContactGroup;
@class NSImage;
@class NSDate;
@class NSData;
@class NSArray;

typedef enum {
    SKContactAvailabilityUnknown,
    SKContactAvailabilityPendingAuthentication,
    SKContactAvailabilityBlocked,
    SKContactAvailabilityBlockedSkypeOut,
    SKContactAvailabilitySkypeOut,
    SKContactAvailabilityOffline,
    SKContactAvailabilityOfflineVoiceMail,
    SKContactAvailabilityOfflineCallForwarding,
    SKContactAvailabilityOnline,
    SKContactAvailabilityAway,
    SKContactAvailabilityNotAvailable,
    SKContactAvailabilityDoNotDisturb,
    SKContactAvailabilitySkypeMe,
    SKContactAvailabilityInvisible,
    SKContactAvailabilityConnecting,
    SKContactAvailabilityOnlineFromMobile,
    SKContactAvailabilityAwayFromMobile,
    SKContactAvailabilityNotAvailableFromMobile,
    SKContactAvailabilityDoNotDisturbFromMobile,
    SKContactAvailabilitySkypeMeFromMobile
} SKContactAvailability;

typedef enum {
    SKContactGenderUnknown,
    SKContactGenderMale,
    SKContactGenderFemale
} SKContactGender;

@protocol SKContactDelegate <NSObject>

- (void) contact:(SKContact*) contact didChangeAvailability:(SKContactAvailability) availability;

@end

@interface SKContact : SKObject {
    id<SKContactDelegate> _delegate;
    NSString* _fullName;
    NSDate* _birthday;
    SKContactGender _gender;
    NSString* _country;
    NSString* _province;
    NSString* _city;
    NSString* _phoneHome;
    NSString* _phoneOffice;
    NSString* _phoneMobile;
    NSArray* _emails;
    NSString* _homepage;
    NSString* _about;
    
    SKContactAvailability _availability;
    NSString* _displayName;
    NSString* _skypeName;
    NSString* _moodText;
    NSData* _avatarData;
}

- (BOOL) isMemberOfGroup:(SKContactGroup*) group;

@property (nonatomic, assign) id<SKContactDelegate> delegate;

@property (nonatomic, readonly) NSString* fullName;
@property (nonatomic, readonly) NSDate* birthday;
@property (nonatomic, readonly) SKContactGender gender;
@property (nonatomic, readonly) NSString* country;
@property (nonatomic, readonly) NSString* province;
@property (nonatomic, readonly) NSString* city;
@property (nonatomic, readonly) NSString* phoneHome;
@property (nonatomic, readonly) NSString* phoneOffice;
@property (nonatomic, readonly) NSString* phoneMobile;
@property (nonatomic, readonly) NSString* emails;
@property (nonatomic, readonly) NSString* homepage;
@property (nonatomic, readonly) NSString* about;

@property (nonatomic, readonly) NSString* displayName;
@property (nonatomic, readonly) NSString* skypeName;
@property (nonatomic, readonly) NSImage* avatarImage;
@property (nonatomic, readonly) NSData* avatarData;
@property (nonatomic, readonly) SKContactAvailability availability;
@property (nonatomic, readonly) NSString* moodText;

@end
