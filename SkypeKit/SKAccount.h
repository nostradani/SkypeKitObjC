/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKObject.h"
#import "SKContact.h"

@class AccountBinding;
@class SKAccount;
@class NSArray;

typedef enum {
    SKAccountLogoutReasonUnknown,
    SKAccountLogoutReasonLogoutCalled,
    SKAccountLogoutReasonHttpsProxyAuthFailed,
    SKAccountLogoutReasonSocksProxyAuthFailed,
    SKAccountLogoutReasonP2PConnectFailed,
    SKAccountLogoutReasonServerConnectFailed,
    SKAccountLogoutReasonServerOverloaded,
    SKAccountLogoutReasonDBInUse,
    SKAccountLogoutReasonInvalidSkypename,
    SKAccountLogoutReasonInvalidEmail,
    SKAccountLogoutReasonUnacceptablePassword,
    SKAccountLogoutReasonSkypenameTaken,
    SKAccountLogoutReasonRejectedAsUnderage,
    SKAccountLogoutReasonNoSuchIdentity,
    SKAccountLogoutReasonIncorrectPassword,
    SKAccountLogoutReasonTooManyLoginAttempts,
    SKAccountLogoutReasonPasswordHasChanged,
    SKAccountLogoutReasonPeriodicUICUpdateFailed,
    SKAccountLogoutReasonDBDiskFull,
    SKAccountLogoutReasonDBIOError,
    SKAccountLogoutReasonDBCorrupt,
    SKAccountLogoutReasonDBFailure,
    SKAccountLogoutReasonInvalidAppId,
    SKAccountLogoutReasonAppIdFailure,
    SKAccountLogoutReasonUnsupportedVersion,
    SKAccountLogoutReasonATOBlocked,
    SKAccountLogoutReasonRemoteLogout,
} SKAccountLogoutReason;

typedef enum {
    SKAccountLoginStatusUndefined,
    SKAccountLoginStatusConnectingToP2P,
    SKAccountLoginStatusConnectingToServer,
    SKAccountLoginStatusInitializing,
    SKAccountLoginStatusLoggingIn,
    SKAccountLoginStatusLoggedIn,
    SKAccountLoginStatusLoggingOut,
    SKAccountLoginStatusLoggedOut,
    SKAccountLoginStatusLoggedOutAndPWDSaved
} SKAccountLoginStatus;

@protocol SKAccountDelegate <NSObject>

- (void) account:(SKAccount*)account didChangeLoginStatus:(SKAccountLoginStatus) status;

@end

@interface SKAccount : SKObject {
    id<SKAccountDelegate> _delegate;
    NSString* _skypeName;
    NSData* _avatarData;
    SKContactAvailability _availability;
    NSString* _moodText;
    NSString* _fullName;
    NSDate* _birthday;
    SKContactGender _gender;
    NSString* _country;
    NSArray* _languages;
    NSString* _province;
    NSString* _city;
    NSString* _phoneHome;
    NSString* _phoneOffice;
    NSString* _phoneMobile;
    NSArray* _emails;
    NSString* _homepage;
    NSString* _about;
    SKAccountLoginStatus _status;
    SKAccountLogoutReason _logoutReason;
}

@property(nonatomic, assign) id<SKAccountDelegate> delegate;
@property(nonatomic, readonly) NSString* skypeName;
@property(nonatomic, retain) NSData* avatarData;
@property(nonatomic, assign) SKContactAvailability availability;
@property(nonatomic, copy) NSString* moodText;
@property(nonatomic, assign, readonly) SKAccountLoginStatus status;
@property(nonatomic, assign, readonly) SKAccountLogoutReason logoutReason;

@property (nonatomic, copy) NSString* fullName;
@property (nonatomic, copy) NSDate* birthday;
@property (nonatomic, assign) SKContactGender gender;
@property (nonatomic, copy) NSString* country;
@property (nonatomic, copy) NSArray* languages;
@property (nonatomic, copy) NSString* province;
@property (nonatomic, copy) NSString* city;
@property (nonatomic, copy) NSString* phoneHome;
@property (nonatomic, copy) NSString* phoneOffice;
@property (nonatomic, copy) NSString* phoneMobile;
@property (nonatomic, retain) NSArray* emails;
@property (nonatomic, copy) NSString* homepage;
@property (nonatomic, copy) NSString* about;

- (BOOL) loginWithPassword: (NSString*) password savePassword:(BOOL) savePassword saveData:(BOOL) saveData;

- (BOOL) logout;

@end
