//
//  ComposeViewController.swift
//  Twester
//
//  Created by Nader Neyzi on 10/1/17.
//  Copyright © 2017 Nader Neyzi. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!

    var replyToTweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tweet"

        tweetTextView.delegate = self
        tweetTextView.text = ""
        tweetTextView.becomeFirstResponder()

        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true

        let currentUser = User.currentUser
        if let profileImageUrl = currentUser?.profileUrl {
            profileImageView.setImageWith(profileImageUrl)
        }
        nameLabel.text = currentUser?.name
        screenNameLabel.text = currentUser?.screenname

    }

    @IBAction func onTweetButton(_ sender: Any) {
        TwitterClient.sharedInstance.postTweet(text: tweetTextView.text, replyToTweet: replyToTweet,success: {
            self.dismiss(animated: true, completion: nil)
        }) { (error: Error) in
            print("Error: \(error)")
        }
    }

    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
