//
//  UpdateTranslationsScheme.swift
//  Pods
//
//  Created by Nadezhda Nikolova on 12/21/17.
//

/**
 This class describes the scheme for updating translations
 
 - The scheme is the following:
 ````
 {
     "app_id": "string",
     "domains": [
         {
         "domain_id": "string",
         "translations": {},
         "version": 0
         }
     ],
     "locale": "string",
     "update_interval": 0,
     "warnings": [
        "string"
     ]
 }
 ````
 */
struct UpdateTranslationsScheme: Codable {
    /// The Unique Identifier of the application
    let appId: String
    /// Locale code
    var locale: String
    /// List of domains that keep translations
    var domains: [Domain]
    /// Update Interval in milliseconds
    let updateInterval: Int?
    /// Warnings list received in response from backend when updating locales
    let warnings: [String]?
    
    enum CodingKeys: String, CodingKey {
        case appId = "app_id"
        case domains
        case locale
        case updateInterval = "update_interval"
        case warnings
    }
}

// MARK: Equatable extension
extension UpdateTranslationsScheme: Equatable {
    static func == (left: UpdateTranslationsScheme, right: UpdateTranslationsScheme) -> Bool {
        return left.appId == right.appId
            && left.locale == right.locale
            && left.updateInterval == right.updateInterval
    }
}
