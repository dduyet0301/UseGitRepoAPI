	//
//  CustomLogin.swift
//  UseGithubAPI
//
//  Created by gem on 6/26/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
    
    class CustomLogin: UIView {
            var provider = OAuthProvider(providerID: "github.com")
        @IBOutlet var contentView: UIView!
        let prefereces = UserDefaults.standard
        
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
        private func setup () {
            Bundle.main.loadNibNamed("CustomLogin", owner: self, options: nil)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(contentView)
            NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            self.rightAnchor.constraint(equalTo: contentView.rightAnchor)
                ])
        }
        @IBAction func btnLogin(_ sender: Any) {
            provider.customParameters = [
                "allow_signup": "false"
            ]
            provider.scopes = ["user"]
            provider.scopes = ["repo"]
            provider.getCredentialWith(nil) { credential, error in
                if credential != nil {
                    Auth.auth().signIn(with: credential!) { authResult, error in
                        if error != nil {
                            // Handle error.
                      debugPrint("LOGIN FAILED")
                        } else {
                            let a = authResult?.credential as! OAuthCredential
                            let accessToken = a.accessToken
                            print("token \(accessToken)")
                            self.prefereces.set(accessToken, forKey: "000")
                    NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
                        }
                    }
                }
            }
        }
    }
