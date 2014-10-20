//
//  AppDelegate.swift
//  Network Monitor
//
//  Created by HCorbucc on 10/20/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet var statusMenu: NSMenu!
    var statusItem: NSStatusItem!
    var monitor: Monitor!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let bar = NSStatusBar.systemStatusBar()
        statusItem = bar.statusItemWithLength(-1) // Used to be CGFloat(NSVariableStatusItemLength)
        statusItem.menu = statusMenu
        statusItem.highlightMode = true
        
        monitor = Monitor(ipAddress: "4.2.2.2", item: statusItem)
        monitor.start()
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        let bar = NSStatusBar.systemStatusBar()
        bar.removeStatusItem(statusItem)
    }
    @IBAction func toogleSound(sender: NSMenuItem) {
        sender.state = (sender.state ^ 1)
        monitor.setSoundAlertsEnabled(sender.state == 1)
        
    }
    @IBAction func toogleNotification(sender: NSMenuItem) {
        sender.state = (sender.state ^ 1)
        monitor.setNotificationsEnabled(sender.state == 1)
    }
}

