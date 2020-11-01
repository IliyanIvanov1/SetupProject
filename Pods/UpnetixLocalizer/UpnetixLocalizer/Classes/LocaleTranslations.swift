//
//  LocaleTranslations.swift
//  Localizations
//
//  Created by Пламен Великов on 3/9/17.
//  Copyright © 2017 Пламен Великов. All rights reserved.
//

import Foundation

/**
 This class describes the Locale scheme
 
 - The scheme is the following:
 ````
 {
     "domain_id":"Common",
     "app_id": "Localizer",
     "version": 1,
     "locale": "en",
     "update_interval": 600000,
     "translations": {
         "context_one": {
            "str_name": "name"
         },
         "context_two": {
            "str_age": "age"
         }
     }
 }
 ````
 */
struct LocaleTranslations {
    /**
     Domain Id - we have many domains.
     Every one is unique, but 2 domains can contain same translations.
     */
    let domain: String
    /**
     The Unique Identifier of the application
     */
    let appId: String
    
    /**
     Version of the locale
     */
    var version: Int64
    
    /**
     Locale code
     */
    let locale: String
    
    /**
     Update Interval in milliseconds
     */
    var updateInterval: Int
    
    /**
     Translation strings separated in contexts.
     Each context has it's own key-value pair collection.
     But for mobile we are flating them up to simple key value pairs
     there should be no duplicate keys.
     */
    var translations: [String: String]
    
    static func parseFromJson(json: [String: Any]?) -> LocaleTranslations? {
        guard let json = json,
            let domain = json["domain_id"] as? String,
            let appId = json["app_id"] as? String,
            let version = json["version"] as? Int64,
            let locale = json["locale"] as? String,
            let updateInterval = json["update_interval"] as? Int else {
                return nil
        }
        
        var flattenedTranslations: [String: String] = [:]
        
        if let translations = json["translations"] as? [String: [String: String]] {
            flattenedTranslations = flatTranslations(translations: translations, domain: domain)
        } else if let translations = json["translations"] as? [String: String] {
            flattenedTranslations = translations
        }
        
        return LocaleTranslations(domain: domain, appId: appId, version: version, locale: locale, updateInterval: updateInterval, translations: flattenedTranslations)
    }
    
    static func flatTranslations(translations: [String: [String:String]], domain: String) -> [String: String] {
        var combinedTranslations: [String: String] = [:]
        
        translations.forEach { (_, contextTranslations) in
            contextTranslations.forEach({ (key, translation) in
                combinedTranslations["\(domain).\(key)"] = translation
            })
        }
        return combinedTranslations
    }
    
    func convertToDictionary() -> [String: AnyObject] {
        var jsonRepresentation: [String: AnyObject] = [:]
        
        jsonRepresentation["domain_id"] = domain as AnyObject
        jsonRepresentation["app_id"] = appId as AnyObject
        jsonRepresentation["version"] = version as AnyObject
        jsonRepresentation["locale"] = locale as AnyObject
        jsonRepresentation["update_interval"] = updateInterval as AnyObject
        jsonRepresentation["translations"] = translations as AnyObject
        
        return jsonRepresentation
    }
}

// MARK: Converting extension
extension LocaleTranslations {
    
    // MARK: Parsing error messages
    private static let parsingLocaleFileError = "Error occured while parsing %@ locale file"
    
    static func convertLocaleTranslationToData(localeTranslations: LocaleTranslations?) -> Data? {
        guard let localeTranslations = localeTranslations else { return nil }
        
        let jsonRepresentation = localeTranslations.convertToDictionary()
        
        var data: Data? = nil
        do {
            data = try JSONSerialization.data(withJSONObject: jsonRepresentation)
        } catch (_) {
            Logger.log(messageFormat: LocaleTranslations.parsingLocaleFileError)
        }
        return data
    }
    
    static func parseLocaleTranslations(jsonData: Data, localeFile: String) -> LocaleTranslations? {
        guard !jsonData.isEmpty else {
            return nil
        }
        
        var translations: LocaleTranslations? = nil
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            translations = LocaleTranslations.parseFromJson(json: json)
        } catch (_) {
            Logger.log(messageFormat: LocaleTranslations.parsingLocaleFileError, args: [localeFile])
        }
        
        return translations
    }
}

// MARK: Equatable extension
extension LocaleTranslations: Equatable {
    
    static func == (left: LocaleTranslations, right: LocaleTranslations) -> Bool {
        return left.domain == right.domain
            && left.appId == right.appId
            && left.version == right.version
            && left.translations == right.translations
            && left.locale == right.locale
            && left.updateInterval == right.updateInterval
    }
}
