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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        if let object = object, id = object.objectId {
            cell.yakText.text = object.valueForKey("text") as? String
            cell.yakText.numberOfLines = 0
            let score = object.valueForKey("count")!.intValue
            cell.count.text = "\(score)"
            cell.time.text = "\((indexPath.row + 1) * 3)m ago"
            cell.replies.text = "\((indexPath.row + 1) * 1) replies"
            cell.indexPath = indexPath
            cell.tableView = self.tableView
            cell.object = object
            let defaults = NSUserDefaults.standardUserDefaults()
            if defaults.integerForKey(id) == -1 {
                cell.topButton.selected = false
                cell.bottomButton.selected = true
            } else if defaults.integerForKey(id) == 1 {
                cell.topButton.selected = true
                cell.bottomButton.selected = false
            } else {
                cell.topButton.selected = false
                cell.bottomButton.selected = false
            }
            
            /*if cell.topButton.selected == true{
                cell.topButton.selected = false
            }
            if cell.bottomButton.selected == true{
                cell.bottomButton.selected = false
            }*/

        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let vc = segue.destinationViewController as? DetailViewController, cell = sender as? TableViewCell {
                let yak = objectAtIndexPath(cell.indexPath)
                vc.yak = yak
            }
        }
    }
}