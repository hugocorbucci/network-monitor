//
//  Monitor.swift
//  Network Monitor
//
//  Created by HCorbucc on 10/20/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

import Foundation
import Cocoa

class Monitor: NSObject {
    enum Alerts : NSString {
        case Sound = "Sound Alert"
        case Notification = "Notifications"
        case Logger = "Logs"
    }
    enum State : NSString {
        case Connected = "connected"
        case Disconnected = "disconnected"
        case Unknown = "unknown"
    }
    
    let sleepInterval : Double = 5
    let background : NSThread!
    let alerts : [Alerts: AlertCenter] = [
        Alerts.Sound: Speaker(),
        Alerts.Notification: Notifier(),
        Alerts.Logger: Logger()
    ]
    let messages : [State: NSString] = [
        State.Connected : NSLocalizedString("connected_message", comment: "Message shown/said when user is connected to the Internet"),
        State.Disconnected : NSLocalizedString("disconnected_message", comment: "Message shown/said when user is NOT connected to the Internet"),
        State.Unknown: NSLocalizedString("unknown_state_message", comment: "Message shown/said when we don't know what the status of the connection is")
    ]
    let itemToUpdate : NSStatusItem!
    var enabledAlerts : [Alerts: AlertCenter]
    var pinger: Pinger!
    
    init(ipAddress: NSString, item: NSStatusItem) {
        enabledAlerts = Dictionary()
        super.init()
        let timeout = 5;
        itemToUpdate = item;
        background = NSThread(target:self, selector: "monitor", object: nil)
        pinger = Pinger(ipAddress: ipAddress, timeout: timeout)
        enabledAlerts[Alerts.Notification] = alerts[Alerts.Notification]
        enabledAlerts[Alerts.Logger] = alerts[Alerts.Logger]
        updateItemToState(State.Unknown);
    }
    func start() {
        background.start()
    }
    func setNotificationsEnabled(enabled: Bool) {
        self.updateEnabledAlerts(Alerts.Notification, status: enabled);
    }
    func setSoundAlertsEnabled(enabled: Bool) {
        self.updateEnabledAlerts(Alerts.Sound, status: enabled);
    }
    func monitor() {
        while (true)
        {
            let successful = pinger.ping()
            let state = successful ? State.Connected : State.Disconnected
            if (updateItemToState(state)) {
                for (alertType, alert) in enabledAlerts {
                    alert.announce(messages[state]!)
                }
            }
            NSThread.sleepForTimeInterval(sleepInterval)
        }
    }
    private
    func updateEnabledAlerts(alert: Alerts, status: Bool) {
        enabledAlerts[alert] = status ? alerts[alert] : nil
        NSLog("%@ are now %@", alert.rawValue, status ? "enabled" : "disabled");
        
    }
    func updateItemToState(state: State) -> Bool {
        let desired = NSImage(named: state.rawValue)
        if (itemToUpdate.image !== desired) {
            itemToUpdate.image = desired
            itemToUpdate.toolTip = messages[state]
            return true
        } else {
            return false
        }
    }
}