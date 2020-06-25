//
//  GitRepo.swift
//  UseGithubAPI
//
//  Created by gem on 6/24/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation

struct GitRepo: Decodable {
    var name: String
    var login: String
    var avatar_url: String
    var star: String
    var watch: String
    var fork: String
    var issue: String
    var commit: String
    var url: String
    
    init(name: String, login: String, avatar_url: String, star:String, watch:String, fork:String, issue:String, commit:String, url:String) {
        self.name = name
        self.login = login
        self.avatar_url = avatar_url
        self.star = star
        self.watch = watch
        self.fork = fork
        self.issue = issue
        self.commit = commit
        self.url = url
    }
}
