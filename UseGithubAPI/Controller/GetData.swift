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
                print(myResponse)
                do{
                let myresult = try JSON(data: myResponse.data!)
                    if let resultArray = myresult["items"].array{
//                        Contains.arrRepo.removeAll()
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
                            
                            let gitRepo = GitRepo.init(name: name, login: login, avatar_url: avatar_url, star: star, watch: watch, fork: fork, issue: issue, commit: commit, url: url)
                            Contains.arrRepo.append(gitRepo)
                        }
                        debugPrint(Contains.arrRepo.count)
                    }
                    table.reloadData()
                }catch{
                    print("error")
                }
            
                break
            case .failure:
                print(myResponse.error!)
                break
            }
        }
    }
}
