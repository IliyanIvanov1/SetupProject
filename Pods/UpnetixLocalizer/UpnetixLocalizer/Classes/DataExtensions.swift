//
//  DataExtensions.swift
//  Localizations
//
//  Created by Nadezhda Nikolova on 11/23/17.
//  Copyright © 2017 Пламен Великов. All rights reserved.
//

import CryptoSwift

extension Data {
    func digest() -> Data {
        return self.sha256()
    }
}
