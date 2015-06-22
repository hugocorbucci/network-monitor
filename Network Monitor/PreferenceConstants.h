//
//  PreferenceConstants.h
//  Network Monitor
//
//  Created by Hugo Corbucci on 6/21/15.
//  Copyright (c) 2015 Hugo Corbucci. All rights reserved.
//

#ifndef Network_Monitor_PreferenceConstants_h
#define Network_Monitor_PreferenceConstants_h

#import <Foundation/Foundation.h>

@interface PreferenceConstants : NSObject {
}

extern NSString *const LOGIN_PREFERENCE;
extern NSString *const SOUND_PREFERENCE;
extern NSString *const NOTIFICATION_PREFERENCE;
extern NSString *const SERVER_ADDRESS;
extern NSString *const REFRESH_INTERVAL;
extern NSString *const TIMEOUT;

@end

#endif
