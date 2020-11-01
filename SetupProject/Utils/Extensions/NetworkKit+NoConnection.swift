//
//  NetworkKit+NoConnection.swift
//  MLiTP
//
//  Created by Plamen Penchev on 22.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import NetworkKit
import UpnetixSystemAlertQueue

extension APIRequest {
    
    func executeWithHandling(handlesNoNetwork: Bool = true, handlesServerError: Bool = true, completion: @escaping ((Data?, HTTPURLResponse?, Error?) -> Void)) {
        execute { (data, response, error) in
            if handlesNoNetwork, (error as? ErrorsToThrow) == ErrorsToThrow.noInternet {
                // If something has to be shown when request is initiated without internet, do it here!
                completion(data, nil, error)
            } else if let response = response,
                !response.statusCode.isSuccess,
                handlesServerError {
                Log.error("ERROR in response: \(response.statusCode) for request \(self)")
                AlertFactoryManager.shared.presentRetryAlert(withMessage: "ERROR in response: \(response.statusCode) for request \(self)", title: "", retryBlock: {
                    self.executeWithHandling(handlesNoNetwork: handlesNoNetwork, handlesServerError: handlesServerError, completion: completion)
                })
            } else if let error = error, handlesServerError {
                AlertFactoryManager.shared.presentRetryAlert(withMessage: "ERROR: \(error) for request \(self)", title: "", retryBlock: {
                    self.executeWithHandling(handlesNoNetwork: handlesNoNetwork, handlesServerError: handlesServerError, completion: completion)
                })
                Log.error("ERROR: \(error) for request \(self)")
            } else {
                completion(data, response, error)
            }
        }
    }
    
    func executeParsedWithHandling<T: Codable>(of type: T.Type,
                                               handlesNoNetwork: Bool = true,
                                               handlesServerError: Bool = true,
                                               completion: @escaping ((T?, HTTPURLResponse?, Error?) -> Void)) {
        executeParsed(of: T.self) { (retrievedData, urlResponse, error) in
            if handlesNoNetwork, (error as? ErrorsToThrow) == ErrorsToThrow.noInternet {
                // If something has to be shown when request is initiated without internet, do it here!
                completion(retrievedData, nil, error)
            } else if let response = urlResponse,
                !response.statusCode.isSuccess,
                handlesServerError {
                Log.error("ERROR in response: \(response.statusCode) for request \(self)")
                AlertFactoryManager.shared.presentRetryAlert(withMessage: "ERROR in response: \(response.statusCode) for request \(self)", title: "", retryBlock: {
                    self.executeParsedWithHandling(of: type, handlesNoNetwork: handlesNoNetwork, handlesServerError: handlesServerError, completion: completion)
                })
            } else if handlesServerError, let error = error {
                AlertFactoryManager.shared.presentRetryAlert(withMessage: "ERROR: \(error) for request \(self)", title: "", retryBlock: {
                    self.executeParsedWithHandling(of: type, handlesNoNetwork: handlesNoNetwork, handlesServerError: handlesServerError, completion: completion)
                })
                Log.error("ERROR: \(error) for request \(self)")
            } else {
                completion(retrievedData, urlResponse, error)
            }
        }
    }
    
}
