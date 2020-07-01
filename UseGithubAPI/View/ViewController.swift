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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var forkSort: UIButton!
    @IBOutlet weak var starSort: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableInfo: UITableView!
    var refreshControl = UIRefreshControl()
    let getData = GetData(baseUrl: "https://api.github.com/search/repositories")
    var arrFilter = [GitRepo]()
    var searching = false
    var page: Int = 1
    var limit: Int = 50
    var desc = false
    var mode: Int = 2
    var sortType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableInfo.delegate = self
        tableInfo.dataSource = self
        searchBar.delegate = self
        getData.fetchData(endpoint: "?q=language:&per_page=50&page=\(page)", table: tableInfo)
        pullToRefresh()
        starSort.addTarget(self, action: #selector(star), for: .touchUpInside)
        forkSort.addTarget(self, action: #selector(fork), for: .touchUpInside)
        
        tableInfo.tableFooterView = UIView(frame: .zero)
        var index = 0
        while index < limit {
            index = index + 1
        }
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
        tableInfo.dataSource = self
        getData.fetchData(endpoint: "?q=language:&per_page=50&page=\(page)", table: tableInfo)
        refreshControl.endRefreshing()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilter.count
        } else {
        return Contains.arrRepo.count
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            self.tableInfo.tableFooterView = spinner
            self.tableInfo.tableFooterView?.isHidden = false
        }
        if indexPath.row == Contains.arrRepo.count - 1 {
            if Contains.arrRepo.count < 500 {
                var index = Contains.arrRepo.count
                limit = index + 50
                page += 1
                while index < limit {
                    index += 1
                }
            }
             self.perform(#selector(loadMore), with: nil, afterDelay: 0.01)
        }
       
    }
    @objc func loadMore() {
        getData.fetchData(endpoint: "?q=language:&per_page=50&page=\(page)", table: tableInfo)
        debugPrint("loaddata \(page) \(limit)")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = tableInfo.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        if searching {
            let repo = arrFilter[indexPath.row]
            cell.lbName.text = repo.login
            cell.lbRepo.text = repo.name
            cell.imgAvatar.sd_setImage(with: URL(string: repo.avatar_url))
            cell.lbStar.text = repo.star
            cell.lbWatch.text = repo.watch
            cell.lbFork.text = repo.fork
            cell.lbIssue.text = repo.issue
            cell.lbCommit.text =  "Commit at: \(repo.commit)"
        } else {
            let repo = Contains.arrRepo[indexPath.row]
            cell.lbName.text = repo.login
            cell.lbRepo.text = repo.name
            cell.imgAvatar.sd_setImage(with: URL(string: repo.avatar_url))
            cell.lbStar.text = repo.star
            cell.lbWatch.text = repo.watch
            cell.lbFork.text = repo.fork
            cell.lbIssue.text = repo.issue
            cell.lbCommit.text =  "Commit at: \(repo.commit)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.5
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        arrFilter = Contains.arrRepo.filter({$0.login.lowercased().prefix(searchText.count) == searchText.lowercased()})
        arrFilter = Contains.arrRepo.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableInfo.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableInfo.reloadData()
    }
    @objc func star() {
        //&sort=stars
        if mode == 0  {
            desc = !desc
        } else {
            mode = 0
            desc = true
        }
        if desc {
            sortType = "desc"
        } else {
            sortType = "asc"
        }
        tableInfo.dataSource = self
        Contains.arrRepo.removeAll()
        getData.fetchData(endpoint: "?q=language:&per_page=50&page=\(page)&sort=stars&order=\(sortType)", table: tableInfo)
    }
    @objc func fork() {
        //&sort=forks
        if mode == 1  {
            desc = !desc
        } else {
            mode = 1
            desc = true
        }
        if desc {
            sortType = "desc"
        } else {
            sortType = "asc"
        }
        tableInfo.dataSource = self
          Contains.arrRepo.removeAll()
        getData.fetchData(endpoint: "?q=language:&per_page=50&page=\(page)&sort=forks&order=\(sortType)", table: tableInfo)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let web = storyboard?.instantiateViewController(withIdentifier: "ViewController2") as? ViewController2
        web?.url = Contains.arrRepo[indexPath.row].url
        self.navigationController?.pushViewController(web!, animated: true)

    }
}

