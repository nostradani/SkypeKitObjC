/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKObject.h"

@class SKContactSearch;
@class ContactSearchBinding;
@class SKContact;
@class NSArray;

typedef enum {
    SKContactSearchStatusUnknown,
    SKContactSearchStatusConstruction,
    SKContactSearchStatusPending,
    SKContactSearchStatusExtendable,
    SKContactSearchStatusFinished,
    SKContactSearchStatusFailed
} SKContactSearchStatus;

@protocol SKContactSearchDelegate <NSObject>

- (void) contactSearch:(SKContactSearch*)contactSearch didChangeStatus:(SKContactSearchStatus) status;
- (void) contactSearch:(SKContactSearch *)contactSearch didGetNewResult:(SKContact*)contact;

@end

@interface SKContactSearch : SKObject {
    id<SKContactSearchDelegate> _delegate;
}

@property (nonatomic, readwrite, assign) id<SKContactSearchDelegate> delegate;

- (NSArray*) results;
- (BOOL) submit;

@end
