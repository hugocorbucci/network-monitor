//
//  Logger.swift
//  Network Monitor
//
//  Created by HCorbucc on 10/20/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

import Foundation

class Logger : AlertCenter {
    func announce(message: NSString) {
        NSLog("%@", message);
    }
}