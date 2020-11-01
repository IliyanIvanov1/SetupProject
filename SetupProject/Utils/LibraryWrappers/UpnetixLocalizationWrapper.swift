//
//  UpnetixLocalizationWrapper.swift
//  Skeleton
//
//  Created by Martin Vasilev on 15.11.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import Foundation
import UpnetixLocalizer

class LocalizationWrapper {
    
    /// Configure UpnetixLocalizer/Other Localizer
    ///
    /// - Parameters:
    ///   - baseUrl: The url for the localizations
    ///   - secret: The secret to access the localizations
    ///   - appId: The appId of the current application
    ///   - domains: The domains for the localizations
    static func configure(baseUrl: String, secret: String, appId: String, domains: [String]) {
        // Locallizer
        Localizer.shared.initialize(locale: Locale(identifier: "en-GB"),
                                    enableLogging: true,
                                    defaultLoggingReturn: .key)
    }
    
    static func didEnterBackground() {
        Localizer.shared.didEnterBackground()
    }
    
    static func willEnterForeground() {
        Localizer.shared.willEnterForeground()
    }
    
    static func willTerminate() {
        Localizer.shared.willTerminate()
    }
    
    static func getCurrentLocale() -> Locale {
        return Localizer.shared.getCurrentLocale()
    }
    
    static func getAllLanguages(callback: @escaping ([Language], String?) -> Void) {
        Localizer.shared.getAvailableLocales(withCompletion: callback)
    }
    
    static func updateLanguage(locale: Locale, changeCallback: ((_: Bool, _ :Locale) -> Void)? = nil) {
        Localizer.shared.changeLocale(desiredLocale: locale, changeCallback: changeCallback)
    }
}

extension String {
    /// Helpful function to access the localization from everywhere
    ///
    /// - Returns: The value in the localizations
    var localized: String {
        guard let firstDomain = Constants.Localizer.domains.first else { return self }
        return Localizer.shared.getString(key: "\(firstDomain).\(self)").replacingOccurrences(of: "$s", with: "$@")
    }
}
