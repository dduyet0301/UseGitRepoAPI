//
//  ViewController3.swift
//  UseGithubAPI
//
//  Created by gem on 6/30/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreData

class UserRepoViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customLogin: CustomLogin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let isLogin = UserDefaults.standard.bool(forKey: "LoginCheck")
        debugPrint(isLogin)
        if isLogin {
            customLogin.isHidden = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reload"), object: nil)
    }
    
    @objc func reload (notification: NSNotification) {
        tableView.reloadData()
    }
}

extension UserRepoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellProfile") as! TableViewCellProfile
            let name = Auth.auth().currentUser?.displayName
            let image = Auth.auth().currentUser?.photoURL
            cell.imgAva.sd_setImage(with: image)
            cell.lbName.text = name
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
}

extension UserRepoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let repo = storyboard?.instantiateViewController(withIdentifier: "RepoViewController") as! RepoViewController
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
