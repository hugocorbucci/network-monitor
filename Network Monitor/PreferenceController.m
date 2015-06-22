//
//  PreferenceController.m
//  Network Monitor
//
//  Created by Hugo Corbucci on 6/21/15.
//  Copyright (c) 2015 Hugo Corbucci. All rights reserved.
//

#import "PreferenceController.h"
#include <arpa/inet.h>

@implementation PreferenceController

- (void)awakeFromNib {
    _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults registerDefaults: @{
                                   LOGIN_PREFERENCE: [NSNumber numberWithBool:NO],
                                   SOUND_PREFERENCE: [NSNumber numberWithBool:NO],
                                   NOTIFICATION_PREFERENCE: [NSNumber numberWithBool:YES],
                                   SERVER_ADDRESS: @"4.2.2.2",
                                   REFRESH_INTERVAL: @5,
                                   TIMEOUT: @5
                                   }];
    [sleepIntervalStepper setIntegerValue: [_defaults integerForKey: REFRESH_INTERVAL]];
    [timeoutStepper setIntegerValue: [_defaults integerForKey: TIMEOUT]];
    [self refreshBasedOnPreferences];
}

- (IBAction) changeSleepInterval: (id) sender {
    [self updatePreference: REFRESH_INTERVAL basedOn: (NSStepper*) sender];
    [self refreshField: sleepInterval basedOnPreferenceWithKey: REFRESH_INTERVAL];
}

- (IBAction) changeTimeout: (id) sender {
    [self updatePreference: TIMEOUT basedOn: (NSStepper*) sender];
    [self refreshField: timeout basedOnPreferenceWithKey: TIMEOUT];
}

- (void) updatePreference: (NSString*) key basedOn: (NSStepper*) stepper {
    NSInteger value = [stepper integerValue];
    [_defaults setInteger: value forKey: key];
}

- (void)controlTextDidChange:(NSNotification *)aNotification {
    NSTextField *textField = [aNotification object];
    NSString* address = [textField stringValue];
    if ([self isValidIPAddress: address]) {
        [_defaults setObject: address forKey: SERVER_ADDRESS];
        [textField setBackgroundColor: [NSColor clearColor]];
    } else {
        [textField setBackgroundColor: [NSColor redColor]];
    }
}

- (void) refreshBasedOnPreferences {
    [self refreshField: server basedOnStringPreferenceWithKey: SERVER_ADDRESS];
    [self refreshField: sleepInterval basedOnPreferenceWithKey: REFRESH_INTERVAL];
    [self refreshField: timeout basedOnPreferenceWithKey: TIMEOUT];
}

- (void) refreshField: (NSTextField*) field basedOnPreferenceWithKey: (NSString*) key {
    NSInteger currentValue = [_defaults integerForKey: key];
    NSString* text = [NSString stringWithFormat:@"%i", (int) currentValue];
    [field setStringValue: text];
}

- (void) refreshField: (NSTextField*) field basedOnStringPreferenceWithKey: (NSString*) key {
    NSString* currentValue = [_defaults stringForKey: key];
    [field setStringValue: currentValue];
}

- (Boolean) isValidIPAddress: (NSString*) address {
    const char *utf8 = [address UTF8String];
    int success;
    
    struct in_addr dst;
    success = inet_pton(AF_INET, utf8, &dst);
    if (success != 1) {
        struct in6_addr dst6;
        success = inet_pton(AF_INET6, utf8, &dst6);
    }
    
    return success == 1;
}

@end