//
//  Speaker.m
//  Network Monitor
//
//  Created by HCorbucc on 10/13/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

#import "Speaker.h"

@implementation Speaker

- (void)announce:(id)message {
    @try {
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = @"/usr/bin/say";
        task.arguments  = @[message];
        [task launch];
        [task waitUntilExit];
    }
    @catch (NSException *exception) {
        // Ignore exceptions if I couldn't say anything. Not a big deal
    }
    @finally {
    }
}

@end
