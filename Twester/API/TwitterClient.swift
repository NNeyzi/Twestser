//
//  TwitterClient.swift
//  Twester
//
//  Created by Nader Neyzi on 9/28/17.
//  Copyright © 2017 Nader Neyzi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "lf7KuKRWMjPvP8KsGbK1a57BS", consumerSecret: "WK20qfROlUtzwOe6e9vePYF4JT0mYNMalX2kucCinlveKeVOsI")!

    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)

            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //                print("account: \(response!)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)

            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?

    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {

        loginSuccess = success
        loginFailure = failure

        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twester://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            print("I got a request token!: \(requestToken.token!)")

            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)

        }, failure: { (error: Error!) in
            self.loginFailure?(error)
            print("Error: \(error.localizedDescription)")
        })
    }

    func logout() {
        User.currentUser = nil
        deauthorize()

        NotificationCenter.default.post(User.userDidLogoutNotification)
    }

    func handleOpenUrl(_ url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)

        TwitterClient.sharedInstance.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            print("I got access token")

            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })


        }, failure: { (error: Error!) in
            print("error: \(error.localizedDescription)")

            self.loginFailure?(error)
        })
    }

    func postTweet(text: String, replyToTweet: Tweet?, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let params = NSMutableDictionary()

        var mutableText = text
        if replyToTweet != nil {
            params["in_reply_to_status_id"] = replyToTweet!.tweetId
            mutableText = "@" + (replyToTweet?.user?.screenname)! + " " + mutableText
        }

        params["status"] = mutableText

        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }


    func retweet(tweet: Tweet, revert: Bool,success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let params: NSDictionary = ["id": tweet.tweetId!]

        var endpoint = "1.1/statuses/retweet.json"
        if revert {
            endpoint = "1.1/statuses/unretweet.json"
        }

        self.post(endpoint, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }

    func favorite(tweet: Tweet, revert: Bool,success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let params: NSDictionary = ["id": tweet.tweetId!]

        var endpoint = "1.1/favorites/create.json"
        if revert {
            endpoint = "1.1/favorites/destroy.json"
        }

        self.post(endpoint, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
}
