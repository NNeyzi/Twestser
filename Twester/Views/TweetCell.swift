//
//  TweetCell.swift
//  Twester
//
//  Created by Nader Neyzi on 9/30/17.
//  Copyright © 2017 Nader Neyzi. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!

    var tweet: Tweet! {
        didSet {
            if let imageURL = tweet.user?.profileUrl {
                profileImageView.setImageWith(imageURL)
            }

            nameLabel.text = tweet.user?.name
            screenNameLabel.text = "@" + (tweet.user?.screenname)!
            tweetTextLabel.text = tweet.text

            if let timeStamp = tweet.timestamp {
                let secondsSinceNow = Int(-timeStamp.timeIntervalSinceNow)
                let minutesSinceNow = secondsSinceNow / 60
                let hoursSinceNow = minutesSinceNow / 60

                if secondsSinceNow < 60 {
                    timeStampLabel.text = "\(secondsSinceNow)s"
                } else if minutesSinceNow < 60 {
                    timeStampLabel.text = "\(minutesSinceNow)m"
                } else if hoursSinceNow <= 24 {
                    timeStampLabel.text = "\(hoursSinceNow)h"
                } else {
                    let calendar = Calendar.current
                    let month = calendar.component(.month, from: timeStamp)
                    let day = calendar.component(.day, from: timeStamp)

                    let months = DateFormatter().shortMonthSymbols
                    let monthSymbol = months![month-1]

                    timeStampLabel.text = "\(monthSymbol) \(day)"
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
