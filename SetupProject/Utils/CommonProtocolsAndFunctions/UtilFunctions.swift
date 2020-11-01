//
//  UtilFunctions.swift
//  Skeleton
//
//  Created by Martin Vasilev on 2.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import Foundation

/// Delay a closure and call it async on the main thread
///
/// - Parameters:
///   - delay: the delay time in seconds
///   - closure: the closure that is called after the delay
func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue
        .main
        .asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
                    execute: closure)
}
