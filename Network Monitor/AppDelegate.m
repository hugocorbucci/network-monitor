//
//  AppDelegate.m
//  Network Monitor
//
//  Created by HCorbucc on 10/13/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
NSString *const LOGIN_PREFERENCE = @"OpenAtLogin";
NSString *const SOUND_PREFERENCE = @"SoundAlerts";
NSString *const NOTIFICATION_PREFERENCE = @"NotificationAlerts";

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _defaults = [NSUserDefaults standardUserDefaults];
    [_defaults registerDefaults: @{
        LOGIN_PREFERENCE: [NSNumber numberWithBool:YES],
        SOUND_PREFERENCE: [NSNumber numberWithBool:NO],
        NOTIFICATION_PREFERENCE: [NSNumber numberWithBool:YES]
    }];
    
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setMenu: _statusMenu];
    [_statusItem setHighlightMode:YES];
    
    [self synchronizeMenuItemsWithPreferences];
    
    _monitor = [[Monitor alloc] initWatching: @"4.2.2.2" andUpdating: _statusItem];
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
    item.state = [[NSUserDefaults standardUserDefaults] boolForKey: preferenceKey];
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
        for(int i ; i< [loginItemsArray count]; i++){
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

@end
