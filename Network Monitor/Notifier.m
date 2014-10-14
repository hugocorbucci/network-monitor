//
//  Notifier.m
//  Network Monitor
//
//  Created by HCorbucc on 10/14/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

#import "Notifier.h"

@implementation Notifier

- (void)announce:(id)message {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Network Notifier";
    notification.informativeText = message;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification: notification];
}

@end