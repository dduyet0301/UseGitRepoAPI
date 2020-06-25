//
//  TableViewCell.swift
//  UseGithubAPI
//
//  Created by gem on 6/23/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbRepo: UILabel!
    @IBOutlet weak var lbStar: UILabel!
    @IBOutlet weak var lbWatch: UILabel!
    @IBOutlet weak var lbFork: UILabel!
    @IBOutlet weak var lbIssue: UILabel!
    @IBOutlet weak var lbCommit: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
