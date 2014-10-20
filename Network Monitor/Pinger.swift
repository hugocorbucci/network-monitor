//
//  Pinger.swift
//  Network Monitor
//
//  Created by HCorbucc on 10/20/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

import Foundation

class Pinger: NSObject {
    let ipAddress : NSString
    let timeout : Int
    init(ipAddress: NSString, timeout: Int) {
        self.ipAddress = ipAddress
        self.timeout = timeout
    }
    func ping() -> Bool {
        let pingTask = NSTask()
        pingTask.launchPath = "/sbin/ping"
        pingTask.arguments = ["-t", timeout.description, "-o", ipAddress.description]
        pingTask.launch()
        pingTask.waitUntilExit()
        return pingTask.terminationStatus == 0
    }
}