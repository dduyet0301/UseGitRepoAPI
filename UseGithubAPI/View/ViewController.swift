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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var forkSort: UIButton!
    @IBOutlet weak var starSort: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableInfo: UITableView!
    var refreshControl = UIRefreshControl()
    // FIXME: không để base URL ở đây, như vậy mỗi lần dùng sẽ phải truyền lại vào 1 lần nữa, nếu ở nhiều nơi khi sửa sẽ dễ bị sửa thiếu chỗ
    // base Url nên để luôn trong lớp quản lý việc gọi API
    let getData = GetData(baseUrl: "https://api.github.com/search/repositories")
    var page: Int = 1
    var limit: Int = 50
    var desc = false
    var mode: Int = 2
    var sortType: String = ""
    
    var arrRepoCacheDefault = [GitRepo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableInfo.delegate = self
        tableInfo.dataSource = self
        searchBar.delegate = self
        arrRepoCacheDefault = Contains.cachePublic.get()
        if !InternetCheck.isConnectedToInternet() {
            print("no internet 00")
            Contains.arrRepo = arrRepoCacheDefault
        } else {
            // FIXME: nên đưa logic liên quan đến API vào bên trong lớp quản lý API và chỉ truyền dữ liệu cần thiết vào thôi, tránh việc các lớp không liên khác phải làm công việc xử lý logic của lớp API
            getData.fetchData(endpoint: "?q=language:&per_page=50&page=\(page)", table: tableInfo)
            pullToRefresh()
        }
        starSort.addTarget(self, action: #selector(star), for: .touchUpInside)
        forkSort.addTarget(self, action: #selector(fork), for: .touchUpInside)
        tableInfo.tableFooterView = UIView(frame: .zero)
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
        Contains.arrRepo.removeAll()
        tableInfo.dataSource = self
        tableInfo.delegate = self
        // FIXME: nên đưa logic liên quan đến API vào bên trong lớp quản lý API và chỉ truyền dữ liệu cần thiết vào thôi, tránh việc các lớp không liên khác phải làm công việc xử lý logic của lớp API
        getData.fetchData(endpoint: "?q=language:&per_page=50&page=\(page)", table: tableInfo)
        refreshControl.endRefreshing()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Contains.arrRepo.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = tableInfo.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
            let repo = Contains.arrRepo[indexPath.row]
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        arrFilter = Contains.arrRepo.filter({$0.login.lowercased().prefix(searchText.count) == searchText.lowercased()})
        
        mode = 3
        if searchText.isEmpty {
            mode = 2
            Contains.arrRepo.removeAll()
            tableInfo.reloadData()
            if !InternetCheck.isConnectedToInternet() {
                Contains.arrRepo = arrRepoCacheDefault
            } else {
                // FIXME: nên đưa logic liên quan đến API vào bên trong lớp quản lý API và chỉ truyền dữ liệu cần thiết vào thôi, tránh việc các lớp không liên khác phải làm công việc xử lý logic của lớp API
                getData.fetchData(endpoint: "?q=language:&per_page=50&page=1)", table: tableInfo)
            }
        } else {
            Contains.arrRepo = arrRepoCacheDefault
            Contains.arrRepo = Contains.arrRepo.filter({ (repo) -> Bool in
                return repo.name.lowercased().contains(searchText.lowercased())
            })
        }
        tableInfo.reloadData()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let lastSectionIndex = tableView.numberOfSections - 1
//        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
//        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
//            let spinner = UIActivityIndicatorView(style: .gray)
//            spinner.startAnimating()
//            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
//            self.tableInfo.tableFooterView = spinner
//            self.tableInfo.tableFooterView?.isHidden = false
//        }
        let index = Contains.arrRepo.count
        if indexPath.row == index - 1 && Contains.loadMore {
            print("indexpath:\(indexPath.row), \(index)")
            if index < 950 {
                limit = index + 50
                page += 1
                Contains.loadMore = false
                self.perform(#selector(loadMore), with: nil, afterDelay: 0.01)
            }
        }
    }
    
    @objc func loadMore() {
        // FIXME: nên đưa logic liên quan đến API vào bên trong lớp quản lý API và chỉ truyền dữ liệu cần thiết vào thôi, tránh việc các lớp không liên khác phải làm công việc xử lý logic của lớp API
        if mode == 2 {
            getData.fetchData(endpoint: "?q=language:&per_page=50&page=\(page)", table: tableInfo)
        } else if mode == 0 {
            getData.fetchData(endpoint: "?q=language:&per_page=\(limit)&page=\(page)&sort=stars&order=\(sortType)", table: tableInfo)
        } else if mode == 1 {
            getData.fetchData(endpoint: "?q=language:&per_page=\(limit)&page=\(page)&sort=forks&order=\(sortType)", table: tableInfo)
        }
    }
    
    @objc func star() {
        //&sort=stars
        if mode == 0  {
            desc = !desc
        } else {
            mode = 0
            desc = true
        }
        if InternetCheck.isConnectedToInternet() {
            page = 1
            if desc {
                sortType = "desc"
            } else {
                sortType = "asc"
            }
            tableInfo.dataSource = self
            Contains.arrRepo.removeAll()
            tableInfo.reloadData()
            // FIXME: nên đưa logic liên quan đến API vào bên trong lớp quản lý API và chỉ truyền dữ liệu cần thiết vào thôi, tránh việc các lớp không liên khác phải làm công việc xử lý logic của lớp API
            getData.fetchData(endpoint: "?q=language:&per_page=\(limit)&page=\(page)&sort=stars&order=\(sortType)", table: tableInfo)
        } else {
            starCache()
        }
    }
    func starCache() {
        if desc {
            Contains.arrRepo = Contains.arrRepo.sorted(by: { (Int($0.star) ?? 0) > (Int($1.star) ?? 0) })
        } else {
            Contains.arrRepo = Contains.arrRepo.sorted(by: { (Int($0.star) ?? 0) < (Int($1.star) ?? 0) })
        }
        tableInfo.reloadData()
    }
    @objc func fork() {
        //&sort=forks
        if mode == 1  {
            desc = !desc
        } else {
            mode = 1
            desc = true
        }
        if InternetCheck.isConnectedToInternet(){
            page = 1
            if desc {
                sortType = "desc"
            } else {
                sortType = "asc"
            }
            tableInfo.dataSource = self
            Contains.arrRepo.removeAll()
            tableInfo.reloadData()
            getData.fetchData(endpoint: "?q=language:&per_page=\(limit)&page=\(page)&sort=forks&order=\(sortType)", table: tableInfo)
        } else {
            forkCache()
        }
    }
    func forkCache () {
        if desc {
            Contains.arrRepo = Contains.arrRepo.sorted(by: { (Int($0.fork) ?? 0) > (Int($1.fork) ?? 0) })
        } else {
            Contains.arrRepo = Contains.arrRepo.sorted(by: { (Int($0.fork) ?? 0) < (Int($1.fork) ?? 0) })
        }
        tableInfo.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let web = storyboard?.instantiateViewController(withIdentifier: "ViewController2") as? ViewController2
        web?.url = Contains.arrRepo[indexPath.row].url
        self.navigationController?.pushViewController(web!, animated: true)
        
    }
}

