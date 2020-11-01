//
//  Domain.swift
//  CryptoSwift-iOS11.0
//
//  Created by Nadezhda Nikolova on 12/20/17.
//

///  Domain that keeps translations. Every domain is unique,
///  but 2 domains can contain same translations.
struct Domain: Codable {
    /// Name of the specific domain
    let name: String
    /// Last version of the locale
    let version: Int64?
    ///    Translation strings separated in contexts.
    ///    Each context has it's own key-value pair collection.
    ///    But for mobile we are flating them up to simple key value pairs
    ///    there should be no duplicate keys.
    let translations: [String: [String: String]]?
    
    enum CodingKeys: String, CodingKey {
        case name = "domain_id"
        case version
        case translations
    }
}
