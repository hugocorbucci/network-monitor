//
//  PreferenceController.h
//  Network Monitor
//
//  Created by Hugo Corbucci on 6/21/15.
//  Copyright (c) 2015 Hugo Corbucci. All rights reserved.
//

#ifndef Network_Monitor_PreferenceController_h
#define Network_Monitor_PreferenceController_h

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "PreferenceConstants.h"

@interface PreferenceController : NSWindowController {
    IBOutlet NSTextField * server;
    IBOutlet NSTextField * sleepInterval;
    IBOutlet NSTextField * timeout;
    IBOutlet NSStepper * sleepIntervalStepper;
    IBOutlet NSStepper * timeoutStepper;
    NSUserDefaults* _defaults;
}

@end

#endif
