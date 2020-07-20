//
//  TableViewCell3.swift
//  UseGithubAPI
//
//  Created by gem on 6/30/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class TableViewCellProfile: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgAva: UIImageView!
    @IBOutlet weak var lbCommit: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
