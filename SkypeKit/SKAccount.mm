/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKAccount.h"

#import "AccountBinding.hpp"
#import "ContactBinding.hpp"

#import <Foundation/NSString.h>
#import <Foundation/NSCalendar.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSData.h>

@interface SKAccount (Private)

- (NSString*) coreSkypeName;
- (NSData*) coreAvatarData;
- (SKContactAvailability) coreAvailability;
- (NSString*) coreMoodText;
- (NSString*) coreFullName;
- (NSDate*) coreBirthday;
- (SKContactGender) coreGender;
- (NSString*) coreCountry;
- (NSArray*) coreLanguages;
- (NSString*) coreProvince;
- (NSString*) coreCity;
- (NSString*) corePhoneHome;
- (NSString*) corePhoneOffice;
- (NSString*) corePhoneMobile;
- (NSArray*) coreEmails;
- (NSString*) coreHomepage;
- (NSString*) coreAbout;

- (void) setCoreAvatarData:(NSData*) avatarData;
- (void) setCoreAvailability:(SKContactAvailability) availability;
- (void) setCoreMoodText:(NSString*) moodText;
- (void) setCoreFullName:(NSString*) fullName;
- (void) setCoreBirthday:(NSDate*) birthday;
- (void) setCoreGender:(SKContactGender) gender;
- (void) setCoreCountry:(NSString*) country;
- (void) setCoreLanguages:(NSArray*) languages;
- (void) setCoreProvince:(NSString*) provinces;
- (void) setCoreCity:(NSString*) city;
- (void) setCorePhoneHome:(NSString*) phoneHome;
- (void) setCorePhoneOffice:(NSString*) phoneOffice;
- (void) setCorePhoneMobile:(NSString*) phoneMobile;
- (void) setCoreEmails:(NSArray*) emails;
- (void) setCoreHomepage:(NSString*) hompage;
- (void) setCoreAbout:(NSString*) about;

@end

@implementation SKAccount

@synthesize delegate = _delegate;

- (BOOL) loginWithPassword: (NSString*) password savePassword:(BOOL) savePassword saveData:(BOOL) saveData {
    return self.coreAccount->LoginWithPassword([password UTF8String], savePassword, saveData);
}

- (BOOL) logout {
    return self.coreAccount->Logout();
}

- (void)onChange:(int)prop {
    @autoreleasepool {
        if (prop == Account::P_STATUS) {
            SKAccountLoginStatus status = SKAccountLoginStatusUndefined;
            
            Account::STATUS LoginStatus;
            self.coreAccount->GetPropStatus(LoginStatus);
            
            if (LoginStatus == Account::LOGGED_IN) {
                status = SKAccountLoginStatusLoggedIn;
            }
            else if (LoginStatus == Account::LOGGED_OUT) {
                status = SKAccountLoginStatusLoggedOut;
            };
            
            [self.delegate account:self didChangeLoginStatus:status];
        };
    }
}

/* core properties*/
- (NSString*) coreSkypeName {
    Sid::String name;
    NSString* result = nil;
    
    if (self.coreAccount->GetPropSkypename(name)) {
        result = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSData*) coreAvatarData {
    Sid::Binary image;
    NSData* result = nil;
    
    if (self.coreAccount->GetPropAvatarImage(image)) {
        result = [NSData dataWithBytes:image.data() length:image.size()];
    }
    
    return result;
}

- (void)setCoreAvatarData:(NSData *)avatarData {
    Sid::Binary image;
    image.set([avatarData bytes], (unsigned int)[avatarData length]);
    
    self.coreAccount->SetBinProperty(Account::P_AVATAR_IMAGE, image);
}

- (SKContactAvailability) coreAvailability {
    SKContactAvailability result = SKContactAvailabilityUnknown;
    Contact::AVAILABILITY availability;
    
    if (self.coreAccount->GetPropAvailability(availability)) {
        result = [SKContact decodeAvailability:availability];
    }
    
    return result;
}

- (void)setCoreAvailability:(SKContactAvailability)availability {
    self.coreAccount->SetAvailability([SKContact encodeAvailability:availability]);
}

- (NSString*) coreMoodText {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreAccount->GetPropMoodText(text)) {
        result = [NSString stringWithUTF8String:text];
    }
        
    return result;
}

- (void)setCoreMoodText:(NSString *)moodText {
    self.coreAccount->SetStrProperty(Account::P_MOOD_TEXT, [moodText cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (NSString*) coreFullName {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreAccount->GetPropFullname(text)) {
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (void)setCoreFullName:(NSString *)fullName {
    self.coreAccount->SetStrProperty(Account::P_FULLNAME, [fullName cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (NSString*) coreCountry {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreAccount->GetPropCountry(text)) {
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (void)setCoreCountry:(NSString *)country {
    self.coreAccount->SetStrProperty(Account::P_COUNTRY,[country UTF8String]);
}

- (NSArray*) coreLanguages {
    Sid::String text;
    NSArray* result = nil;
    
    if (self.coreAccount->GetPropLanguages(text)) {
        result = [[NSString stringWithCString:text encoding:NSUTF8StringEncoding] componentsSeparatedByString:@" "];
    }
    
    return result;
}

- (void)setCoreLanguages:(NSArray *)languages {
    NSMutableString* languagesString = nil;
    
    if ([languages count] > 0) {
        languagesString = [[languages objectAtIndex:0] mutableCopy];
        
        for (NSUInteger i=1; i<languages.count; i++) {
            [languagesString appendFormat:@" %@", [languages objectAtIndex:i]];
        }
    }
    else {
        languagesString = [NSMutableString string];
    }
    
    self.coreAccount->SetStrProperty(Account::P_LANGUAGES,[languagesString UTF8String]);
}

- (NSString*) coreProvince {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreAccount->GetPropProvince(text)) {
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (void)setCoreProvince:(NSString *)province {
    self.coreAccount->SetStrProperty(Account::P_PROVINCE,[province UTF8String]);
}

- (NSString*) coreCity {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreAccount->GetPropCity(text)) {
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (void)setCoreCity:(NSString *)city {
    self.coreAccount->SetStrProperty(Account::P_CITY,[city UTF8String]);
}

- (NSString*) corePhoneHome {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreAccount->GetPropPhoneHome(text)) {
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (void)setCorePhoneHome:(NSString *)phoneHome {
    self.coreAccount->SetStrProperty(Account::P_PHONE_HOME,[phoneHome UTF8String]);
}

- (NSString*) corePhoneOffice {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreAccount->GetPropPhoneOffice(text)) {
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (void)setCorePhoneOffice:(NSString *)phoneOffice {
    self.coreAccount->SetStrProperty(Account::P_PHONE_OFFICE,[phoneOffice UTF8String]);
}

- (NSString*) corePhoneMobile {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreAccount->GetPropPhoneMobile(text)) {
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (void)setCorePhoneMobile:(NSString *)phoneMobile {
    self.coreAccount->SetStrProperty(Account::P_PHONE_MOBILE,[phoneMobile UTF8String]);
}

- (NSString*) coreAbout {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreAccount->GetPropAbout(text)) {
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (void)setCoreAbout:(NSString *)about {
    self.coreAccount->SetStrProperty(Account::P_ABOUT,[about UTF8String]);
}

- (NSString*) coreHomepage {
    Sid::String text;
    NSString* result = nil;
    
    if (self.coreAccount->GetPropHomepage(text)) {
        result = [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (void)setCoreHomepage:(NSString *)homepage {
    self.coreAccount->SetStrProperty(Account::P_HOMEPAGE,[homepage UTF8String]);
}

- (NSArray*) coreEmails {
    Sid::String text;
    NSArray* result = nil;
    
    if (self.coreAccount->GetPropEmails(text)) {
        result = [[NSString stringWithCString:text encoding:NSUTF8StringEncoding] componentsSeparatedByString:@" "];
    }
    
    return result;
}

- (void)setCoreEmails:(NSArray *)emails {
    NSMutableString* emailString = nil;
    
    if ([emails count] > 0) {
        emailString = [[emails objectAtIndex:0] mutableCopy];
        
        for (NSUInteger i=1; i<emails.count; i++) {
            [emailString appendFormat:@" %@", [emails objectAtIndex:i]];
        }
    }
    else {
        emailString = [NSMutableString string];
    }
    
    self.coreAccount->SetStrProperty(Account::P_EMAILS,[emailString UTF8String]);
}

- (SKContactGender) coreGender {
    uint gender;
    SKContactGender result = SKContactGenderUnknown;
    
    if (self.coreAccount->GetPropGender(gender)) {
        switch (gender) {
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

- (void)setCoreGender:(SKContactGender)gender {
    int genderIndex = 0;
    
    if (gender == SKContactGenderMale) {
        genderIndex = 1;
    }
    else if (gender == SKContactGenderFemale) {
        genderIndex = 2;
    }
    
    self.coreAccount->SetIntProperty(Account::P_GENDER, genderIndex);
}

- (NSDate *) coreBirthday {
    uint birthday;
    NSDate* result = nil;
    
    if (self.coreAccount->GetPropBirthday(birthday)) {
        NSDateComponents* components = [[NSDateComponents alloc] init];
        [components setYear:(birthday / 10000)];
        [components setMonth:((birthday % 100000) / 100)];
        [components setDay:(birthday % 100)];
        
        result = [[NSCalendar currentCalendar] dateFromComponents:components];
        [components release];
    }
    
    return result;
}

- (void)setCoreBirthday:(NSDate *)birthday {
    NSDateComponents* components = [[NSCalendar currentCalendar] components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:birthday];
    NSUInteger birthdayNumber = [components day];
    birthdayNumber += 100 * [components month];
    birthdayNumber += 10000 * [components year];
    
    self.coreAccount->SetIntProperty(Account::P_BIRTHDAY, (unsigned int)birthdayNumber);
}

/*property methods*/
- (NSString*) skypeName {
    if (![self isPropertyCached:@"skypeName"]) {
        [self->_skypeName release];
        self->_skypeName = [[self coreSkypeName] copy];
        [self markPropertyAsCached:@"skypeName"];
    }
    
    return self->_skypeName;
}

- (NSData*) avatarData {
    if (![self isPropertyCached:@"avatarData"]) {
        [self->_avatarData release];
        self->_avatarData = [[self coreAvatarData] retain];
        [self markPropertyAsCached:@"avatarData"];
    }
    
    return self->_avatarData;
}

- (void)setAvatarData:(NSData *)avatarData {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"avatarData"]) {
        if (avatarData != self->_avatarData) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"avatarData"];
        replace = YES;
    }
    
    if (replace) {
        self.coreAvatarData = avatarData;
        [self->_avatarData release];
        self->_avatarData = [avatarData retain];
    }
}

- (SKContactAvailability) availability {
    if (![self isPropertyCached:@"availability"]) {
        self->_availability = [self coreAvailability];
        [self markPropertyAsCached:@"availability"];
    }
    
    return self->_availability;
}

- (void)setAvailability:(SKContactAvailability)availability {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"availability"]) {
        if (availability != self->_availability) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"availability"];
        replace = YES;
    }
    
    if (replace) {
        [self setCoreAvailability:availability];
        self->_availability = availability;
    }
}

- (NSString*) moodText {
    if (![self isPropertyCached:@"moodText"]) {
        [self->_moodText release];
        self->_moodText = [[self coreMoodText] copy];
        [self markPropertyAsCached:@"moodText"];
    }
    
    return self->_moodText;
}

- (void)setMoodText:(NSString *)moodText {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"moodText"]) {
        if (![moodText isEqual:self->_moodText]) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"moodText"];
        replace = YES;
    }
    
    if (replace) {
        self.coreMoodText = moodText;
        [self->_moodText release];
        self->_moodText = [moodText copy];
    }
}

- (NSString*) fullName {
    if (![self isPropertyCached:@"fullName"]) {
        [self->_fullName release];
        self->_fullName = [[self coreFullName] copy];
        [self markPropertyAsCached:@"fullName"];
    }
    
    return self->_fullName;
}

- (void)setFullName:(NSString *)fullName {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"fullName"]) {
        if (![fullName isEqual:self->_fullName]) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"fullName"];
        replace = YES;
    }
    
    if (replace) {
        self.coreFullName = fullName;
        [self->_fullName release];
        self->_fullName = [fullName copy];
    }
}

- (NSString*) country {
    if (![self isPropertyCached:@"country"]) {
        [self->_country release];
        self->_country = [[self coreCountry] copy];
        [self markPropertyAsCached:@"country"];
    }
    
    return self->_country;
}

- (void)setCountry:(NSString *)country {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"country"]) {
        if (![country isEqual:self->_country]) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"country"];
        replace = YES;
    }
    
    if (replace) {
        self.coreCountry = country;
        [self->_country release];
        self->_country = [country copy];
    }
}

- (NSArray*) languages {
    if (![self isPropertyCached:@"languages"]) {
        [self->_languages release];
        self->_languages = [[self coreLanguages] copy];
        [self markPropertyAsCached:@"languages"];
    }
    
    return self->_languages;
}

- (void)setLanguages:(NSArray *)languages {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"languages"]) {
        if (![languages isEqual:self->_languages]) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"languages"];
        replace = YES;
    }
    
    if (replace) {
        self.coreLanguages = languages;
        [self->_languages release];
        self->_languages = [languages copy];
    }
}

- (NSString*) province {
    if (![self isPropertyCached:@"province"]) {
        [self->_province release];
        self->_province = [[self coreProvince] copy];
        [self markPropertyAsCached:@"province"];
    }
    
    return self->_province;
}

- (void)setProvince:(NSString *)province {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"province"]) {
        if (![province isEqual:self->_province]) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"province"];
        replace = YES;
    }
    
    if (replace) {
        self.coreProvince = province;
        [self->_province release];
        self->_province = [province copy];
    }
}

- (NSString*) city {
    if (![self isPropertyCached:@"city"]) {
        [self->_city release];
        self->_city = [[self coreCity] copy];
        [self markPropertyAsCached:@"city"];
    }
    
    return self->_city;
}

- (void)setCity:(NSString *)city {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"city"]) {
        if (![city isEqual:self->_city]) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"city"];
        replace = YES;
    }
    
    if (replace) {
        self.coreCity = city;
        [self->_city release];
        self->_city = [city copy];
    }
}

- (NSString*) phoneHome {
    if (![self isPropertyCached:@"phoneHome"]) {
        [self->_phoneHome release];
        self->_phoneHome = [[self corePhoneHome] copy];
        [self markPropertyAsCached:@"phoneHome"];
    }
    
    return self->_phoneHome;
}

- (void)setPhoneHome:(NSString *)phoneHome {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"phoneHome"]) {
        if (![phoneHome isEqual:self->_phoneHome]) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"phoneHome"];
        replace = YES;
    }
    
    if (replace) {
        self.corePhoneHome = phoneHome;
        [self->_phoneHome release];
        self->_phoneHome = [phoneHome copy];
    }
}

- (NSString*) phoneOffice {
    if (![self isPropertyCached:@"phoneOffice"]) {
        [self->_phoneOffice release];
        self->_phoneOffice = [[self corePhoneOffice] copy];
        [self markPropertyAsCached:@"phoneOffice"];
    }
    
    return self->_phoneOffice;
}

- (void)setPhoneOffice:(NSString *)phoneOffice {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"phoneOffice"]) {
        if (![phoneOffice isEqual:self->_phoneOffice]) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"phoneOffice"];
        replace = YES;
    }
    
    if (replace) {
        [self setCorePhoneOffice:phoneOffice];
        [self->_phoneOffice release];
        self->_phoneOffice = [phoneOffice copy];
    }
}

- (NSString*) phoneMobile {
    if (![self isPropertyCached:@"phoneMobile"]) {
        [self->_phoneMobile release];
        self->_phoneMobile = [[self corePhoneMobile] copy];
        [self markPropertyAsCached:@"phoneMobile"];
    }
    
    return self->_skypeName;
}

- (void)setPhoneMobile:(NSString *)phoneMobile {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"phoneMobile"]) {
        if (![phoneMobile isEqual:self->_phoneMobile]) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"phoneMobile"];
        replace = YES;
    }
    
    if (replace) {
        self.corePhoneMobile = phoneMobile;
        [self->_phoneMobile release];
        self->_phoneMobile = [phoneMobile copy];
    }
}

- (NSString*) about {
    if (![self isPropertyCached:@"about"]) {
        [self->_about release];
        self->_about = [[self coreAbout] copy];
        [self markPropertyAsCached:@"about"];
    }
    
    return self->_about;
}

- (void)setAbout:(NSString *)about {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"about"]) {
        if (![about isEqual:self->_about]) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"about"];
        replace = YES;
    }
    
    if (replace) {
        [self setCoreAbout:about];
        [self->_about release];
        self->_about = [about copy];
    }
}

- (NSString*) homepage {
    if (![self isPropertyCached:@"homepage"]) {
        [self->_homepage release];
        self->_homepage = [[self coreHomepage] copy];
        [self markPropertyAsCached:@"homepage"];
    }
    
    return self->_homepage;
}

- (void)setHomepage:(NSString *)homepage {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"homepage"]) {
        if (![homepage isEqual:self->_homepage]) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"homepage"];
        replace = YES;
    }
    
    if (replace) {
        [self setCoreHomepage:homepage];
        [self->_homepage release];
        self->_homepage = [homepage copy];
    }
}

- (NSArray*) emails {
    if (![self isPropertyCached:@"emails"]) {
        [self->_emails release];
        self->_emails = [[self coreEmails] copy];
        [self markPropertyAsCached:@"emails"];
    }
    
    return self->_emails;
}

- (void)setEmails:(NSArray *)emails {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"emails"]) {
        if (emails != self->_emails) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"emails"];
        replace = YES;
    }
    
    if (replace) {
        [self setCoreEmails:emails];
        [self->_emails release];
        self->_emails = [emails copy];
    }
}

- (SKContactGender) gender {
    if (![self isPropertyCached:@"gender"]) {
        self->_gender = [self coreGender];
        [self markPropertyAsCached:@"gender"];
    }
    
    return self->_gender;
}

- (void)setGender:(SKContactGender)gender {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"gender"]) {
        if (self->_gender != gender) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"gender"];
        replace = YES;
    }
    
    if (replace) {
        [self setCoreGender:gender];
        self->_gender = gender;
    }
}

- (NSDate *) birthday {
    if (![self isPropertyCached:@"birthday"]) {
        [self->_birthday release];
        self->_birthday = [[self coreBirthday] copy];
        [self markPropertyAsCached:@"birthday"];
    }
    
    return self->_birthday;
}

- (void)setBirthday:(NSDate *)birthday {
    BOOL replace = NO;
    
    if ([self isPropertyCached:@"birthday"]) {
        if (![birthday isEqual:self->_birthday]) {
            replace = YES;
        }
    }
    else {
        [self markPropertyAsCached:@"birthday"];
        replace = YES;
    }
    
    if (replace) {
        [self setCoreBirthday:birthday];
        [self->_birthday release];
        self->_birthday = [birthday copy];
    }
}

- (void)dealloc {
    [self->_skypeName release];
    [self->_avatarData release];
    [self->_moodText release];
    [self->_fullName release];
    [self->_birthday release];
    [self->_country release];
    [self->_languages release];
    [self->_province release];
    [self->_city release];
    [self->_phoneHome release];
    [self->_phoneOffice release];
    [self->_phoneMobile release];
    [self->_emails release];
    [self->_homepage release];
    [self->_about release];
    
    [super dealloc];
}

@end
