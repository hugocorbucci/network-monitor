//
//  Logger.h
//  Network Monitor
//
//  Created by HCorbucc on 10/14/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

#ifndef Network_Monitor_Logger_h
#define Network_Monitor_Logger_h

#import "AlertCenter.h"
#import <Foundation/Foundation.h>

@interface Logger : NSObject <AlertCenter> {
    @private
    NSDateFormatter *_formatter;
}

@end

#endif
