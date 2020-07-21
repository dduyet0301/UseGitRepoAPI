//
//  TableViewCell2.swift
//  UseGithubAPI
//
//  Created by gem on 6/29/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class TableViewCell2: UITableViewCell {
    @IBOutlet weak var lbRepoName: UILabel!
    @IBOutlet weak var lbStar: UILabel!
    @IBOutlet weak var lbWatch: UILabel!
    @IBOutlet weak var lbFork: UILabel!
    @IBOutlet weak var lbIssue: UILabel!
    @IBOutlet weak var lbCommit: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
