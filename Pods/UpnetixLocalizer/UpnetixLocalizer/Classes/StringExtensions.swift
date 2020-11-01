//
//  StringExtensions.swift
//  Localizations
//
//  Created by Nadezhda Nikolova on 11/23/17.
//  Copyright © 2017 Пламен Великов. All rights reserved.
//

extension String {
    var hashToSHA256: String {
        var hashedString = ""
        if let stringData = self.data(using: String.Encoding.utf8) {
            let digestedData = stringData.digest()
            // hexStringFromData:
            hashedString = digestedData.map { String(format: "%02hhx", $0) }.joined()
        }
        return hashedString
    }
}
