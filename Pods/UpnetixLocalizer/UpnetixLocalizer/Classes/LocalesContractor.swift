//
//  LocalesContractor.swift
//  Localizations
//
//  Created by nikolay.prodanov on 10/31/17.
//  Copyright © 2017 Пламен Великов. All rights reserved.
//

import Foundation

class LocalesContractor: RequestExecutor {
    
    func getLocales(completion: @escaping ([Language]) -> Void) {
        
        guard let index = configuration.baseUrl.index(of: Constants.LocalesContractor.localizationsPath) else {
            completion([])
            return
        }
        let baseUrl = String(configuration.baseUrl[..<index])
        let getLocalesUrl = baseUrl + Constants.LocalesContractor.relativePath + "?app_id=\(configuration.appId)"

        if let url = URL(string: getLocalesUrl) {
            self.execute(url: url, method: Method.get, data: nil) { [weak self] data in
                guard let strongSelf = self else {
                    completion([])
                    return
                }
                
                let languages = strongSelf.parseLanguagesResponse(data: data)
                completion(languages)
                strongSelf.storeLocales(languages: languages)
            }
        } else {
            requestErrorHandler.handleRequestCreationError()
            completion([])
        }
    }
    
    func getStoredLocales()-> [Language] {
        if let locales = UserDefaults.standard.data(forKey: "AvailableLanguages"),
            let localesArr = try? JSONDecoder().decode([Language].self, from: locales) {
            return localesArr
        }
        
        return []
    }
    
    private func parseLanguagesResponse(data: Data?) -> [Language] {
        guard let data = data else { return [] }
        
        let jsonDecoder = JSONDecoder()
        let languages = try? jsonDecoder.decode([Language].self, from: data)
        
        return languages ?? []
    }
    
    private func storeLocales(languages: [Language]) {
        let allLanguages = try? JSONEncoder().encode(languages)
        UserDefaults.standard.set(allLanguages, forKey: "AvailableLanguages")
    }
}
