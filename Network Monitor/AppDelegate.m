//
//  AppDelegate.m
//  Network Monitor
//
//  Created by HCorbucc on 10/13/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _defaults = [NSUserDefaults standardUserDefaults];
    
    float iconWidth = [[NSImage imageNamed: @"unknown"] size].width;
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: iconWidth];
    [_statusItem setMenu: _statusMenu];
    [_statusItem setHighlightMode:YES];
    [_statusItem.image setTemplate:YES];
    
    [self synchronizeMenuItemsWithPreferences];
    [window orderOut: self];
    
    NSString* (^serverAddressRetriever)() = ^() { return [_defaults stringForKey: SERVER_ADDRESS]; };
    NSNumber* (^sleepIntervalRetriever)() = ^() { return [NSNumber numberWithInteger: [_defaults integerForKey: REFRESH_INTERVAL]]; };
    NSNumber* (^timeoutRetriever)() = ^() { return [NSNumber numberWithInteger: [_defaults integerForKey: TIMEOUT]]; };
    _monitor = [[Monitor alloc] initWatching: serverAddressRetriever andUpdating: _statusItem every: sleepIntervalRetriever withTimeout: timeoutRetriever];
    [_monitor start];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[NSStatusBar systemStatusBar] removeStatusItem:_statusItem];
}

- (IBAction)toggleSound:(id)sender {
    NSMenuItem * soundItem = (NSMenuItem*) sender;
    [_defaults setBool: (soundItem.state ^ 1) forKey: SOUND_PREFERENCE];
    [self synchronizeSoundItem: soundItem];
}

- (IBAction)toggleNotifications:(id)sender {
    NSMenuItem * notificationItem = (NSMenuItem*) sender;
    [_defaults setBool: (notificationItem.state ^ 1) forKey: NOTIFICATION_PREFERENCE];
    [self synchronizeNotificationsItem: notificationItem];
}

- (IBAction)toggleLaunchAtLogin:(id)sender {
    NSMenuItem * launchItem = (NSMenuItem*) sender;
    [_defaults setBool: (launchItem.state ^ 1) forKey: LOGIN_PREFERENCE];
    [self synchronizeLaunchAtLogin: launchItem];
}

- (IBAction)saveLog:(id)sender {
    NSSavePanel* savePanel = [NSSavePanel savePanel];

    if ( [savePanel runModal] == NSOKButton )
    {
        NSString* log = [self retrieveLog];
        NSURL* url = [savePanel URL];
        NSError *writeError = nil;
        [log writeToFile: [url path] atomically:NO encoding:NSUTF8StringEncoding error:&writeError];
    }
}
- (IBAction)openPreferences:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [window makeKeyAndOrderFront:NSApp];
}
#pragma private
- (void) synchronizeMenuItemsWithPreferences {
    [self synchronizeSoundItem: [_statusMenu itemWithTag: 1]];
    [self synchronizeNotificationsItem: [_statusMenu itemWithTag: 2]];
    [self synchronizeLaunchAtLogin: [_statusMenu itemWithTag: 3]];
}
- (void) synchronizeSoundItem: (NSMenuItem*) item {
    [self synchronizeMenuItem: item withPreference: SOUND_PREFERENCE updating:
     ^(BOOL state) { [_monitor setSoundAlertsEnabled: state]; }];
}
- (void) synchronizeNotificationsItem: (NSMenuItem*) item {
    [self synchronizeMenuItem: item withPreference: NOTIFICATION_PREFERENCE updating:
     ^(BOOL state) { [_monitor setNotificationsEnabled: state]; }];
}
- (void) synchronizeLaunchAtLogin: (NSMenuItem*) item {
    [self synchronizeMenuItem: item withPreference: LOGIN_PREFERENCE updating:
     ^(BOOL state) {
         if(state) {
             [self addAppAsLoginItem];
         } else {
             [self deleteAppFromLoginItem];
         }
     }];
}
- (void) synchronizeMenuItem: (NSMenuItem*) item withPreference: (NSString*) preferenceKey updating: (void (^)(BOOL state)) callback {
    item.state = [_defaults boolForKey: preferenceKey];
    callback(item.state);
}
- (void) addAppAsLoginItem {
    NSString * appPath = [[NSBundle mainBundle] bundlePath];
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath: appPath];
    
    LSSharedFileListRef loginItems =
      LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItems) {
        LSSharedFileListItemRef item =
            LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemLast,
                                          NULL, NULL, url, NULL, NULL);
        if (item) {
            CFRelease(item);
        }
    }
    
    CFRelease(loginItems);
}

- (void) deleteAppFromLoginItem {
    NSString * appPath = [[NSBundle mainBundle] bundlePath];
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath: appPath];
    
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
                                                            kLSSharedFileListSessionLoginItems, NULL);
    if (loginItems) {
        UInt32 seedValue;
        NSArray  *loginItemsArray =
            (__bridge NSArray *) LSSharedFileListCopySnapshot(loginItems, &seedValue);
        for(int i = 0; i < [loginItemsArray count]; i++){
            LSSharedFileListItemRef itemRef =
                (__bridge LSSharedFileListItemRef)[loginItemsArray objectAtIndex: i];
            if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &url, NULL) == noErr) {
                NSString * urlPath = [(__bridge NSURL*) url path];
                if ([urlPath compare: appPath] == NSOrderedSame){
                    LSSharedFileListItemRemove(loginItems,itemRef);
                }
            }
        }
    }
}

- (NSString*) retrieveLog {
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = [pipe fileHandleForReading];

    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/bin/grep"];
    [task setArguments: @[@"Network Monitor", @"/private/var/log/system.log"]];
    [task setStandardOutput: pipe];

    [task launch];
    [task waitUntilExit];

    NSData *data = [file readDataToEndOfFile];
    [file closeFile];

    return [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
}

@end
