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

@interface Monitor : NSObject {
    @private
    NSString *_ipAddress;
    NSStatusItem *_itemToUpdate;
    BOOL _notifications;
    BOOL _sound;
}
- (id) initWatching: (NSString*) ipAddress andUpdating: (NSStatusItem*) item;
- (void) start;
- (void) setNotificationsEnabled: (BOOL) enabled;
- (void) setSoundAlertsEnabled: (BOOL) enabled;
@end

#endif
