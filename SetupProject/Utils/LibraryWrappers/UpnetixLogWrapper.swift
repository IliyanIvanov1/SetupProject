//
//  LoggerWrapper.swift
//  Skeleton
//
//  Created by Martin Vasilev on 13.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import SFLoggingKit

class Log {
    
    /// Configure the wrapepd loggingKit
    ///
    /// - Parameters:
    ///   - logLevel: The current log level
    ///   - shouldLogInBackgroundConsole: Determines if the logs should be visible in the attatched console
    static func configure(logLevel: SFLogLevel = .debug, shouldLogInBackgroundConsole: Bool = false) {
        SFLogger.shared.configure(logLevel: logLevel, shouldLogInBackgroundConsole: shouldLogInBackgroundConsole)
    }
    
    /// Log a basic debug message
    ///
    /// - Parameter message: The message
    static func debug(_ message: String) {
        SFLogger.shared.log("debug: \(message)", logLevel: .debug)
    }
    
    /// Log useful information or possibly live debug
    ///
    /// - Parameter message: The message
    static func info(_ message: String) {
        SFLogger.shared.log("Info: \(message)", logLevel: .info)
    }
    
    /// Log a warning or a small error
    ///
    /// - Parameter message: The message
    static func warning(_ message: String) {
        SFLogger.shared.log("Warning!: \(message)", logLevel: .warning)
    }
    
    /// Log an error (possibly attatch to crashlytics logs)
    ///
    /// - Parameter message: The message
    static func error(_ message: String) {
        SFLogger.shared.log("!!!ERROR!!!: \(message)", logLevel: .error)
    }
    
    /// Log a severe error/crash/some exception caught (possibly attatch to crashlytics logs)
    ///
    /// - Parameter message: The message
    static func severe(_ message: String) {
        SFLogger.shared.log("!!!!!SEVERE!!!!!: \(message)", logLevel: .severe)
    }
}
