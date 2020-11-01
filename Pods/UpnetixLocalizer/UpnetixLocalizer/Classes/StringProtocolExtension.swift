//
//  StringProtocolExtension.swift
//  UpnetixLocalizer
//
//  Created by Nadezhda on 16.04.19.
//

extension StringProtocol where Index == String.Index {
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
}
