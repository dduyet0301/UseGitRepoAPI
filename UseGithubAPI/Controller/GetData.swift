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
    fileprivate var baseUrl = ""
    init(baseUrl:String) {
        self.baseUrl = baseUrl
    }
    
    func fetchData(endpoint: String, table: UITableView) {
        Alamofire.request(self.baseUrl + endpoint, method: .get).responseJSON { (myResponse) in
            switch myResponse.result{
            case .success:
//                print(myResponse)
                do{
                let myresult = try JSON(data: myResponse.data!)
                    if let resultArray = myresult["items"].array{
//                        Contains.arrRepo.removeAll()
                        Contains.cachePublic.delete()
                        for i in resultArray{
//                            print(i)
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
                            Contains.arrRepo.append(gitRepo)
                        }
                        Contains.cachePublic.save(arr: Contains.arrRepo)

                        debugPrint(Contains.arrRepo.count)
                        table.reloadData()
                        Contains.loadMore = true
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
    func fetchData2(table: UITableView) {
        let header = [
            "Authorization" : "token " + Contains.accessToken
        ]
        debugPrint(self.baseUrl + Contains.accessToken)
        Alamofire.request(self.baseUrl, method: .get, headers: header).responseJSON { (myResponse)
            in
            switch myResponse.result{
            case .success:
//                print(myResponse)
                do{
                    let myresult = try JSON(data: myResponse.data!)
                    if let resultArray = myresult.array{
                        Contains.arrUser.removeAll()
                        Contains.arrPrivate.removeAll()
                        Contains.arrPublic.removeAll()
                        Contains.arrUserProfile.removeAll()
                        Contains.cacheUser.delete()
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
                            Contains.arrUser.append(gitUserRepo)
                            if priv == "true" {
                                Contains.arrPrivate.append(gitUserRepo)
                            } else if priv == "false" {
                                Contains.arrPublic.append(gitUserRepo)
                            }
                        }
                        Contains.cacheUser.save(arr: Contains.arrUser)
                        Contains.arrUser = Contains.arrPublic
                        Contains.arrUserProfile = Contains.arrUser
                       
                        debugPrint(Contains.arrUser.count)
                        table.reloadData()
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
