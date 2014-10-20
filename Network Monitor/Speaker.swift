//
//  Speaker.swift
//  Network Monitor
//
//  Created by HCorbucc on 10/20/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

import Foundation

class Speaker : AlertCenter {
    func announce(message: NSString) {
        let task = NSTask()
        task.launchPath = "/usr/bin/say"
        task.arguments = [message]
        task.launch()
        task.waitUntilExit()
    }
}