//
//  UpdateLocaleService.swift
//  LocalizationTestApp
//
//  Created by Пламен Великов on 3/14/17.
//  Copyright © 2017 Пламен Великов. All rights reserved.
//

import Foundation

/**
  This service handles update locale translations at intervals. Handles saving the interval for next update
 */

class UpdateLocaleService: RequestExecutor {
    
    private static let defaultUpdateInterval = 600000
    
    private enum ServiceState {
        case stopped
        case running
    }
    
    var timer: DispatchSourceTimer?

    private var isCurrenlyUpdating: Bool = false
    private var serviceState: ServiceState = .stopped
    private var updateTaskQueue: UniqueQueue<UpdateTranslationsScheme> = UniqueQueue()
    
    func startUpdateService(scheme: UpdateTranslationsScheme?) {
        guard let scheme = scheme else {
            Logger.log(messageFormat: Constants.UpdateLocaleService.missingUpdateScheme)
            return
        }
        
        serviceState = .running
        stopUpdateTimer()
        
        if isCurrenlyUpdating {
            updateTaskQueue.insert(scheme)
            
            Logger.log(messageFormat: Constants.UpdateLocaleService.currentlyUpdatingMessage)
            return
        }
        
        startUpdateTimer(scheme: scheme)
    }
    
    func stopUpdateService() {
        serviceState = .stopped
        isCurrenlyUpdating = false
        updateTaskQueue.clearAllTasks()
        stopUpdateTimer()
    }
    
    private func startUpdateTimer(scheme: UpdateTranslationsScheme) {
        timer = DispatchSource.makeTimerSource()
        let intervalPeriod = DispatchTimeInterval.milliseconds(scheme.updateInterval ?? UpdateLocaleService.defaultUpdateInterval)
        timer?.schedule(deadline: .now(), repeating: intervalPeriod)
        timer?.setEventHandler(handler: { [weak self] in
            Logger.log(messageFormat: "Update \(scheme.locale)")
            self?.updateTranslationsRequest(scheme: scheme)
        })
        timer?.resume()
    }
    
    private func stopUpdateTimer() {
        timer?.cancel()
        timer = nil
    }
    
    private func updateTranslationsRequest(scheme: UpdateTranslationsScheme) {
        let updateRequestUrl = configuration.baseUrl + Constants.UpdateLocaleService.relativePath
        
        if let url = URL(string: updateRequestUrl) {
            isCurrenlyUpdating = true
            let dataForPostRequest = try? JSONEncoder().encode(scheme)
            
            self.execute(url: url, method: Method.post, data: dataForPostRequest) { [weak self] data in
                guard let strongSelf = self,
                    let data = data,
                    strongSelf.serviceState == .running else {
                        self?.updateFinished()
                        return
                }
                
                let decoder = JSONDecoder()
                do {
                    let decodedScheme = try decoder.decode(UpdateTranslationsScheme.self, from: data)
                    if !decodedScheme.domains.isEmpty {
                        strongSelf.updateLocaleTranslations(receivedScheme: decodedScheme)
                    } else {
                        Logger.log(messageFormat: Constants.UpdateLocaleService.emptyTranslations)
                    }
                } catch {
                    Logger.log(messageFormat: error.localizedDescription)
                }
                
                strongSelf.updateFinished()
            }
        } else {
            updateFinished()
            requestErrorHandler.handleRequestCreationError()
        }
    }
    
    // TODO: check this logic?!
    private func updateFinished() {
        isCurrenlyUpdating = false
        
        guard let shemeToUpdate = updateTaskQueue.poll() else {
            return
        }
        
        if let _ = updateTaskQueue.peek() {
            // We have pending update start the task immediately
            updateTranslationsRequest(scheme: shemeToUpdate)
        } else {
            // start service
            startUpdateService(scheme: shemeToUpdate)
        }
    }
    
    private func updateLocaleTranslations(receivedScheme: UpdateTranslationsScheme) {
        if let listOfWarnings = receivedScheme.warnings {
            for warning in listOfWarnings {
                Logger.log(messageFormat: warning)
            }
        }
        
        for domain in receivedScheme.domains {
            guard let newVersion = domain.version else {
                    Logger.log(messageFormat: Constants.UpdateLocaleService.emptyVersionFromBackend)
                    return
            }
            
            let translations = domain.translations ?? [:]
            let flattedTranslations = LocaleTranslations.flatTranslations(translations: translations, domain: domain.name)
            
            let localeTranslations = LocaleTranslations(domain: domain.name, appId: receivedScheme.appId, version: newVersion, locale: receivedScheme.locale, updateInterval: receivedScheme.updateInterval ?? UpdateLocaleService.defaultUpdateInterval, translations: flattedTranslations)
            
            // Note: Update in memory translations
            Localizer.shared.updateLocaleTranslation(updated: localeTranslations)
            
            let currentDomain = Localizer.shared.domainKeeper.first { $0.name == domain.name }
            guard var currentDomainTranslations = currentDomain?.translations else { return }
            
            for newTranslation in flattedTranslations {
                currentDomainTranslations[newTranslation.key] = newTranslation.value
            }
            
        let localeTranslationsToSave = LocaleTranslations(domain: domain.name, appId: receivedScheme.appId, version: newVersion, locale: receivedScheme.locale, updateInterval: receivedScheme.updateInterval ?? UpdateLocaleService.defaultUpdateInterval, translations: currentDomainTranslations)
            
            // Note: Update translations files for every domain
            if let updatedTranslationsData = LocaleTranslations.convertLocaleTranslationToData(localeTranslations: localeTranslationsToSave) {
                LocaleFileHandler.writeToFile(fileName: receivedScheme.locale,
                                              data: updatedTranslationsData, domain: domain.name, callback: { success in
                                                print("Successfully updated: \(success)")
                                                if !success {
                                                    Logger.log(messageFormat: Constants.UpdateLocaleService.couldNotUpdateTranslations)
                                                }
                })

            } else {
                Logger.log(messageFormat: Constants.UpdateLocaleService.couldNotUpdateTranslations)
            }
        }
    }
    
    deinit {
        stopUpdateService()
    }
}
