//
//  TableViewController.swift
//  UniChef
//
//  Created by Andrew/Leena on 7/15/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit
import CoreLocation

class TableViewController: PFQueryTableViewController {
    var yaks = ["Yo"]
    
    
    override init(style: UITableViewStyle, className: String!) {
    super.init(style: style, className: className)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Yak"
        self.textKey = "text"
        self.pullToRefreshEnabled = true
        self.objectsPerPage = 200
        
    }
    
    private func alert(message : String) {
        let alert = UIAlertController(title: "Oops something went wrong.", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        let settings = UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default) { (action) ->Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            return
        }
        alert.addAction(settings)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
 
    
    
    override func queryForTable() -> PFQuery {
        
        let query = PFQuery(className: "Yak")
        query.limit = 200;
        query.orderByDescending("createdAt")
        
        return query
    }
    
    
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        if let object = self.objectAtIndexPath(indexPath) {
            cell.yakText.text = object.valueForKey("text") as? String
            cell.yakText.numberOfLines = 0
            let score = object.valueForKey("count")!.intValue
            cell.count.text = "\(score)"
            cell.time.text = "\((indexPath.row + 1) * 3)m ago"
            cell.replies.text = "\((indexPath.row + 1) * 1) replies"
        }
        return cell
    }

    @IBAction func topButton(sender: AnyObject) {
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        if let object = objectAtIndexPath(hitIndex) {
            object.incrementKey("count")
            object.saveInBackground()
            self.tableView.reloadData()
            NSLog("Top Index Path \(hitIndex?.row)")
            
            
        }
    }
    
    @IBAction func bottomButton(sender: AnyObject) {
        let hitPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let hitIndex = self.tableView.indexPathForRowAtPoint(hitPoint)
        if let object = objectAtIndexPath(hitIndex) {
            object.incrementKey("count", byAmount: -1)
            object.saveInBackground()
            self.tableView.reloadData()
            NSLog("Bottom Index Path \(hitIndex?.row)")
            
        }
    }
    
}