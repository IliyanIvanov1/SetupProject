//
//  ExampleAPIRequest.swift
//  NetworkKit
//
//  Created by Martin Vasilev on 13.11.18.
//

import Foundation

public class ExampleApiRequest: BaseAPIRequest {
    override public var httpMethod: HTTPMethod {
        return .get
    }
    
    override public var baseUrl: BaseURL {
        return APIManager.shared.baseURLs.exampleUrl
    }
    
    override public var path: String {
        return "movies-json.txt"
    }

    // The example doesn't use authorization or headers.. They are here to remind you
    // that you will have to use them in actual requests.
    override public var authorizationRequirement: AuthorizationRequirement {
        return .required
    }

    override public var headers: [String: String] {
        var dict: [String: String] = ["Content-Type": "application/json"]

//        if let token = APIManager.shared.authToken,
//            authorizationRequirement != .none {
//            dict["Authorization"] = "Bearer \(token)"
//        }

        return dict
    }
}
