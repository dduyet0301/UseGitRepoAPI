//
//  Contains.swift
//  UseGithubAPI
//
//  Created by gem on 6/24/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation
import CoreData

class Contains {
    //public repo
    public static var arrRepo = [GitRepo]()
    //user repo
    public static var arrUser = [GitRepo]()
    public static var arrPublic = [GitRepo]()
    public static var arrPrivate = [GitRepo]()
    //user data
    public static var arrUserProfile = [GitRepo]()
    //token
    public static var accessToken = ""
    //cache User
    public static var cacheUser = Cache()
    //cache Public
    public static var cachePublic = CachePublic()
    
    public static var loadMore = true
}
