//
//  AlertCenter.swift
//  Network Monitor
//
//  Created by HCorbucc on 10/20/14.
//  Copyright (c) 2014 Hugo Corbucci. All rights reserved.
//

import Foundation

protocol AlertCenter {
    func announce(message: NSString)
}