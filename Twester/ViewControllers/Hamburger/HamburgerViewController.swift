//
//  HamburgerViewController.swift
//  Twester
//
//  Created by Nader Neyzi on 10/5/17.
//  Copyright © 2017 Nader Neyzi. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewLeftMarginConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController

        menuViewController.hamburgerViewController = self

        let profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        let homeNavigationController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
        let mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")

        menuViewController.viewControllers = [profileNavigationController, homeNavigationController, mentionsNavigationController]
        menuViewController.viewControllerTitles = ["Profile", "Timeline", "Mentions"]

        self.menuViewController = menuViewController

        contentViewController = homeNavigationController
    }


    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()

            menuView.addSubview(menuViewController.view)
        }
    }

    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()

            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }

            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)

            UIView.animate(withDuration: 0.3) {
                self.contentViewLeftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }

    var originalLeftMargin: CGFloat!

    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)

        if sender.state == UIGestureRecognizerState.began {
            originalLeftMargin = contentViewLeftMarginConstraint.constant
        } else if sender.state == UIGestureRecognizerState.changed {
            let newLeftMargin = originalLeftMargin + translation.x
            if newLeftMargin >= 0 {
                contentViewLeftMarginConstraint.constant = newLeftMargin
            } else {
                contentViewLeftMarginConstraint.constant = 0
            }
        } else if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0 {
                    self.contentViewLeftMarginConstraint.constant = self.view.frame.size.width - 50
                } else {
                    self.contentViewLeftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        }
    }

}
