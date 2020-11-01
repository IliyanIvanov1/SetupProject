//
//  Networker.swift
//  NetworkKit
//
//  Created by Plamen Penchev on 4.09.18.
//

import Foundation
import Alamofire

public class Networker: NetworkingInterface {
    
    let networkReachabilityManager = NetworkReachabilityManager()
    private var sessionManager: Session?
    
    weak public var delegate: ReachabilityProtocol?
    
    public func send(request: APIRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        if let sessionManager = sessionManager {
            sessionManager.request(request.asUrlRequest()).response { (response) in
                completion(response.data, response.response, response.error)
            }
        } else {
            AF.request(request.asUrlRequest()).response { (response) in
                completion(response.data, response.response, response.error)
            }
        }
    }
    
    public func isConnectedToInternet() -> Bool {
        // swiftlint:disable:next force_unwrapping
        return (networkReachabilityManager?.isReachable)!
    }
    
    public func startNetworkReachabilityObserver() {
        // Fire initial status
        delegate?.didChangeReachabilityStatus(isReachable: isConnectedToInternet())
        
        // Observe changes
        networkReachabilityManager?.startListening(onUpdatePerforming: { [weak self] listenerStatus in
            guard let strongSelf = self else { return }
            
            switch listenerStatus {
            case .notReachable:
                strongSelf.delegate?.didChangeReachabilityStatus(isReachable: false)
            case .unknown :
                strongSelf.delegate?.didChangeReachabilityStatus(isReachable: false)
            case .reachable(.ethernetOrWiFi):
                strongSelf.delegate?.didChangeReachabilityStatus(isReachable: true)
            case .reachable(.cellular):
                strongSelf.delegate?.didChangeReachabilityStatus(isReachable: true)
            }
        })
    }
    
    public func configureWith(serverTrustPolicies: APITrustPolicies) {
        guard !serverTrustPolicies.isEmpty else { return }
        
        var serverTrustPolicy: [String: ServerTrustEvaluating] = [:]
        serverTrustPolicies.forEach { (domain, policy) in
            switch policy {
            case .none:
                serverTrustPolicy[domain] = DisabledEvaluator()
                // Usually this is project specific, but the following configuration should work in 99% of the cases.
                // Make sure host and default validaiton are always true (full validation of the chain and the host)
                // unless you integrate some strange demo environment.
                // Sometimes you may encounter APIs with self signed certificates (usually on demo env again)
                // then make sure to pass true as the evaluator's acceptSelfSignedCertificates parameter.
            case .pinPublicKeys:
                serverTrustPolicy[domain] = PublicKeysTrustEvaluator(keys: Bundle.main.af.publicKeys,
                                                                     performDefaultValidation: true,
                                                                     validateHost: true)
            case .pinCertificates:
                serverTrustPolicy[domain] = PinnedCertificatesTrustEvaluator(certificates: Bundle.main.af.certificates,
                                                                             acceptSelfSignedCertificates: false,
                                                                             performDefaultValidation: true,
                                                                             validateHost: true)
            }
        }
        
        sessionManager = Session(configuration: URLSessionConfiguration.default,
                                        serverTrustManager: ServerTrustManager(evaluators: serverTrustPolicy))
    }
}

public protocol ReachabilityProtocol: class {
    func didChangeReachabilityStatus(isReachable: Bool)
}
