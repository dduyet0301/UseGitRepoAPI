//
//  CustomUserProfile.swift
//  UseGithubAPI
//
//  Created by gem on 6/26/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation
import UIKit

class CustomUserProfile: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var lbStar: UILabel!
    @IBOutlet weak var lbWatch: UILabel!
    @IBOutlet weak var lbFork: UILabel!
    @IBOutlet weak var lbIssue: UILabel!
    @IBOutlet weak var lbCommit: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    init() {
        super.init(frame: .zero)
        setup()
    }
    private func setup() {
        Bundle.main.loadNibNamed("CustomUserProfile", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            self.rightAnchor.constraint(equalTo: contentView.rightAnchor)
            ])
    }
    @IBAction func btnLogout(_ sender: Any) {
    }
}
