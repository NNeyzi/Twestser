//
//  MenuViewController.swift
//  Twester
//
//  Created by Nader Neyzi on 10/5/17.
//  Copyright © 2017 Nader Neyzi. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var viewControllers: [UIViewController] = []
    var viewControllerTitles: [String] = []

    var hamburgerViewController: HamburgerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        if viewControllers.count > 0 {
            hamburgerViewController.contentViewController = viewControllers[0]
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HamburgerCell", for: indexPath) as! HamburgerCell

        cell.itemLabel.text = viewControllerTitles[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
}

