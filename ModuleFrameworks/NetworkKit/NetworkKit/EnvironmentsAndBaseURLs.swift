//
//  Servers.swift
//  NetworkKit
//
//  Created by Valentin Kalchev on 31.05.18.
//  Copyright © 2018 Valentin Kalchev. All rights reserved.
//

import Foundation

public enum Environment: String {
    case dev, stage
    
    public var value: EnvironmentInterface {
        switch self {
        case .dev: return DevEnvironment()
        case .stage: return StageEnvironment()
        }
    }
    
    public static let allValues: [Environment] = [dev, stage]
}

public protocol EnvironmentInterface {
    var name: String {get set}
    var baseURLs: BaseURLs {get set}
    // Make sure certificates are added in the bundle if ssl pinning policies are added
    var serverTrustPolicies: APITrustPolicies { get set }
}

public typealias BaseURL = String
public protocol BaseURLs {
    var exampleUrl: BaseURL {get set}
}

public typealias APITrustPolicies = [String: NetworkServerTrustPolicy]
public enum NetworkServerTrustPolicy {
    case none
    case pinCertificates
    case pinPublicKeys
}

/*************************************/
// - MARK: Dev Environment
/*************************************/

struct DevEnvironment: EnvironmentInterface {
    var name = "Development"
    var baseURLs: BaseURLs = DevBaseURLs()
    var serverTrustPolicies: APITrustPolicies = [:]
    
    /*************************************/
    //  Example public key pinning:
    //
    //    var serverTrustPolicies: APITrustPolicies = [
    //        "tasks.upnetix.tech": .pinCertificates,
    //        "github.com": .pinPublicKeys
    //    ]
    //
    //   NOTE: Make sure you've included the certificate files within the main bundle under .der format.
    /*************************************/
}

struct DevBaseURLs: BaseURLs {
    var exampleUrl = "https://tasks.upnetix.tech/mobile/"
}

/*************************************/
// - MARK: Stage Environment
/*************************************/

struct StageEnvironment: EnvironmentInterface {
    var name = "Stage"
    var baseURLs: BaseURLs = StageBaseURLs()
    var serverTrustPolicies: APITrustPolicies = [:]
}

struct StageBaseURLs: BaseURLs {
    var exampleUrl = "https://tasks.upnetix.tech/mobile/"
}
