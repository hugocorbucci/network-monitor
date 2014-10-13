//
//  AppDelegate.h
//  Network Monitor
//
//  Created by HCorbucc on 10/13/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Monitor.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
@private
    IBOutlet NSMenu * _statusMenu;
    NSStatusItem * _statusItem;
    Monitor * _monitor;
}

- (IBAction)toggleSound:(id)sender;
- (IBAction)toggleNotifications:(id)sender;
@end

