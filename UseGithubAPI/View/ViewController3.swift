//
//  ViewController3.swift
//  UseGithubAPI
//
//  Created by gem on 6/30/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController3: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customLogin: CustomLogin!
    let getRepo = GetData(baseUrl: "https://api.github.com/user/repos")
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        if Auth.auth().currentUser != nil {
            customLogin.isHidden = true
        }
        let accessToken = UserDefaults.standard.string(forKey: "000")!
        Contains.accessToken = accessToken
        getRepo.fetchData2(table: tableView)
        print("TOKEN:\(accessToken)")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reload"), object: nil)
    }
    @objc func reload (notification: NSNotification) {
        self.viewDidLoad()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //CellProfile  CellRepo  CellLogout
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellProfile") as! TableViewCellProfile
            if !Contains.arrUser.isEmpty {
                let user = Contains.arrUser[0]
                cell.imgAva.sd_setImage(with: URL(string: user.avatar_url))
                cell.lbName.text = user.login
                cell.lbCommit.text = user.commit
                print("nameee\(user.login)")
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellRepo") as! TableViewCellRepo
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellLogout") as! TableViewCellLogout
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else {
            return 50
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let repo = storyboard?.instantiateViewController(withIdentifier: "Github") as! GithubViewController
            self.navigationController?.pushViewController(repo, animated: true)
        } else if indexPath.row == 2 {
            let firebaseAuth = Auth.auth()
            do {
                UserDefaults.standard.set("", forKey: "000")
                customLogin.isHidden = false
                debugPrint("user LOGOUT")
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
}
