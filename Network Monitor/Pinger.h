//
//  Pinger.h
//  Network Monitor
//
//  Created by HCorbucc on 10/14/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

#ifndef Network_Monitor_Pinger_h
#define Network_Monitor_Pinger_h

#import <Foundation/Foundation.h>

@interface Pinger : NSObject {
    @private
    NSString* (^_ipAddressCallback)(void);
    NSNumber* (^_timeoutCallback)(void);
}
- (id) initWatching: (NSString* (^)(void)) ipAddressCallback withTimeout: (NSNumber* (^)(void))timeoutCallback;
- (BOOL) ping;
@end

#endif
