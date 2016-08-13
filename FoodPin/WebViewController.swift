//
//  WebViewController.swift
//  FoodPin
//
//  Created by Michael Henry on 11/22/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = NSURL(string: "http://digitaljavelina.com") {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }


}
