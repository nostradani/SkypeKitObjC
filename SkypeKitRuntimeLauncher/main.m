//
//  main.m
//  SkypeKitRuntimeLauncher
//
//  Created by Daniel Muhra on 16.10.12.
//
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString* path = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        NSTask* runtime = [[NSTask alloc] init];
        [runtime setLaunchPath:path];
        
        NSPipe* errorPipe = [NSPipe pipe];
        [runtime setStandardError:errorPipe];
        NSFileHandle* errorHandle = [errorPipe fileHandleForReading];
        
        [runtime launch];
        
        NSData* data = nil;
        
        while ([data length] == 0) {
            data = [errorHandle availableData];
        }
    }
    return 0;
}

