//
//  Logger.swift
//  LocalizationTestApp
//
//  Created by Пламен Великов on 3/14/17.
//  Copyright © 2017 Пламен Великов. All rights reserved.
//

import Foundation
class Logger {
    
    static var enableLogging = false
    
    static func log(messageFormat: String, args: [String] = [""]) {
        if !enableLogging {
            return
        }
        
        let message = String(format: messageFormat, arguments: args)
        print("Localizer: \(message)")
    }
}
