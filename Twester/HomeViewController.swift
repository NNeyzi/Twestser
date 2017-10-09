//
//  HomeViewController.swift
//  Twester
//
//  Created by Nader Neyzi on 9/30/17.
//  Copyright © 2017 Nader Neyzi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!

    var tweets = [Tweet]()
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        refreshControl.addTarget(self, action: #selector(retrieveTweets), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        retrieveTweets()
    }

    @objc func retrieveTweets() {
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }, failure: { (error: Error) in
            print(error.localizedDescription)
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        })
    }

    @IBAction func onLogoutbutton(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }

    // MARK: - TableView Delegate & DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell

        cell.tweet = tweets[indexPath.row]
        cell.profileImageView.tag = indexPath.row

        return cell
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TweetSegue" {
            let tweetVc = segue.destination as! TweetViewController

            let indexPath = tableView.indexPath(for: sender as! TweetCell)

            tweetVc.tweet = tweets[(indexPath?.row)!]
        } else if segue.identifier == "ProfileSegue" {
            let tapGestureRecognizer = sender as! UITapGestureRecognizer
            let profileImageView = tapGestureRecognizer.view as! UIImageView
            let tweet = tweets[profileImageView.tag]

            let profileVc = segue.destination as! ProfileViewController

            profileVc.user = tweet.user
        }
    }


}
