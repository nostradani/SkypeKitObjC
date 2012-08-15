/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import "SKMessage.h"

#import <Foundation/NSString.h>
#import <Foundation/NSArray.h>

#import "MessageBinding.hpp"
#import "TransferBinding.hpp"

#import "SKContact.h"

@interface SKMessage (Private)

- (NSString*) coreBody;
- (NSString*) coreAuthor;
- (NSString*) coreAuthorDisplayName;
- (SKMessageType) coreType;

@property (nonatomic, copy, readwrite) NSString* body;
@property (nonatomic, copy, readwrite) NSString* author;
@property (nonatomic, copy, readwrite) NSString* authorDisplayName;
@property (nonatomic, assign, readwrite) SKMessageType type;

@end

@implementation SKMessage

- (NSString *)coreBody {
    Sid::String message;
    
    NSString* result = nil;
    
    if (self.coreMessage->GetPropBodyXml(message)) {
        [self markPropertyAsCached:@"body"];
        result = [NSString stringWithCString:message encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSString *) coreAuthorDisplayName {
    Sid::String name;
    
    NSString* result = nil;
    
    if (self.coreMessage->GetPropAuthorDisplayname(name)) {
        [self markPropertyAsCached:@"authorDisplayName"];
        result = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSString *) coreAuthor {
    Sid::String name;
    
    NSString* result = nil;
    
    if (self.coreMessage->GetPropAuthor(name)) {
        [self markPropertyAsCached:@"author"];
        result = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (SKMessageType) coreType {
    Message::TYPE aType;
    SKMessageType result = SKMessageTypePostedAlert;
    
    if (self.coreMessage->GetPropType(aType)) {
        [self markPropertyAsCached:@"type"];
        result = [SKMessage decodeType:aType];
    }
    
    return result;
}

- (NSString *)body {
    if (![self isPropertyCached:@"body"]) {
        [self->_body release];
        self->_body = [[self coreBody] copy];
    }
    
    return self->_body;
}

- (void)setBody:(NSString *) aBody {
    if (self->_body != aBody) {
        [self->_body release];
        self->_body = [aBody copy];
    }
}

- (NSString *)author {
    if (![self isPropertyCached:@"author"]) {
        [self->_author release];
        self->_author = [[self coreAuthor] copy];
    }
    
    return self->_author;
}

- (void)setAuthor:(NSString *) aAuthor {
    if (self->_author != aAuthor) {
        [self->_author release];
        self->_author = [aAuthor copy];
    }
}

- (NSString *) authorDisplayName {
    if (![self isPropertyCached:@"authorDisplayName"]) {
        [self->_authorDisplayName release];
        self->_authorDisplayName = [[self coreAuthorDisplayName] copy];
    }
    
    return self->_authorDisplayName;
}

- (void)setAuthorDisplayName:(NSString *) aAuthorDisplayName {
    if (self->_authorDisplayName != aAuthorDisplayName) {
        [self->_authorDisplayName release];
        self->_authorDisplayName = [aAuthorDisplayName copy];
    }
}

- (SKMessageType) type {
    if (![self isPropertyCached:@"type"]) {
        self->_type = [self coreType];
    }
    
    return self->_type;
}

- (void)setType:(SKMessageType) aType {
    if (self->_type != aType) {
        self->_type = aType;
    }
}

- (NSArray*) transfers {
    TransferRefs transfers;
    NSMutableArray* result = nil;
    
    if (self.coreMessage->GetTransfers(transfers)) {
        NSUInteger size = transfers.size();
        
        result = [NSMutableArray arrayWithCapacity:size];
        
        for (NSUInteger i =0; i<size; i++) {
            SKTransfer* transfer = [SKObject resolve:transfers[i]];
            [result addObject:transfer];
        }
    }
    
    return result;
}

- (void)onChange:(int)prop {
    switch (prop) {
        case Message::P_BODY_XML:
            self.body = [self coreBody];
            break;
            
        case Message::P_TYPE:
            self.type = [self coreType];
            break;
            
        case Message::P_AUTHOR:
            self.author = [self coreAuthor];
            break;
            
        case Message::P_AUTHOR_DISPLAYNAME:
            self.authorDisplayName = [self coreAuthorDisplayName];
            break;
            
        default:
            break;
    }
}

- (void)dealloc {
    [self->_body release];
    [self->_author release];
    [self->_authorDisplayName release];
    
    [super dealloc];
}

@end
