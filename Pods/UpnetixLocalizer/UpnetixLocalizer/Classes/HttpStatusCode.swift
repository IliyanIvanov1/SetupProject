//
//  HttpStatusCode.swift
//  Albtelecom
//
//  Created by Пламен Великов on 11/16/16.
//  Copyright © 2016 Пламен Великов. All rights reserved.
//

import Foundation

enum HttpStatusCode: Int {
    case ok = 200
    case noContent = 204
    case multipleChoises = 300
    case invalidTokenError = 401
}
