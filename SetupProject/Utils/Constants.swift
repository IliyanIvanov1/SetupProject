//
//  Constants.swift
//  Skeleton
//
//  Created by Martin Vasilev on 15.11.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import UIKit

struct Constants {
    
    // Remember to write your own localizer properties here and in the runscript more info:
    // https://bitbucket.upnetix.com/projects/IL/repos/upnetix-localizer-pod/browse
    struct Localizer {
        static let baseUrl: String = "http://ext-localizer.imperiax.org/api/"
        static let secret: String = "b5befb61-c192-41fe-9d67-d9992fb3043e"
        static let appId: String = "TestFlex"
        // Important note for domains.. The localization wrapper uses ONLY the first domain currently
        // If for some reason you require more than than one domain you should change the localizer logic
        // I still don't see any reason for having more than 1 domain per application so.. \
        //The wrapper uses domains.first() ONLY!!!
        static let domains: [String] = ["Common"]
    }
}
