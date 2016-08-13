//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by Michael Henry on 11/23/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {
    
    var restaurants: [CKRecord] = []
    var imageCache: NSCache = NSCache()
    
    @IBOutlet var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRecordsFromCloud()
        
        // add spinner
        
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        
        // pull to refresh control
        
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        refreshControl?.tintColor = UIColor.grayColor()
        refreshControl?.addTarget(self, action: "getRecordsFromCloud", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func getRecordsFromCloud() {
        
    // fetch data using operational API
        
        // remove existing records before refreshing
        
        restaurants.removeAll()
        tableView.reloadData()
        
        // fetch data using convenience API

        let cloudContainer = CKContainer.defaultContainer()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        
        // sort query by creation date
        
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // create the query operation with the query
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name"]
        queryOperation.queuePriority = .VeryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = { (record: CKRecord!) -> Void in
            if let restaurantRecord = record {
                self.restaurants.append(restaurantRecord)
            }
        }
        
        queryOperation.queryCompletionBlock = { (cursor: CKQueryCursor?, error: NSError?) -> Void in
            if error != nil {
                print("Failed to get data from iCloud - \(error!.localizedDescription)")
                
                return
            }
            
            print("Successfully retrieved data from iCloud")
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.spinner.stopAnimating()
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
        
        // execute the query
        
        publicDatabase.addOperation(queryOperation)


    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return restaurants.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.objectForKey("name") as? String
        
        // set default image
        
        cell.imageView?.image = UIImage(named: "photoalbum")
        
        // check if the image is stored in the cache
        
        if let imageFileURL = imageCache.objectForKey(restaurant.recordID) as? NSURL {
            
            // fetch image from cache
            
            print("Get image from cache")
            cell.imageView?.image = UIImage(data: NSData(contentsOfURL: imageFileURL)!)
        } else {
        
        // fetch image from cloud in background
        
        let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
        let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
        fetchRecordsImageOperation.desiredKeys = ["image"]
        fetchRecordsImageOperation.queuePriority = .VeryHigh
        
        fetchRecordsImageOperation.perRecordCompletionBlock = { (record: CKRecord?, recordID: CKRecordID?, error: NSError?) -> Void in
            if error != nil {
                print("Failed to get restaurant image: \(error!.localizedDescription)")
                
                return
            }
            
            if let restaurantRecord = record {
                NSOperationQueue.mainQueue().addOperationWithBlock() {
                    if let imageAsset = restaurantRecord.objectForKey("image") as? CKAsset {
                        cell.imageView?.image = UIImage(data: NSData(contentsOfURL: imageAsset.fileURL)!)
                        
                        // add the imageURL to the cache
                        
                        self.imageCache.setObject(imageAsset.fileURL, forKey: restaurant.recordID)
                    }
                }
            }
        }
        
        publicDatabase.addOperation(fetchRecordsImageOperation)
            
        }

        return cell
    }

}
