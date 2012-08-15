/*
 * Copyright (c) 2012 Daniel Muhra. All rights reserved.
 */

#import <Foundation/NSObject.h>


@interface SKAudioDevice : NSObject {
    NSString* _handle;
    NSString* _name;
    NSString* _productId;
}

- (id) initWithHandle:(NSString*) aHandle name:(NSString*) aName productId:(NSString*) aProductId; 
+ (id) deviceWithHandle:(NSString*) aHandle name:(NSString*) aName productId:(NSString*) aProductId; 

@property (nonatomic, readonly) NSString* handle;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSString* productId;

@end
