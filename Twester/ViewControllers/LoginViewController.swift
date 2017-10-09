//
//  LoginViewController.swift
//  Twester
//
//  Created by Nader Neyzi on 9/26/17.
//  Copyright © 2017 Nader Neyzi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onLoginButton(_ sender: Any) {
        TwitterClient.sharedInstance.login(success: {
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
    
}
