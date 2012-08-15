/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKContactSearch.h"
#import "SKContact.h"

#import <Foundation/NSString.h>
#import <Foundation/NSArray.h>

#import "ContactBinding.hpp"
#import "ContactSearchBinding.hpp"

static id<SKContactSearchDelegate> standardDelegate = nil;

@implementation SKContactSearch

@synthesize delegate = _delegate;

- (SKContactSearchStatus) status {
    ContactSearch::STATUS status;
    SKContactSearchStatus result = SKContactSearchStatusUnknown;
    
    if (self.coreContactSearch->GetPropContactSearchStatus(status)) {
        result = [SKContactSearch decodeStatus:status];
    }
    
    return result;
}

- (NSArray*) results {
    NSMutableArray* result = nil;
    ContactRefs contacts;
    
    if (self.coreContactSearch->GetResults(contacts)) {
        NSUInteger size = contacts.size();
        result = [NSMutableArray arrayWithCapacity:size];
        
        for (NSUInteger i=0; i<size; i++) {
            SKContact* contact = [SKObject resolve:contacts[i]];
            [result addObject:contact];
        }
        
    }
    
    return result;
}

- (BOOL) submit {
    return self.coreContactSearch->Submit();
}

- (void)onChange:(int)prop {
    @autoreleasepool {
        switch (prop) {
            case Transfer::P_STATUS:
                [self.delegate contactSearch:self didChangeStatus:self.status];
                break;
                
            default:
                break;
        }
    }
}

@end
