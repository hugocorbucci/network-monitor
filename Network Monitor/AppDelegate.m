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
    
    [self toggleStateOfItem: soundItem];
    [_monitor setSoundAlertsEnabled: soundItem.state];
}

- (IBAction)toggleNotifications:(id)sender {
    NSMenuItem * notificationItem = (NSMenuItem*) sender;
    
    [self toggleStateOfItem: notificationItem];
    [_monitor setNotificationsEnabled: notificationItem.state];
}

- (void)toggleStateOfItem:(NSMenuItem*) item {
    item.state = (item.state ^ 1);
    NSString *currentValue = @"off";
    NSString *nextValue = @"on";
    if (item.state == YES) {
        NSString *temp = currentValue;
        currentValue = nextValue;
        nextValue = temp;
    }
    item.title = [item.title stringByReplacingOccurrencesOfString:currentValue withString:nextValue];
}

@end
