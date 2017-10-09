//
//  User.swift
//  Twester
//
//  Created by Nader Neyzi on 9/28/17.
//  Copyright © 2017 Nader Neyzi. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var profileBannerUrl: URL?
    var tagline: String?
    var dictionary: NSDictionary?
    var tweetsCount: Int?
    var followersCount: Int?
    var followingCount: Int?

    fileprivate static var _currentUser: User?
    static let userDidLogoutNotification = Notification(name: Notification.Name(rawValue: "UserDidLogout"))

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary

        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: profileUrlString)
        }
        if let profileBannerUrlString = dictionary["profile_banner_url"] as? String {
            profileBannerUrl = URL(string:profileBannerUrlString)
        }
        tagline = dictionary["description"] as? String
        tweetsCount = dictionary["statuses_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
    }

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }

        set(user) {
            _currentUser = user

            let defaults = UserDefaults.standard

            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }

            defaults.synchronize()
        }
    }
}
