//
//  AboutTableViewController.swift
//  FoodPin
//
//  Created by Michael Henry on 11/22/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    var sectionTitles = ["Leave Feedback", "Follow Us"]
    var sectionContent = [["Rate us on the App Store", "Tell us your feedback"], ["Twitter", "Facebook", "Pintrest"]]
    var links = ["https://twitter.com/digitaljavelina", "https://facebook.com/docmhenry09", "https://pintrest.com/appcoda"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove separators for blank cells after second section
        
        tableView.tableFooterView = UIView(frame: CGRectZero)

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 3
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // configure the cell
        
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
            
            // leave feedback section
            
        case 0:
            if indexPath.row == 0 {
                if let url = NSURL(string: "http://www.apple.com/itunes/charts/paid-apps/") {
                    UIApplication.sharedApplication().openURL(url)
                }
            } else if indexPath.row == 1 {
                performSegueWithIdentifier("showWebView", sender: self)
            }
            
            // Follow us section
        
        case 1:
            if let url = NSURL(string: links[indexPath.row]) {
                let safariController = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
                presentViewController(safariController, animated: true, completion: nil)
            }
            
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

}
