//
//  Language.swift
//  Localizations
//
//  Created by nikolay.prodanov on 10/30/17.
//  Copyright © 2017 Пламен Великов. All rights reserved.
//

import Foundation

public class Language: Codable {
    public let code: String
    public let name: String
    
    init(code: String, name: String) {
        self.code = code
        self.name = name
    }
}
