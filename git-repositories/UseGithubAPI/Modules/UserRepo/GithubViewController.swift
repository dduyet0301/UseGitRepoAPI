//
//  swift
//  UseGithubAPI
//
//  Created by gem on 6/26/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit
import FirebaseAuth

class GithubViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableRepo: UITableView!
    let getRepo = GetData()
    let cache = Cache()
    var arrUser: [GitRepo] = []
    var arrPrivate: [GitRepo] = []
    var arrPublic: [GitRepo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableRepo.dataSource = self
        tableRepo.delegate = self
        //repo
        let accessToken = UserDefaults.standard.string(forKey: "000")!
        Contains.accessToken = accessToken
        getRepo.fetchData2(callback: addData(arrPrivate:arrPublic:))
        if !InternetCheck.isConnectedToInternet() {
            arrUser = cache.get()
            for repo in arrUser {
                if repo.priv == "true" {
                    arrPrivate.append(repo)
                } else {
                    arrPublic.append(repo)
                }
            }
        }
    }
    
    func addData(arrPrivate: [GitRepo], arrPublic: [GitRepo]) {
        self.arrPrivate = arrPrivate
        self.arrPublic = arrPublic
        arrUser = self.arrPublic
        cache.save(arr: arrUser)
        tableRepo.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! TableViewCell2
        let userRepo = arrUser[indexPath.row]
            cell.lbRepoName.text = userRepo.name
            cell.lbStar.text = userRepo.star
            cell.lbWatch.text = userRepo.watch
            cell.lbFork.text = userRepo.fork
            cell.lbIssue.text = userRepo.issue
            cell.lbCommit.text = userRepo.commit
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            arrUser = arrPublic
            tableRepo.reloadData()
        } else if sender.selectedSegmentIndex == 1 {
            arrUser = arrPrivate
            tableRepo.reloadData()
        }
    }
}
