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
    
    [self toggleStateOfItem: soundItem named: @"sound"];
    [_monitor setSoundAlertsEnabled: soundItem.state];
}

- (IBAction)toggleNotifications:(id)sender {
    NSMenuItem * notificationItem = (NSMenuItem*) sender;
    
    [self toggleStateOfItem: notificationItem named: @"notification"];
    [_monitor setNotificationsEnabled: notificationItem.state];
}

- (void)toggleStateOfItem:(NSMenuItem*) item named: (NSString*) key_base {
    item.state = (item.state ^ 1);
    NSString *currentValue = @"_off";
    NSString *nextValue = @"_on";
    if (item.state == YES) {
        NSString *temp = currentValue;
        currentValue = nextValue;
        nextValue = temp;
    }
    item.title = NSLocalizedString([key_base stringByAppendingString: nextValue], @"Turn on or off the notification type");
}

@end
