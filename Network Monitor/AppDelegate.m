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
    _monitor = [[Monitor alloc] initWatching: @"4.2.2.2" andUpdating: _statusItem];
    
    [_statusItem setMenu: _statusMenu];
    [_statusItem setImage: [NSImage imageNamed: @"unknown"]];
    [_statusItem setHighlightMode:YES];
    [_statusItem setToolTip: @"Your connection state is unknown"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[NSStatusBar systemStatusBar] removeStatusItem:_statusItem];
}

- (IBAction)toggleSound:(id)sender {
    NSMenuItem * soundItem = (NSMenuItem*) sender;
    
    [_monitor setSoundAlertsEnabled: soundItem.state];
    [self toggleStateOfItem: soundItem];
}

- (IBAction)toggleNotifications:(id)sender {
    NSMenuItem * notificationItem = (NSMenuItem*) sender;
    
    [_monitor setNotificationsEnabled: notificationItem.state];
    [self toggleStateOfItem: notificationItem];
}

- (void)toggleStateOfItem:(NSMenuItem*) item {
    item.state = (item.state ^ 1);
    NSString *currentValue = @"off";
    NSString *nextValue = @"on";
    item.title = [item.title stringByReplacingOccurrencesOfString:currentValue withString:nextValue];
}

@end
