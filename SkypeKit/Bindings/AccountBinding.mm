/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "AccountBinding.hpp"

AccountImp::AccountImp(unsigned int oid, SERootObject* root) : ObjectImp([SKAccount class], root), Account(oid, root){
};

AccountImp::~AccountImp() {
}

SEReference AccountImp::coreRef() {
    return this->ref();
}

void AccountImp::OnChange(int prop) {
    [this->_objectInstance onChange:prop];
};

@implementation SKAccount (Binding)

- (AccountImp*) coreAccount {
    return (AccountImp*)[self object];
}

+ (Account::STATUS)encodeLoginStatus:(SKAccountLoginStatus)status {
    Account::STATUS result = Account::LOGGED_OUT;
    
    switch (status) {
        case SKAccountLoginStatusConnectingToP2P: {
            result = Account::CONNECTING_TO_P2P;
            break;
        }
        
        case SKAccountLoginStatusConnectingToServer: {
            result = Account::CONNECTING_TO_SERVER;
            break;
        }
            
        case SKAccountLoginStatusInitializing: {
            result = Account::INITIALIZING;
            break;
        }
            
        case SKAccountLoginStatusLoggedIn: {
            result = Account::LOGGED_IN;
            break;
        }
            
        case SKAccountLoginStatusLoggedOut: {
            result = Account::LOGGED_OUT;
            break;
        }
            
        case SKAccountLoginStatusLoggedOutAndPWDSaved: {
            result = Account::LOGGED_OUT_AND_PWD_SAVED;
            break;
        }
            
        case SKAccountLoginStatusLoggingIn: {
            result = Account::LOGGING_IN;
            break;
        }
            
        case SKAccountLoginStatusLoggingOut: {
            result = Account::LOGGING_OUT;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

+ (SKAccountLoginStatus)decodeLoginStatus:(Account::STATUS)status {
    SKAccountLoginStatus result = SKAccountLoginStatusUndefined;
    
    switch (status) {
        case Account::CONNECTING_TO_P2P: {
            result = SKAccountLoginStatusConnectingToP2P;
            break;
        }
            
        case Account::CONNECTING_TO_SERVER: {
            result = SKAccountLoginStatusConnectingToServer;
            break;
        }
            
        case Account::INITIALIZING: {
            result = SKAccountLoginStatusInitializing;
            break;
        }
            
        case Account::LOGGED_IN: {
            result = SKAccountLoginStatusLoggedIn;
            break;
        }
            
        case Account::LOGGED_OUT: {
            result = SKAccountLoginStatusLoggedOut;
            break;
        }
            
        case Account::LOGGED_OUT_AND_PWD_SAVED: {
            result = SKAccountLoginStatusLoggedOutAndPWDSaved;
            break;
        }
            
        case Account::LOGGING_IN: {
            result = SKAccountLoginStatusLoggingIn;
            break;
        }
            
        case Account::LOGGING_OUT: {
            result = SKAccountLoginStatusLoggingOut;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

+ (Account::LOGOUTREASON)encodeLogoutReason:(SKAccountLogoutReason)reason {
    Account::LOGOUTREASON result = Account::LOGOUT_CALLED;
    
    switch (reason) {
        case SKAccountLogoutReasonAppIdFailure: {
            result = Account::APP_ID_FAILURE;
            break;
        }
            
        case SKAccountLogoutReasonUnsupportedVersion: {
            result = Account::UNSUPPORTED_VERSION;
            break;
        }
            
        case SKAccountLogoutReasonUnacceptablePassword: {
            result = Account::UNACCEPTABLE_PASSWORD;
            break;
        }
            
        case SKAccountLogoutReasonTooManyLoginAttempts: {
            result = Account::TOO_MANY_LOGIN_ATTEMPTS;
            break;
        }
            
        case SKAccountLogoutReasonSocksProxyAuthFailed: {
            result = Account::SOCKS_PROXY_AUTH_FAILED;
            break;
        }
            
        case SKAccountLogoutReasonSkypenameTaken: {
            result = Account::SKYPENAME_TAKEN;
            break;
        }
            
        case SKAccountLogoutReasonServerOverloaded: {
            result = Account::SERVER_OVERLOADED;
            break;
        }
            
        case SKAccountLogoutReasonServerConnectFailed: {
            result = Account::SERVER_CONNECT_FAILED;
            break;
        }
            
        case SKAccountLogoutReasonRemoteLogout: {
            result = Account::REMOTE_LOGOUT;
            break;
        }
            
        case SKAccountLogoutReasonRejectedAsUnderage: {
            result = Account::REJECTED_AS_UNDERAGE;
            break;
        }
            
        case SKAccountLogoutReasonPeriodicUICUpdateFailed: {
            result = Account::PERIODIC_UIC_UPDATE_FAILED;
            break;
        }
            
        case SKAccountLogoutReasonPasswordHasChanged: {
            result = Account::PASSWORD_HAS_CHANGED;
            break;
        }
            
        case SKAccountLogoutReasonP2PConnectFailed: {
            result = Account::P2P_CONNECT_FAILED;
            break;
        }
            
        case SKAccountLogoutReasonNoSuchIdentity: {
            result = Account::NO_SUCH_IDENTITY;
            break;
        }
            
        case SKAccountLogoutReasonLogoutCalled: {
            result = Account::LOGOUT_CALLED;
            break;
        }
            
        case SKAccountLogoutReasonInvalidSkypename: {
            result = Account::INVALID_SKYPENAME;
            break;
        }
            
        case SKAccountLogoutReasonInvalidEmail: {
            result = Account::INVALID_EMAIL;
            break;
        }
            
        case SKAccountLogoutReasonInvalidAppId: {
            result = Account::INVALID_APP_ID;
            break;
        }
            
        case SKAccountLogoutReasonIncorrectPassword: {
            result = Account::INCORRECT_PASSWORD;
            break;
        }
            
        case SKAccountLogoutReasonHttpsProxyAuthFailed: {
            result = Account::HTTPS_PROXY_AUTH_FAILED;
            break;
        }
            
        case SKAccountLogoutReasonDBIOError: {
            result = Account::DB_IO_ERROR;
            break;
        }
            
        case SKAccountLogoutReasonDBInUse: {
            result = Account::DB_IN_USE;
            break;
        }
            
        case SKAccountLogoutReasonDBFailure: {
            result = Account::DB_FAILURE;
            break;
        }
            
        case SKAccountLogoutReasonDBDiskFull: {
            result = Account::DB_DISK_FULL;
            break;
        }
            
        case SKAccountLogoutReasonDBCorrupt: {
            result = Account::DB_CORRUPT;
            break;
        }
            
        case SKAccountLogoutReasonATOBlocked: {
            result = Account::ATO_BLOCKED;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

+ (SKAccountLogoutReason)decodeLogoutReason:(Account::LOGOUTREASON)reason {
    SKAccountLogoutReason result = SKAccountLogoutReasonUnknown;
    
    switch (reason) {
        case Account::APP_ID_FAILURE: {
            result = SKAccountLogoutReasonAppIdFailure;
            break;
        }
            
        case Account::UNSUPPORTED_VERSION: {
            result = SKAccountLogoutReasonUnsupportedVersion;
            break;
        }
            
        case Account::UNACCEPTABLE_PASSWORD: {
            result = SKAccountLogoutReasonUnacceptablePassword;
            break;
        }
            
        case Account::TOO_MANY_LOGIN_ATTEMPTS: {
            result = SKAccountLogoutReasonTooManyLoginAttempts;
            break;
        }
            
        case Account::SOCKS_PROXY_AUTH_FAILED: {
            result = SKAccountLogoutReasonSocksProxyAuthFailed;
            break;
        }
            
        case Account::SKYPENAME_TAKEN: {
            result = SKAccountLogoutReasonSkypenameTaken;
            break;
        }
            
        case Account::SERVER_OVERLOADED: {
            result = SKAccountLogoutReasonServerOverloaded;
            break;
        }
            
        case Account::SERVER_CONNECT_FAILED: {
            result = SKAccountLogoutReasonServerConnectFailed;
            break;
        }
            
        case Account::REMOTE_LOGOUT: {
            result = SKAccountLogoutReasonRemoteLogout;
            break;
        }
            
        case Account::REJECTED_AS_UNDERAGE: {
            result = SKAccountLogoutReasonRejectedAsUnderage;
            break;
        }
            
        case Account::PERIODIC_UIC_UPDATE_FAILED: {
            result = SKAccountLogoutReasonPeriodicUICUpdateFailed;
            break;
        }
            
        case Account::PASSWORD_HAS_CHANGED: {
            result = SKAccountLogoutReasonPasswordHasChanged;
            break;
        }
            
        case Account::P2P_CONNECT_FAILED: {
            result = SKAccountLogoutReasonP2PConnectFailed;
            break;
        }
            
        case Account::NO_SUCH_IDENTITY: {
            result = SKAccountLogoutReasonNoSuchIdentity;
            break;
        }
            
        case Account::LOGOUT_CALLED: {
            result = SKAccountLogoutReasonLogoutCalled;
            break;
        }
            
        case Account::INVALID_SKYPENAME: {
            result = SKAccountLogoutReasonInvalidSkypename;
            break;
        }
            
        case Account::INVALID_EMAIL: {
            result = SKAccountLogoutReasonInvalidEmail;
            break;
        }
            
        case Account::INVALID_APP_ID: {
            result = SKAccountLogoutReasonInvalidAppId;
            break;
        }
            
        case Account::INCORRECT_PASSWORD: {
            result = SKAccountLogoutReasonIncorrectPassword;
            break;
        }
            
        case Account::HTTPS_PROXY_AUTH_FAILED: {
            result = SKAccountLogoutReasonHttpsProxyAuthFailed;
            break;
        }
            
        case Account::DB_IO_ERROR: {
            result = SKAccountLogoutReasonDBIOError;
            break;
        }
            
        case Account::DB_IN_USE: {
            result = SKAccountLogoutReasonDBInUse;
            break;
        }
            
        case Account::DB_FAILURE: {
            result = SKAccountLogoutReasonDBFailure;
            break;
        }
            
        case Account::DB_DISK_FULL: {
            result = SKAccountLogoutReasonDBDiskFull;
            break;
        }
            
        case Account::DB_CORRUPT: {
            result = SKAccountLogoutReasonDBCorrupt;
            break;
        }
            
        case Account::ATO_BLOCKED: {
            result = SKAccountLogoutReasonATOBlocked;
            break;
        }
            
        default:
            break;
    }
    
    return result;
}

@end