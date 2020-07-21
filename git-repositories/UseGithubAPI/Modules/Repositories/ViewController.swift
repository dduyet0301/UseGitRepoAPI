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

class ViewController: UIViewController {
    
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
        arrRepoCacheDefault.removeAll()
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
            ViewController.sortContent = "stars"
            getData.fetchData(callback: addData(arr:))
        } else if mode == 1 {
            ViewController.sortContent = "forks"
            getData.fetchData(callback: addData(arr:))
        }
    }
    
    @objc func star() {
        //&sort=stars
        arrRepoCacheDefault.removeAll()
        if mode == 0  {
            ViewController.desc = !ViewController.desc
        } else {
            mode = 0
            ViewController.desc = true
        }
        if InternetCheck.isConnectedToInternet() {
            ViewController.page = 1
            if ViewController.desc {
                ViewController.sortType = "desc"
            } else {
                ViewController.sortType = "asc"
            }
            arrRepo.removeAll()
            tableInfo.reloadData()
            ViewController.sortContent = "stars"
            getData.fetchData(callback: addData(arr:))
        } else {
            starCache()
        }
    }
    
    func starCache() {
        if ViewController.desc {
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
            ViewController.desc = !ViewController.desc
        } else {
            mode = 1
            ViewController.desc = true
        }
        if InternetCheck.isConnectedToInternet(){
            ViewController.page = 1
            if ViewController.desc {
                ViewController.sortType = "desc"
            } else {
                ViewController.sortType = "asc"
            }
            arrRepo.removeAll()
            ViewController.sortContent = "forks"
            tableInfo.reloadData()
            getData.fetchData(callback: addData(arr:))
        } else {
            forkCache()
        }
    }
    
    func forkCache () {
        if ViewController.desc {
            arrRepo = arrRepo.sorted(by: { (Int($0.fork) ?? 0) > (Int($1.fork) ?? 0) })
        } else {
            arrRepo = arrRepo.sorted(by: { (Int($0.fork) ?? 0) < (Int($1.fork) ?? 0) })
        }
        tableInfo.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint(arrRepo.count)
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
        let index = arrRepo.count
        if indexPath.row == index - 1 && Global.loadMore {
            if index < 950 {
                ViewController.limit = index + 50
                ViewController.page += 1
                Global.loadMore = false
                self.perform(#selector(loadMore), with: nil, afterDelay: 0.01)
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let web = storyboard?.instantiateViewController(withIdentifier: "ViewController2") as? ViewController2
        web?.url = arrRepo[indexPath.row].url
        self.navigationController?.pushViewController(web!, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        mode = 3
        if searchText.isEmpty {
            mode = 2
            arrRepo.removeAll()
            tableInfo.reloadData()
            if !InternetCheck.isConnectedToInternet() {
                arrRepo = arrRepoCacheDefault
            } else {
                ViewController.limit = 50
                ViewController.page = 1
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

