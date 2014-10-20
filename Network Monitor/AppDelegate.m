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
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setMenu: _statusMenu];
    [_statusItem setHighlightMode:YES];
    
    _monitor = [[Monitor alloc] initWatching: @"4.2.2.2" andUpdating: _statusItem];
    
    [_monitor start];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[NSStatusBar systemStatusBar] removeStatusItem:_statusItem];
}

- (IBAction)toggleSound:(id)sender {
    NSMenuItem * soundItem = (NSMenuItem*) sender;
    
    soundItem.state = (soundItem.state ^ 1);
    [_monitor setSoundAlertsEnabled: soundItem.state];
}

- (IBAction)toggleNotifications:(id)sender {
    NSMenuItem * notificationItem = (NSMenuItem*) sender;
    
    notificationItem.state = (notificationItem.state ^ 1);
    [_monitor setNotificationsEnabled: notificationItem.state];
}

@end
