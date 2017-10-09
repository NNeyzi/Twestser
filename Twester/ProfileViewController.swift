//
//  ProfileViewController.swift
//  Twester
//
//  Created by Nader Neyzi on 10/6/17.
//  Copyright © 2017 Nader Neyzi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileBannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetsNumberLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!

    var user: User!
    var tweets = [Tweet]()
    var screenName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if user == nil {
            user = User.currentUser
        }

        if let profileBannerUrl = user.profileBannerUrl {
            profileBannerImageView.setImageWith(profileBannerUrl)
        }
        if let profileImageUrl = user.profileUrl {
            profileImageView.setImageWith(profileImageUrl)
        }
        nameLabel.text = user.name
        screenNameLabel.text = user.screenname
        if let _ = user.tweetsCount {
            tweetsNumberLabel.text = String(describing:user.tweetsCount!)
        }
        if let _ = user.followingCount {
            followingNumberLabel.text = String(describing: user.followingCount!)
        }
        if let _ = user.followersCount {
            followersNumberLabel.text = String(describing: user.followersCount!)
        }

        TwitterClient.sharedInstance.userTimeline(screenName: user.screenname!, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }


    // MARK: - TableView Delegate & DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell

        cell.tweet = tweets[indexPath.row]
        return cell
    }

}
