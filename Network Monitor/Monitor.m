//
//  Monitor.m
//  Network Monitor
//
//  Created by HCorbucc on 10/13/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

#import "Monitor.h"

@implementation Monitor

- (id)initWatching:(NSString *)ipAddress andUpdating:(NSStatusItem *)item {
    _ipAddress = ipAddress;
    _itemToUpdate = item;
    _notifications = YES;
    _sound = YES;
    return [super init];
}

- (void)start {
    NSLog(@"Starting to ping %@ and updating %@", _ipAddress, _itemToUpdate);
}
- (void) setNotificationsEnabled: (BOOL) enabled {
    _notifications = enabled;
    NSLog(@"Notifications are now %@", _notifications ? @"enabled" : @"disabled");
}
- (void) setSoundAlertsEnabled: (BOOL) enabled {
    _sound = enabled;
    NSLog(@"Sound alerts are now %@", _sound ? @"enabled" : @"disabled");
}
@end