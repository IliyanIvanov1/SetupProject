//
//  RequestExecutor.swift
//  Localizations
//
//  Created by Nadezhda Nikolova on 11/24/17.
//  Copyright © 2017 Пламен Великов. All rights reserved.
//

class RequestExecutor {
    let configuration: Configuration
    let requestErrorHandler: RequestErrorHandler
    
    init(configuration: Configuration, requestErrorHandler: RequestErrorHandler) {
        self.configuration = configuration
        self.requestErrorHandler = requestErrorHandler
    }
    
    func execute(url: URL, method: Method, data: Data?, callback: @escaping (Data?) -> Void) {
        var request =  URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        request.httpMethod = method.rawValue
        
        // Authorization
        let appNameAndSalt = configuration.appId + configuration.secret
        let authorizationValue = appNameAndSalt.hashToSHA256
        request.addValue(authorizationValue, forHTTPHeaderField: "X-Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Logger.log(messageFormat: "Your Hashed Value: \(authorizationValue)")
        request.httpBody = data
            
        let session = URLSession.shared
        let updateTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let strongSelf = self else {
                callback(nil)
                return
            }
            
            if strongSelf.requestErrorHandler.handleError(response: response, error: error) {
                callback(data)
            } else {
                callback(nil)
            }
        }
        updateTask.resume()
    }
}

enum Method: String {
    case get = "GET"
    case post = "POST"
}
