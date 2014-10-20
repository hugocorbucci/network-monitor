//
//  Notifier.swift
//  Network Monitor
//
//  Created by HCorbucc on 10/20/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

import Foundation

class Notifier: AlertCenter {
    let center : NSUserNotificationCenter
    init() {
        center = NSUserNotificationCenter.defaultUserNotificationCenter()
    }
    func announce(message: NSString) {
        let notification = NSUserNotification()
        notification.title = NSLocalizedString("AppName", comment: "The app name for notification center title")
        notification.informativeText = message
        
        center.deliverNotification(notification)
    }
}