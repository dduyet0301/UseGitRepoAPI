//
//  GetData.swift
//  UseGithubAPI
//
//  Created by gem on 6/24/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GetData {
    func fetchData(callback: @escaping ([GitRepo]) -> Void ) {
        let limit = ViewController.limit
        let page = ViewController.page
        let sortContent = ViewController.sortContent
        let sortType = ViewController.sortType
        var arrRepo: [GitRepo] = []
         Alamofire.request("https://api.github.com/search/repositories?q=language:&per_page=\(limit)&page=\(page)&sort=\(sortContent)&order=\(sortType)", method: .get).responseJSON { (myResponse) in
            switch myResponse.result{
            case .success:
//                print(myResponse)
                do{
                let myresult = try JSON(data: myResponse.data!)
                    if let resultArray = myresult["items"].array{
                        arrRepo.removeAll()
                        for i in resultArray{
                            let name = i["name"].stringValue
                            let login = i["owner"]["login"].stringValue
                            let avatar_url = i["owner"]["avatar_url"].stringValue
                            let star = i["stargazers_count"].stringValue
                            let watch = i["watchers"].stringValue
                            let fork = i["forks"].stringValue
                            let issue = i["open_issues"].stringValue
                            let commit = i["updated_at"].stringValue
                            let url = i["html_url"].stringValue
                            let gitRepo = GitRepo.init(name: name, login: login, avatar_url: avatar_url, star: star, watch: watch, fork: fork, issue: issue, commit: commit, url: url, priv: "")
                            arrRepo.append(gitRepo)
                        }
                        callback(arrRepo)
                        Global.loadMore = true
                    }
                } catch {
                    debugPrint("error")
                }
            
                break
            case .failure:
                print(myResponse.error!)
                break
            }
        }
    }
    
    func fetchData2(callback: @escaping ([GitRepo],[GitRepo]) -> Void) {
        let header = [
            "Authorization" : "token " + Global.accessToken
        ]
        var arrUser: [GitRepo] = []
        var arrPrivate: [GitRepo] = []
        var arrPublic: [GitRepo] = []
        Alamofire.request("https://api.github.com/user/repos", method: .get, headers: header).responseJSON { (myResponse)
            in
            switch myResponse.result{
            case .success:
//                print(myResponse)
                do{
                    let myresult = try JSON(data: myResponse.data!)
                    if let resultArray = myresult.array{
                        arrUser.removeAll()
                        arrPrivate.removeAll()
                        arrPublic.removeAll()
                        for i in resultArray{
                            let priv = i["private"].stringValue
                            let userName = i["owner"]["login"].stringValue
                            let avatar = i["owner"]["avatar_url"].stringValue
                            let repoName = i["name"].stringValue
                            let star = i["stargazers_count"].stringValue
                            let watch = i["watchers_count"].stringValue
                            let fork = i["forks_count"].stringValue
                            let issue = i["open_issues_count"].stringValue
                            let commit = i["pushed_at"].stringValue
                            let gitUserRepo = GitRepo.init(name: repoName, login: userName, avatar_url: avatar, star: star, watch: watch, fork: fork, issue: issue, commit: commit, url: "", priv: priv)
                            arrUser.append(gitUserRepo)
                            if priv == "true" {
                                arrPrivate.append(gitUserRepo)
                            } else if priv == "false" {
                                arrPublic.append(gitUserRepo)
                            }
                        }
                        callback(arrPrivate, arrPublic)
                    }
                } catch {
                    debugPrint("error")
                }
                break
            case .failure:
                debugPrint(myResponse.error!)
                break
            }
        }
    }
}
