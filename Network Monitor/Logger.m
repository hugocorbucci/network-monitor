//
//  Logger.m
//  Network Monitor
//
//  Created by HCorbucc on 10/14/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

#import "Logger.h"

@implementation Logger
- (instancetype)init {
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [super init];
}
- (void)announce:(NSString *)message {
    NSLog(@"[%@]: %@",[_formatter stringFromDate:[NSDate date]], message);
}
@end
