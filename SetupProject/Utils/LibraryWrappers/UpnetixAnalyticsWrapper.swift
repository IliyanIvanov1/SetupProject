//
//  UpnetixAnalyticsWrapper.swift
//  Skeleton
//
//  Created by Martin Vasilev on 14.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

class Analytics {
    
    /// Fires an event to the respective added dependancy (firebase/adobe/whatever)
    ///
    /// - Parameters:
    ///   - eventName: The name/id of the event
    ///   - eventArgs: The arguments dictionary passed to the event if needed
    static func fireEvent(_ eventName: String, eventArgs: [String: Any]? = nil) {
        // call dependancy
        Log.info("Event \(eventName) fired")
    }
}
