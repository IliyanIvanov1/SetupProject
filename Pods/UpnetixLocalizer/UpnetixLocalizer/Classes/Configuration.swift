//
//  Configuration.swift
//  Localizations
//
//  Created by Nadezhda Nikolova on 11/21/17.
//  Copyright © 2017 Пламен Великов. All rights reserved.
//

import UIKit

/// Configuration object is used for passing project specific information like base url,
/// secret and appId.
/// JSON for this object is generated in localizer_download.sh
///
/// - baseUrl: the strings provider service URL
/// - secret: used for authentication for calls to the library
/// - app_id: the identifier of the application, should be unique for your app
/// - domains: array of strings that contains all domains id-s

struct Configuration: Codable {
    let baseUrl: String
    let secret: String
    let appId: String
    let domains: [String]
    
    func getParamsAsString() -> String {
        return """
        BaseUrl: \(baseUrl),
        Secret: \(secret),
        AppId: \(appId),
        Domains: \(domains.joined(separator: ","))
        """
    }
}
