//
//  AlertCenter.h
//  Network Monitor
//
//  Created by HCorbucc on 10/13/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

#ifndef Network_Monitor_AlertCenter_h
#define Network_Monitor_AlertCenter_h

#import <Foundation/Foundation.h>

@protocol AlertCenter <NSObject>
- (void) announce:(NSString*) message;
@end

#endif
