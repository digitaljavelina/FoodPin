//
//  WalkthroughContentViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 5/9/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {

    @IBOutlet var headingLabel:UILabel!
    @IBOutlet var contentLabel:UILabel!
    @IBOutlet var contentImageView:UIImageView!
    @IBOutlet var pageControl:UIPageControl!
    @IBOutlet var forwardButton:UIButton!
    
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headingLabel.text = heading
        contentLabel.text = content
        contentImageView.image = UIImage(named: imageFile)
        
        // Set the current page
        pageControl.currentPage = index
        
        // Change the forward button's title
        switch index {
        case 0...1: forwardButton.setTitle("NEXT", forState: UIControlState.Normal)
        case 2: forwardButton.setTitle("DONE", forState: UIControlState.Normal)
        default: break
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        
        switch index {
        case 0...1:
            let pageViewController = parentViewController as! WalkthroughPageViewController
            pageViewController.forward(index)
            
        case 2:
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: "hasViewedWalkthrough")
            
            // add quick actions for ios9 - must be instantiated AFTER user has viewed walkthrough
            
            if traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
                let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier
                let shortcutItem1 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenFavorites", localizedTitle: "Show Favorites", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "favorite-shortcut"), userInfo: nil)
                let shortcutItem2 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenDiscover", localizedTitle: "Discover Restaurants", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "discover-shortcut"), userInfo: nil)
                let shortcutItem3 = UIApplicationShortcutItem(type: "\(bundleIdentifier).NewRestaurant", localizedTitle: "New Restaurant", localizedSubtitle: "Pick a new restaurant", icon: UIApplicationShortcutIcon(type: .Add), userInfo: nil)
                
                UIApplication.sharedApplication().shortcutItems = [shortcutItem1, shortcutItem2, shortcutItem3]
            }
            
            
            
            dismissViewControllerAnimated(true, completion: nil)
            
        default: break
            
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
