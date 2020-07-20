//
//  InternetCheck.swift
//  UseGithubAPI
//
//  Created by gem on 7/2/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation
import Alamofire

class InternetCheck {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
