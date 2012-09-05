/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKContact.h"

#import <Foundation/Foundation.h>

#import <AppKit/NSImage.h>

#import "ContactBinding.hpp"
#import "ContactGroupBinding.hpp"

@interface SKContact (Private)

- (NSString*) coreFullName;
- (NSDate*) coreBirthday;
- (SKContactGender) coreGender;
- (SKContactAvailability) coreAvailability;
- (NSString*) coreCountry;
- (NSString*) coreProvince;
- (NSString*) coreCity;
- (NSString*) corePhoneHome;
- (NSString*) corePhoneOffice;
- (NSString*) corePhoneMobile;
- (NSArray*) coreEmails;
- (NSString*) coreHomepage;
- (NSString*) coreAbout;
- (NSString*) coreDisplayName;
- (NSString*) coreSkypeName;
- (NSData*) coreAvatarData;
- (NSString*) coreReceivedAuthRequest;

@property (nonatomic, copy, readwrite) NSString* fullName;
@property (nonatomic, copy, readwrite) NSDate* birthday;
@property (nonatomic, assign, readwrite) SKContactGender gender;
@property (nonatomic, assign, readwrite) SKContactAvailability availability;
@property (nonatomic, copy, readwrite) NSString* country;
@property (nonatomic, copy, readwrite) NSString* province;
@property (nonatomic, copy, readwrite) NSString* city;
@property (nonatomic, copy, readwrite) NSString* phoneHome;
@property (nonatomic, copy, readwrite) NSString* phoneOffice;
@property (nonatomic, copy, readwrite) NSString* phoneMobile;
@property (nonatomic, retain, readwrite) NSArray* emails;
@property (nonatomic, copy, readwrite) NSString* homepage;
@property (nonatomic, copy, readwrite) NSString* about;
@property (nonatomic, copy, readwrite) NSString* displayName;
@property (nonatomic, copy, readwrite) NSString* skypeName;
@property (nonatomic, retain, readwrite) NSData* avatarData;
@property (nonatomic, copy, readwrite) NSString* receivedAuthRequest;

@end

@implementation SKContact

@synthesize delegate = _delegate;

- (NSString*) coreDisplayName {
    Sid::String name;
    NSString* result = nil;
    
    if (self.coreContact->GetPropDisplayname(name)) {
        [self markPropertyAsCached:@"displayName"];
        result = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSString*) coreSkypeName {
    Sid::String name;
    NSString* result = nil;
    
    if (self.coreContact->GetPropSkypename(name)) {
        [self markPropertyAsCached:@"sykpeName"];
        result = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSData*) coreAvatarData {
    Sid::Binary image;
    NSData* result = nil;
    
    if (self.coreContact->GetPropAvatarImage(image)) {
        [self markPropertyAsCached:@"avatarData"];
        result = [NSData dataWithBytes:image.data() length:image.size()];
    }
    
    return result;
}

- (NSImage*) avatarImage {
    return [[[NSImage alloc] initWithData:[self avatarData]] autorelease];
}

- (SKContactAvailability) coreAvailability {
    SKContactAvailability result = SKContactAvailabilityUnknown;
    
    Contact::AVAILABILITY status;
    if (self.coreContact->GetPropAvailability(status)) {
        [self markPropertyAsCached:@"availability"];
        result = [SKContact decodeAvailability:status];
    }
    
    return result;
}

- (NSString *) coreMoodText {
    Sid::String text;
    NSString* mood = nil;
    
    if (self.coreContact->GetPropMoodText(text)) {
        [self markPropertyAsCached:@"moodText"];
        mood = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return mood;
}

- (NSString*) coreFullName {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreContact->GetPropFullname(text)) {
        [self markPropertyAsCached:@"fullName"];
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSString*) coreCountry {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreContact->GetPropCountry(text)) {
        [self markPropertyAsCached:@"country"];
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSString*) coreProvince {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreContact->GetPropProvince(text)) {
        [self markPropertyAsCached:@"province"];
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSString*) coreCity {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreContact->GetPropCity(text)) {
        [self markPropertyAsCached:@"city"];
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSString*) corePhoneHome {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreContact->GetPropPhoneHome(text)) {
        [self markPropertyAsCached:@"phoneHome"];
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSString*) corePhoneOffice {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreContact->GetPropPhoneOffice(text)) {
        [self markPropertyAsCached:@"phoneOffice"];
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSString*) corePhoneMobile {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreContact->GetPropPhoneMobile(text)) {
        [self markPropertyAsCached:@"phoneMobile"];
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSString*) coreAbout {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreContact->GetPropAbout(text)) {
        [self markPropertyAsCached:@"about"];
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSString*) coreHomepage {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreContact->GetPropHomepage(text)) {
        [self markPropertyAsCached:@"homepage"];
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSArray*) coreEmails {
    Sid::String text;
    NSArray* result = nil;
    
    if (self.coreContact->GetPropEmails(text)) {
        [self markPropertyAsCached:@"emails"];
        result = [[NSString stringWithCString:text encoding:NSUTF8StringEncoding] componentsSeparatedByString:@" "];
    }
    
    return result;
}

- (SKContactGender) coreGender {
    uint theGender;
    SKContactGender result = SKContactGenderUnknown;
    
    if (self.coreContact->GetPropGender(theGender)) {
        [self markPropertyAsCached:@"gender"];
        switch (theGender) {
            case 1:
                result = SKContactGenderMale;
                break;
                
            case 2:
                result = SKContactGenderFemale;
                break;
                
            default:
                break;
        }
    }
    
    return result;
}

- (NSDate *) coreBirthday {
    uint aBirthday;
    NSDate* result = nil;
    
    if (self.coreContact->GetPropBirthday(aBirthday)) {
        [self markPropertyAsCached:@"birthday"];
        NSDateComponents* components = [[NSDateComponents alloc] init];
        [components setYear:(aBirthday / 10000)];
        [components setMonth:((aBirthday % 100000) / 100)];
        [components setDay:(aBirthday % 100)];
        
        result = [[NSCalendar currentCalendar] dateFromComponents:components];
        [components release];
    }
    
    return result;
}

- (NSString *)coreReceivedAuthRequest {
    Sid::String receivedAuthRequest;
    NSString* result = nil;
    
    if (self.coreContact->GetPropReceivedAuthrequest(receivedAuthRequest)) {
        [self markPropertyAsCached:@"receivedAuthRequest"];
        [NSString stringWithCString:receivedAuthRequest encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (SKContactAvailability)availability {
    if (![self isPropertyCached:@"availability"]) {
        self->_availability = [self coreAvailability];
    }
    
    return self->_availability;
}

- (void)setAvailability:(SKContactAvailability) aAvailability {
    if (self->_availability != aAvailability) {
        self->_availability = aAvailability;
    }
}

- (NSString *) fullName {
    if (![self isPropertyCached:@"fullName"]) {
        [self->_fullName release];
        self->_fullName = [[self coreFullName] copy];
    }
    
    return self->_fullName;
}

- (void) setFullName:(NSString *)aFullName {
    if (self->_fullName != aFullName) {
        [self->_fullName release];
        self->_fullName = [aFullName copy];
    }
}

- (NSString *) country {
    if (![self isPropertyCached:@"country"]) {
        [self->_country release];
        self->_country = [[self coreCountry] copy];
    }
    
    return self->_country;
}

- (void)setCountry:(NSString *) aCountry {
    if (self->_country != aCountry) {
        [self->_country release];
        self->_country = [aCountry copy];
    }
}

- (NSDate*) birthday {
    if (![self isPropertyCached:@"birthday"]) {
        [self->_birthday release];
        self->_birthday = [[self coreBirthday] copy];
    }
    
    return self->_birthday;
}

- (void)setBirthday:(NSDate *) aBirthday {
    if (self->_birthday != aBirthday) {
        [self->_birthday release];
        self->_birthday = [aBirthday copy];
    }
}

- (NSString *)province {
    if (![self isPropertyCached:@"province"]) {
        [self->_province release];
        self->_province = [[self coreProvince] copy];
    }
    
    return self->_province;
}

- (void)setProvince:(NSString *) aProvince {
    if (self->_province != aProvince) {
        [self->_province release];
        self->_province = [aProvince copy];
    }
}

- (SKContactGender) gender {
    if (![self isPropertyCached:@"gender"]) {
        self->_gender = [self coreGender];
    }
    return self->_gender;
}

- (void)setGender:(SKContactGender) aGender {
    if (self->_gender != aGender) {
        self->_gender = aGender;
    }
}

- (NSString*) city {
    if (![self isPropertyCached:@"city"]) {
        [self->_city release];
        self->_city = [[self coreCity] copy];
    }
    
    return self->_city;
}

- (void)setCity:(NSString *) aCity {
    if (self->_city != aCity) {
        [self->_city release];
        self->_city = [aCity copy];
    }
}

- (NSString *) phoneHome {
    if (![self isPropertyCached:@"phoneHome"]) {
        [self->_phoneHome release];
        self->_phoneHome = [[self corePhoneHome] copy];
    }
    
    return self->_phoneHome;
}

- (void)setPhoneHome:(NSString *) aPhoneHome {
    if (self->_phoneHome != aPhoneHome) {
        [self->_phoneHome release];
        self->_phoneHome = [aPhoneHome copy];
    }
}

- (NSString *) phoneOffice {
    if (![self isPropertyCached:@"phoneOffice"]) {
        [self->_phoneOffice release];
        self->_phoneOffice = [[self corePhoneOffice] copy];
    }
    
    return self->_phoneOffice;
}

- (void)setPhoneOffice:(NSString *) aPhoneOffice {
    if (self->_phoneOffice != aPhoneOffice) {
        [self->_phoneOffice release];
        self->_phoneOffice = [aPhoneOffice copy];
    }
}

- (NSString *) phoneMobile {
    if (![self isPropertyCached:@"phoneMobile"]) {
        [self->_phoneMobile release];
        self->_phoneMobile = [[self corePhoneMobile] copy];
    }
    
    return self->_phoneMobile;
}

- (void)setPhoneMobile:(NSString *) aPhoneMobile {
    if (self->_phoneMobile != aPhoneMobile) {
        [self->_phoneMobile release];
        self->_phoneMobile = [aPhoneMobile copy];
    }
}

- (NSArray *) emails {
    if (![self isPropertyCached:@"emails"]) {
        [self->_emails release];
        self->_emails = [[self coreEmails] copy];
    }
    
    return self->_emails;
}

- (void)setEmails:(NSArray *) aEmails {
    if (self->_emails != aEmails) {
        [self->_emails release];
        self->_emails = [aEmails copy];
    }
}

- (NSString *) homepage {
    if (![self isPropertyCached:@"homepage"]) {
        [self->_homepage release];
        self->_homepage = [[self coreHomepage] copy];
    }
    
    return self->_homepage;
}

- (void)setHomepage:(NSString *) aHomepage {
    if (self->_homepage != aHomepage) {
        [self->_homepage release];
        self->_homepage = [aHomepage copy];
    }
}

- (NSString *) about {
    if (![self isPropertyCached:@"about"]) {
        [self->_about release];
        self->_about = [[self coreAbout] copy];
    }
    
    return self->_about;
}

- (void)setAbout:(NSString *) aAbout {
    if (self->_about != aAbout) {
        [self->_about release];
        self->_about = [aAbout copy];
    }
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

- (NSString *)skypeName {
    if (![self isPropertyCached:@"skypeName"]) {
        [self->_skypeName release];
        self->_skypeName = [[self coreSkypeName] copy];
    }
    
    return self->_skypeName;
}

- (void)setSkypeName:(NSString *)aSkypeName {
    if (self->_skypeName != aSkypeName) {
        [self->_skypeName release];
        self->_skypeName = [aSkypeName copy];
    }
}

- (NSData *)avatarData {
    if (![self isPropertyCached:@"avatarData"]) {
        [self->_avatarData release];
        self->_avatarData = [[self coreAvatarData] retain];
    }
    
    return self->_avatarData;
}

- (void)setAvatarData:(NSData *) aAvatarData {
    if (self->_avatarData != aAvatarData) {
        [self->_avatarData release];
        self->_avatarData = [aAvatarData retain];
    }
}

- (NSString *)moodText {
    if (![self isPropertyCached:@"moodText"]) {
        [self->_moodText release];
        self->_moodText = [[self coreMoodText] copy];
    }
    
    return self->_moodText;
}

- (void)setMoodText:(NSString *) aMoodText {
    if (self->_moodText != aMoodText) {
        [self->_moodText release];
        self->_moodText = [aMoodText retain];
    }
}

- (BOOL) isMemberOfGroup:(SKContactGroup*) group {
    BOOL result = NO;
    bool member;
    if (self.coreContact->IsMemberOf(group.coreContactGroup->ref(), member)) {
        if (member) {
            result = YES;
        }
    }
    
    return result;
}

- (void)onChange:(int)prop {
    switch (prop) {
        case Contact::P_AVAILABILITY: {
            SKContactAvailability availability = [self coreAvailability];
            self.availability = availability;
            
            [self.delegate contact:self didChangeAvailability:availability];
            break;
        }
            
        case Contact::P_COUNTRY: {
            self.country = [self coreCountry];
            break;
        }
            
        case Contact::P_PROVINCE: {
            self.province = [self coreProvince];
            break;
        }
            
        case Contact::P_CITY: {
            self.city = [self coreCity];
            break;
        }
            
        case Contact::P_PHONE_HOME: {
            self.phoneHome = [self corePhoneHome];
            break;
        }
            
        case Contact::P_PHONE_OFFICE: {
            self.phoneOffice = [self corePhoneOffice];
            break;
        }
            
        case Contact::P_PHONE_MOBILE: {
            self.phoneMobile = [self corePhoneMobile];
            break;
        }
            
        case Contact::P_EMAILS: {
            self.emails = [self coreEmails];
            break;
        }
            
        case Contact::P_HOMEPAGE: {
            self.homepage = [self coreHomepage];
            break;
        }
            
        case Contact::P_ABOUT: {
            self.about = [self coreAbout];
            break;
        }
            
        case Contact::P_FULLNAME: {
            self.fullName = [self coreFullName];
            break;
        }
            
        case Contact::P_GENDER: {
            self.gender = [self coreGender];
            break;
        }
            
        case Contact::P_BIRTHDAY: {
            self.birthday = [self coreBirthday];
            break;
        }
            
        case Contact::P_AVATAR_IMAGE: {
            self.avatarData = [self avatarData];
            break;
        }
            
        default:
            break;
    }
}

- (NSString *)receivedAuthRequest {
    if (![self isPropertyCached:@"receivedAuthRequest"]) {
        [self->_receivedAuthRequest release];
        self->_receivedAuthRequest = [[self coreReceivedAuthRequest] copy];
    }
    
    return self->_receivedAuthRequest;
}

- (void)setReceivedAuthRequest:(NSString *)receivedAuthRequest {
    if (self->_receivedAuthRequest != receivedAuthRequest) {
        [self->_receivedAuthRequest release];
        self->_receivedAuthRequest = [receivedAuthRequest copy];
    }
}

- (void)dealloc {
    [self->_fullName release];
    [self->_birthday release];
    [self->_country release];
    [self->_province release];
    [self->_city release];
    [self->_phoneHome release];
    [self->_phoneOffice release];
    [self->_phoneMobile release];
    [self->_emails release];
    [self->_homepage release];
    [self->_about release];
    [self->_displayName release];
    [self->_skypeName release];
    [self->_moodText release];
    [self->_avatarData release];
    
    [super dealloc];
}

@end
