//
//  ViewController.swift
//  UseGithubAPI
//
//  Created by gem on 6/23/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet weak var forkSort: UIButton!
    @IBOutlet weak var starSort: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableInfo: UITableView!
    var refreshControl = UIRefreshControl()
    let getData = GetData()
    public static var page = 1
    public static var limit = 50
    public static var desc = false
    public static var sortContent = ""
    public static var sortType = ""
    var mode: Int = 2
    let cache = CachePublic()
    
    var arrRepo: [GitRepo] = []
    var arrRepoCacheDefault: [GitRepo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableInfo.delegate = self
        tableInfo.dataSource = self
        searchBar.delegate = self
        
        if !InternetCheck.isConnectedToInternet() {
            print("no internet 00")
            arrRepoCacheDefault = cache.get()
            arrRepo = arrRepoCacheDefault
        } else {
            getData.fetchData(callback: addData(arr:))
            pullToRefresh()
        }
        starSort.addTarget(self, action: #selector(star), for: .touchUpInside)
        forkSort.addTarget(self, action: #selector(fork), for: .touchUpInside)
        tableInfo.tableFooterView = UIView(frame: .zero)
    }
    
    func addData(arr: [GitRepo]) {
        cache.delete()
        for i in arr {
            arrRepoCacheDefault.append(i)
        }
        arrRepo = arrRepoCacheDefault
        cache.save(arr: arrRepo)
        tableInfo.reloadData()
    }
    
    func pullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tableInfo.refreshControl = refreshControl
        } else {
            self.tableInfo.addSubview(refreshControl)
        }
    }
    
    @objc private func refreshData(_: Any) {
        getData.fetchData(callback: addData(arr:))
        refreshControl.endRefreshing()
    }
    
    @objc func loadMore() {
        if mode == 2 {
            getData.fetchData(callback: addData(arr:))
        } else if mode == 0 {
            MainViewController.sortContent = "stars"
            getData.fetchData(callback: addData(arr:))
        } else if mode == 1 {
            MainViewController.sortContent = "forks"
            getData.fetchData(callback: addData(arr:))
        }
    }
    
    @objc func star() {
        //&sort=stars
        arrRepoCacheDefault.removeAll()
        if mode == 0  {
            MainViewController.desc = !MainViewController.desc
        } else {
            mode = 0
            MainViewController.desc = true
        }
        if InternetCheck.isConnectedToInternet() {
            MainViewController.page = 1
            if MainViewController.desc {
                MainViewController.sortType = "desc"
            } else {
                MainViewController.sortType = "asc"
            }
            arrRepo.removeAll()
            tableInfo.reloadData()
            MainViewController.sortContent = "stars"
            getData.fetchData(callback: addData(arr:))
        } else {
            starCache()
        }
    }
    
    func starCache() {
        if MainViewController.desc {
            arrRepo = arrRepo.sorted(by: { (Int($0.star) ?? 0) > (Int($1.star) ?? 0) })
        } else {
            arrRepo = arrRepo.sorted(by: { (Int($0.star) ?? 0) < (Int($1.star) ?? 0) })
        }
        tableInfo.reloadData()
    }
    
    @objc func fork() {
        //&sort=forks
        arrRepoCacheDefault.removeAll()
        if mode == 1  {
            MainViewController.desc = !MainViewController.desc
        } else {
            mode = 1
            MainViewController.desc = true
        }
        if InternetCheck.isConnectedToInternet(){
            MainViewController.page = 1
            if MainViewController.desc {
                MainViewController.sortType = "desc"
            } else {
                MainViewController.sortType = "asc"
            }
            arrRepo.removeAll()
            MainViewController.sortContent = "forks"
            tableInfo.reloadData()
            getData.fetchData(callback: addData(arr:))
        } else {
            forkCache()
        }
    }
    
    func forkCache () {
        if MainViewController.desc {
            arrRepo = arrRepo.sorted(by: { (Int($0.fork) ?? 0) > (Int($1.fork) ?? 0) })
        } else {
            arrRepo = arrRepo.sorted(by: { (Int($0.fork) ?? 0) < (Int($1.fork) ?? 0) })
        }
        tableInfo.reloadData()
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRepo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = tableInfo.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        let repo = arrRepo[indexPath.row]
        cell.lbName.text = repo.login
        cell.lbRepo.text = repo.name
        cell.imgAvatar.sd_setImage(with: URL(string: repo.avatar_url))
        cell.lbStar.text = repo.star
        cell.lbWatch.text = repo.watch
        cell.lbFork.text = repo.fork
        cell.lbIssue.text = repo.issue
        cell.lbCommit.text =  "Commit at: \(repo.commit)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var index = arrRepo.count
        if (indexPath.row == index - 1 && Global.loadMore) {
            if index < 950 {
                index = index + 50
                MainViewController.page += 1
                Global.loadMore = false
                self.perform(#selector(loadMore), with: nil, afterDelay: 0.01)
            }
        }
        
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -300, 10, 0)
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let web = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
        web?.url = arrRepo[indexPath.row].url
        self.navigationController?.pushViewController(web!, animated: true)
    }
    
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        mode = 3
        if searchText.isEmpty {
            mode = 2
            arrRepo.removeAll()
            tableInfo.reloadData()
            if !InternetCheck.isConnectedToInternet() {
                arrRepo = arrRepoCacheDefault
            } else {
                MainViewController.limit = 50
                MainViewController.page = 1
                getData.fetchData(callback: addData(arr:))
            }
        } else {
            arrRepo = arrRepoCacheDefault
            arrRepo = arrRepo.filter({ (repo) -> Bool in
                return repo.name.lowercased().contains(searchText.lowercased())
            })
        }
        tableInfo.reloadData()
    }
}

