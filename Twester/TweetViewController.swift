//
//  TweetViewController.swift
//  Twester
//
//  Created by Nader Neyzi on 10/1/17.
//  Copyright © 2017 Nader Neyzi. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {


    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!

    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageURL = tweet.user?.profileUrl {
            profileImageView.setImageWith(imageURL)
        }
        nameLabel.text = tweet.user?.name
        screenNameLabel.text = "@" + (tweet.user?.screenname)!
        tweetLabel.text = tweet.text
        retweetsCountLabel.text = "\(tweet.retweetCount)"
        favoritesCountLabel.text = "\(tweet.favoritesCount)"

    }

    @IBAction func onReplyButton(_ sender: Any) {

    }

    @IBAction func onRetweetButton(_ sender: Any) {
        TwitterClient.sharedInstance.retweet(tweet: tweet, revert: false, success: {
            let retweetButton = sender as! UIButton
            retweetButton.setImage(#imageLiteral(resourceName: "retweet-filled"), for: .normal)
        }) { (error: Error) in
            print("Error: \(error)")
        }
    }

    @IBAction func onFavoritesButton(_ sender: Any) {
        TwitterClient.sharedInstance.retweet(tweet: tweet, revert: false, success: {
            let retweetButton = sender as! UIButton
            retweetButton.setImage(#imageLiteral(resourceName: "fav-filled-50"), for: .normal)
        }) { (error: Error) in
            print("Error: \(error)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let composeNavController = segue.destination as! UINavigationController
        let composeVc = composeNavController.viewControllers[0] as! ComposeViewController

        composeVc.replyToTweet = tweet
    }



}
