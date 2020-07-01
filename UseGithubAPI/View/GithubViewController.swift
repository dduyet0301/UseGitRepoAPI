//
//  GithubViewController.swift
//  UseGithubAPI
//
//  Created by gem on 6/26/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit
import FirebaseAuth

class GithubViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableRepo: UITableView!
    let getRepo = GetData(baseUrl: "https://api.github.com/user/repos")

    override func viewDidLoad() {
        super.viewDidLoad()
        tableRepo.dataSource = self
        tableRepo.delegate = self
        //repo
//        let accessToken = UserDefaults.standard.string(forKey: "000")!
//        Contains.accessToken = accessToken
//        getRepo.fetchData2(table: tableRepo)
//        print("getToken: \(accessToken)")

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Contains.arrUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! TableViewCell2
        let userRepo = Contains.arrUser[indexPath.row]
            cell.lbRepoName.text = userRepo.name
            cell.lbStar.text = userRepo.star
            cell.lbWatch.text = userRepo.watch
            cell.lbFork.text = userRepo.fork
            cell.lbIssue.text = userRepo.issue
            cell.lbCommit.text = userRepo.commit
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    @IBAction func didChangeSegment(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            Contains.arrUser = Contains.arrPublic
            tableRepo.reloadData()
            print("public: \(Contains.arrUser.count)")
        } else if sender.selectedSegmentIndex == 1 {
            Contains.arrUser = Contains.arrPrivate
            tableRepo.reloadData()
            print("private: \(Contains.arrUser.count)")
        }
    }
}
