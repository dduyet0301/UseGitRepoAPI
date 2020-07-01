//
//  ViewController2.swift
//  UseGithubAPI
//
//  Created by gem on 6/25/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var url: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if let link = URL(string: url){
             webView.loadRequest(URLRequest(url: link))
        }
       
    }
}
