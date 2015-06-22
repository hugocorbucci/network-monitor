//
//  Pinger.m
//  Network Monitor
//
//  Created by HCorbucc on 10/14/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

#import "Pinger.h"

@implementation Pinger
- (id)initWatching:(NSString* (^)(void)) ipAddressCallback withTimeout: (NSNumber* (^)(void)) timeoutCallback {
    _ipAddressCallback = ipAddressCallback;
    _timeoutCallback = timeoutCallback;
    return [super init];
}

- (BOOL)ping {
    @try {
        NSPipe* output = [NSPipe pipe];
        NSTask* pingTask = [[NSTask alloc] init];
        [pingTask setLaunchPath: @"/sbin/ping"];
        [pingTask setArguments: @[
                                  [NSString stringWithFormat: @"-t%@", _timeoutCallback()],
                                  @"-q",
                                  @"-o",
                                  [NSString stringWithFormat: @"%@", _ipAddressCallback()]
                                  ]];
        [pingTask setStandardOutput:output];
        [pingTask setStandardError:output];
        [pingTask launch];
        [pingTask waitUntilExit];
        return [pingTask terminationStatus] == 0;
    }
    @catch (NSException *exception) {
        return false;
    }
    @finally {
        
    }
    
}

- (NSString *)description {
    return [NSString stringWithFormat: @"ping -t%@ -q -o %@", _timeoutCallback(), _ipAddressCallback()];
}

@end