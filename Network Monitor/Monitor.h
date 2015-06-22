//
//  Monitor.h
//  Network Monitor
//
//  Created by HCorbucc on 10/13/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

#ifndef Network_Monitor_Monitor_h
#define Network_Monitor_Monitor_h

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "Pinger.h"

@interface Monitor : NSObject {
    @private
    NSThread *_background;
    NSStatusItem *_itemToUpdate;
    Pinger *_pinger;
    NSDictionary *_alerts;
    NSMutableDictionary *_enabledAlerts;
}
- (id) initWatching: (NSString* (^)(void)) ipAddressCallback andUpdating: (NSStatusItem*) item every: (NSNumber* (^)(void)) sleepInterval withTimeout: (NSNumber* (^)(void)) timeout;
- (void) start;
- (void) setNotificationsEnabled: (BOOL) enabled;
- (void) setSoundAlertsEnabled: (BOOL) enabled;
@end

#endif
