//
//  Localizer.swift
//  Localizations
//
//  Created by Пламен Великов on 3/2/17.
//  Copyright © 2017 Пламен Великов. All rights reserved.
//

import Foundation

public class Localizer {
    public enum DefaultReturnBehavior {
        case empty
        case key
        case custom(String)
    }
    
    public static let shared = Localizer()
    public static let version = "2.1.2"
    public private(set) var defaultLocaleFileName = "en-GB"
    public typealias ChangeLocaleCallback = (_ success: Bool, _ currentLocale: Locale) -> Void
    
    internal var domainKeeper: [DomainKeeper] = []
    
    private var currentLocale: Locale!
    private var defaultReturn: DefaultReturnBehavior = .empty
    private var localeTranslations: LocaleTranslations?
    private var updateService: UpdateLocaleService?
    private var localesContractor: LocalesContractor?
    private var updateTranslationsScheme: UpdateTranslationsScheme?
    private var translations: [String: String] = [:]
    private let concurrentQueue = DispatchQueue(label: "concurrentQueue", qos: .userInteractive, attributes: .concurrent)
    
    // Synchronizing the access to the translations since it may appear
    // simultaneously from multiple threads
    public var threadSafeTranslations: [String: String] {
        get {
            return concurrentQueue.sync { [unowned self] in
                self.translations ?? [:]
            }
        }
        set {
            concurrentQueue.async(flags: .barrier) { [unowned self] in
                self.translations = newValue
            }
        }
    }

    private init() { }
    
    // MARK: Public methods
    
    /// Initialization of Localizer. This method should be called as early as possible.
    ///
    /// - Parameters:
    ///   - locale: the current device locale.
    ///   - enableLogging: enabled if true.
    ///   - defaultReturn: desired behavior when no key found. Empty by default.
    ///   - completed: an optional callback when initialization process has finished.
    public func initialize(locale: Locale,
                           enableLogging: Bool = false,
                           defaultLoggingReturn: DefaultReturnBehavior = .empty,
                           completed: (() -> Void)? = nil) {
        
        
        // enable or disable logger - by default it's disabled
        Logger.enableLogging = enableLogging
        
        // Return behavior when the key passed is not found
        self.defaultReturn = defaultLoggingReturn
        
        // Setting locale to init locale - this doesn't mean that parsing is successful
        currentLocale = locale
        
        //TODO: Maybe we should have logic to update backup files?
        DispatchQueue.global(qos: .background).sync {
            LocaleFileHandler.initialCopyOfLocaleFiles()
        }
        
        let configuration = readConfigurationFile()
        
        if configuration.baseUrl.isEmpty {
            Logger.log(messageFormat: Constants.Localizer.emptyBaseUrlError)
        }
        
        var allDomains: [Domain] = []
        let requestErrorHandler = RequestErrorHandler()
        
        updateService = UpdateLocaleService(configuration: configuration, requestErrorHandler: requestErrorHandler)
        localesContractor = LocalesContractor(configuration: configuration, requestErrorHandler: requestErrorHandler)
        
        let fileName = localeFileName(locale: locale)
        
        // logic for every domain
        for domain in configuration.domains {
            
            if domain.isEmpty {
                Logger.log(messageFormat: Constants.Localizer.emptyDomainError)
            }
            
            // TODO: not sure if this should be here ->
            setValueToDefaultLocale(domain: domain)
            
            // Note: operation should be syncronized because this is the first reading
            DispatchQueue.global(qos: .background).sync { [unowned self] in
                self.handleLocale(fileName: fileName, domain: domain)
                
                let currentDomain = Domain(name: domain, version: self.localeTranslations?.version, translations: nil)
                allDomains.append(currentDomain)
                
                let domainKeep = DomainKeeper(name: domain, translations: self.localeTranslations?.translations)
                self.domainKeeper.append(domainKeep)
                
                DispatchQueue.main.async {
                    completed?()
                }
            }
        }
        
        if let localeTranslations = localeTranslations {
            updateTranslationsScheme = UpdateTranslationsScheme(appId: localeTranslations.appId, locale: localeTranslations.locale, domains: allDomains, updateInterval: nil, warnings: nil)
            
            // Note: Start/Restart update service
            updateService?.startUpdateService(scheme: updateTranslationsScheme)
        }
    }
    
    /**
     Gets current locale for the Localizer
     - returns: Locale value representing current Locale
     */
    public func getCurrentLocale() -> Locale {
        return currentLocale
    }
    
    /**
     Retreives value from a key-value collection
     - parameter key: domain id + key of the string
     - returns: string value representing the value for the requested key
     - usage: Localizer.shared.getString(key: "domainName.stringKey")
     */
    public func getString(key: String) -> String {
        guard let value = threadSafeTranslations[key] else {
            switch defaultReturn {
            case .empty:
                return ""
            case .key:
                return key
            case .custom(let customString):
                return customString
            }
        }
        return value
    }
    
    /**
     Function which change loaded translations with those for the passed as argument Locale.
     This is to force reading another locale file.
     - parameter desiredLocale: locale instance
     - parameter changeCallback: callback when change of locale is completed no matter if it was successfull
     */
    public func changeLocale(desiredLocale: Locale, changeCallback: ChangeLocaleCallback? = nil) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            
            let fileName = strongSelf.localeFileName(locale: desiredLocale)
            
            strongSelf.threadSafeTranslations = [:]
            strongSelf.updateTranslationsScheme?.domains = []
            
            for (index, domain) in strongSelf.domainKeeper.enumerated() {
                let success = strongSelf.handleLocale(fileName: fileName, domain: domain.name)
                
                if success {
                    // Note: change current locale
                    strongSelf.currentLocale = desiredLocale
                    strongSelf.updateTranslationsScheme?.locale = strongSelf.currentLocale.identifier
                    let currentDomain = Domain(name: domain.name, version: strongSelf.localeTranslations?.version, translations: nil)
                    strongSelf.updateTranslationsScheme?.domains.append(currentDomain)
                    strongSelf.domainKeeper[index] = DomainKeeper(name: domain.name, translations: strongSelf.localeTranslations?.translations)
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    changeCallback?(success, strongSelf.currentLocale)
                }
            }
            // Note Start/Restart update service
            strongSelf.updateService?.startUpdateService(scheme: strongSelf.updateTranslationsScheme)
        }
    }
    
    /// Function that retreives available locales.
    ///
    /// - Parameter completion that returns:
    /// Array of languages of supported locales
    /// Error that describe if we have issue in getting available locales
    public func getAvailableLocales(withCompletion completion: @escaping (_ languages: [Language], _ error: String?) -> Void) {
        guard let localesContractor = localesContractor else {
            completion([], Constants.LocalesContractor.errorLoadingLocalesContractor)
            return
        }
        
        localesContractor.getLocales { languages in
            if languages.count == 0 {
                completion(localesContractor.getStoredLocales(), Constants.LocalesContractor.errorRequestForGetLocales)
                return
            }
            completion(languages, nil)
        }
    }
    
    /**
     Method for keep track with Application Lifecycle and more specifically when tha application will enter background.
     Should be called inside Application Lifecycle method didEnterBackground
     */
    public func didEnterBackground() {
        updateService?.stopUpdateService()
    }
    
    /**
     Method for keep track with Application Lifecycle and more specifically when tha application will enter foreground.
     Should be called inside Application Lifecycle method willEnterForeground.
     */
    public func willEnterForeground() {
        // TODO: this shouldnt be here. It's not working correctly
        updateService?.startUpdateService(scheme: updateTranslationsScheme)
    }
    
    /**
     Method for keep track with Application Lifecycle and more specifically when tha application will be terminated.
     Should be called inside Application Lifecycle method willTerminate
     */
    public func willTerminate() {
        updateService?.stopUpdateService()
    }
    
    // MARK: Private methods
    
    /**
     Handle Locale file parsing.
     
     - parameter fileName: Locale file name
     
     - returns: true if parsing was successful, false otherwise.
     
     */
    @discardableResult  // TODO: Check if we really need this discardableResult
    private func handleLocale(fileName: String, domain: String) -> Bool {
        // 1. Read default locale file to string
        let localeFileContent = LocaleFileHandler.readLocaleFile(filename: fileName, domain: domain)
        let fileContent: Data
        // TODO: test all of this logic with backup files.
        if localeFileContent.isEmpty {
            fileContent = LocaleFileHandler.readBackupFile(filename: fileName, domain: domain)
//            fileContent = LocaleFileHandler.readBackupFile(filename: defaultLocaleFileName, domain: domain)
//            currentLocale = Locale(identifier: defaultLocaleFileName)
        } else {
            fileContent = localeFileContent
        }
        
        if fileContent.isEmpty {
            Logger.log(messageFormat: Constants.Localizer.emptyLocaleFileError, args: [fileName])
            return false
        }
        
        // 2. Parse transalations to Locale
        localeTranslations = LocaleTranslations.parseLocaleTranslations(jsonData: fileContent, localeFile: fileName)
        
        // store translations for every domain in one place
        if let translations = localeTranslations?.translations {
            storeTranslationsForAllDomains(translations: translations)
        }
        
        return !(localeTranslations?.translations.isEmpty ?? false)
    }
    
    /**
     Try get default locale from config.json and
     set value to defaultLocaleFileName.
     If we fail in getting default locale ->  defaultLocaleFileName remains "en-GB"
     */
    private func setValueToDefaultLocale(domain: String) {
        do {
            let data = LocaleFileHandler.readLocaleFile(filename: "config", domain: domain)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([String: String].self, from: data)
            if let defaultLocale = jsonData["default_locale"] {
                defaultLocaleFileName = defaultLocale
            }
        } catch let error {
            Logger.log(messageFormat: error.localizedDescription)
        }
    }
    
    /**
     Store Translations For All Domains.
     - parameter translations: contain translations we should store in our dictionary
     - this function store all translations in translations dictionary
     */
    private func storeTranslationsForAllDomains(translations: [String : String]) {
        for translation in translations {
            threadSafeTranslations[translation.key] = translation.value
        }
    }
    
    // TODO: this shouldn't be here and add description
    private func readConfigurationFile() -> Configuration {
        var configuration = Configuration(baseUrl: "", secret: "", appId: "", domains: [])
        
        let decoder = JSONDecoder()
        do {
            let configFileData = LocaleFileHandler.readLocaleFile(filename: Constants.Localizer.configFileName)
            configuration = try decoder.decode(Configuration.self, from: configFileData)
            Logger.log(messageFormat: Constants.Localizer.configurationFile, args: [configuration.getParamsAsString()])
        } catch {
            Logger.log(messageFormat: Constants.Localizer.errorReadingConfigFile)
        }
        
        return configuration
    }
    
    // TODO: maybe this could be extension and description should be added
    private func localeFileName(locale: Locale) -> String {
        guard let languageCode = locale.languageCode else {
            Logger.log(messageFormat: Constants.Localizer.changeLocaleMissingLanguageCodeError)
            return defaultLocaleFileName
        }
        
        var localeFileName = languageCode
        
        if let country = locale.regionCode {
            
            localeFileName = localeFileName + "-" + country
        }
        
        return localeFileName
    }
    
    // TODO: add description here
    func updateLocaleTranslation(updated updatedTranslations: LocaleTranslations) {
        guard let currentLoadedLocale = self.localeTranslations,
            currentLoadedLocale.locale == updatedTranslations.locale else {
                Logger.log(messageFormat: Constants.Localizer.localeIsChangedBeforeFinishUpdate)
                return
        }
        
        localeTranslations?.version = updatedTranslations.version
        storeTranslationsForAllDomains(translations: updatedTranslations.translations)
    }
}
