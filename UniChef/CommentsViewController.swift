//
//  CommentsViewController.swift
//  iScoot
//
//  Created by Abdulrahman AlZanki on 7/5/15.
//  Copyright (c) 2015 Abdulrahman AlZanki. All rights reserved.
//
import Foundation

class CommentsViewController: SLKTextViewController {
    var recipe : PFObject? {
        didSet {
            loadObjects()
        }
    }
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBAction func segControl(sender: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            self.view.viewWithTag(2)?.hidden = false
            self.view.viewWithTag(3)?.hidden = true
        case 1:
            self.view.viewWithTag(2)?.hidden = true
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("showIns") as! UINavigationController
            self.presentViewController(vc, animated: true, completion: nil)
        default:
            break;
        }
    }
    
    
    let parseClassName = "Comment"
    var curPage = 0
    var perPage = 15
    var objects = [PFObject]()
    var showLoadMoreButton = true
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.registerNib(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        tableView.registerNib(UINib(nibName: "LoadMoreCell", bundle: nil), forCellReuseIdentifier: "LoadMoreCell")
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        inverted = false
        shouldScrollToBottomAfterKeyboardShows = true
        
        self.refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl!)
        self.refreshControl?.beginRefreshing()
        
        if let header = UIView.loadFromNibNamed("RecipeView", bundle: NSBundle.mainBundle()) as? DetailView {
            header.recipe = recipe
            header.viewController = self
            
            header.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.tableView.tableHeaderView = header
            
            let views = [ "header" : header ]
            let metrics = [ "headerWidth" : UIScreen.mainScreen().bounds.width, "headerHeight" : 286 ]
            var constraints = [NSLayoutConstraint]()
            constraints.extend(NSLayoutConstraint.constraintsWithVisualFormat("H:[header(headerWidth)]", options: .allZeros, metrics: metrics, views: views) as! [NSLayoutConstraint])
            constraints.extend(NSLayoutConstraint.constraintsWithVisualFormat("V:[header(headerHeight)]", options: .allZeros, metrics: metrics, views: views) as! [NSLayoutConstraint])
            
            header.addConstraints(constraints)
        }
    }
    
    func loadObjects() {
        let query = PFQuery(className: parseClassName ?? "")
        
        if let recipe = recipe {
            query.whereKey("toRecipe", equalTo: recipe)
        }
        
        query.includeKey("fromUser")
        
        //andrew did this
        query.limit = perPage
        query.skip = perPage * curPage
        
        query.orderByDescending("postedAt")
        
        query.findObjectsInBackgroundWithBlock {
            [unowned self] (objects: [AnyObject]?, error: NSError?) -> Void in
            if (self.refreshControl != nil) {
                self.refreshControl?.endRefreshing()
                self.refreshControl?.removeFromSuperview()
                self.refreshControl = nil
            }
            if error == nil {
                if let newObjects = objects as? [PFObject] {
                    if newObjects.count == 0 || newObjects.count < self.perPage {
                        self.showLoadMoreButton = false
                    }
                    if self.curPage == 0 {
                        self.objects = newObjects
                    } else {
                        self.objects += newObjects
                    }
                    
                    
                    self.tableView.reloadData()
                    // self.refreshControl?.endRefreshing()
                    if self.curPage == 0 {
                        //                        self.scrollToBottom()
                    } else {
                        self.scrollToRowAtIndex(newObjects.count)
                    }
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    //    func scrollToBottom() {
    //        if tableView.contentSize.height > tableView.frame.size.height && !objects.isEmpty {
    //            //            let offset = CGPointMake(0, tableView.contentSize.height - tableView.frame.size.height)
    //            //            tableView.setContentOffset(offset, animated: false)
    //            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: tableView(tableView, numberOfRowsInSection: 0) - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.None, animated: false)
    //        }
    //    }
    
    func scrollToRowAtIndex(index : Int) {
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: UITableViewScrollPosition.None, animated: false)
    }
    
    func clear() {
        objects.removeAll(keepCapacity: true)
        tableView.reloadData()
    }
    
    func loadNextPage() {
        curPage++
        loadObjects()
    }
    
    func refresh(sender:AnyObject) {
        curPage = 0
        
        showLoadMoreButton = true
        
        loadObjects()
    }
    
    private func objectForRowAtIndex(var index : Int) -> PFObject? {
        if !showLoadMoreButton {
            return objects[objects.count - index - 1]
        } else {
            index -= 1
            
            var actualIndex = (objects.count - index) - 1
            
            if actualIndex < objects.count {
                return objects[actualIndex]
            }
        }
        
        return nil
    }
    
    override func didPressRightButton(sender: AnyObject!) {
        let object = PFObject(className: "Comment")
        
        object["fromUser"] = PFUser.currentUser()
        object["flaggedCount"] = 0

        object["toRecipe"] = recipe
        object["text"] = self.textView.text
        object["postedAt"] = NSDate()
        object.saveInBackground()
        
        objects.insert(object, atIndex: 0)
        tableView.reloadData()
        self.textView.text = ""
        //        self.scrollToBottom()
        
        object.saveInBackground()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showIngredients" {
            if let vc = segue.destinationViewController as? InstructionsViewController {
                vc.recipe = recipe
            }
        } else if segue.identifier == "openProfile" {
            if let vc = segue.destinationViewController as? ProfileViewController, user = sender as? PFUser {
                vc.user = user
            }
        }
    }
}

// Add tableview stuff
extension CommentsViewController : UITableViewDataSource, UITableViewDelegate {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objects.count == 0 {
            return 0
        }
        
        if showLoadMoreButton {
            return objects.count + 1
            
        }
        
        return objects.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 && showLoadMoreButton {
            let cell = tableView.dequeueReusableCellWithIdentifier("LoadMoreCell", forIndexPath: indexPath) as! LoadMoreCell
            
            cell.vc = self
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentCell
            
            let data = objectForRowAtIndex(indexPath.row)
            cell.viewController = self
            cell.data = data
            
            return cell
        }
    }
    
    override class func tableViewStyleForCoder(decoder: NSCoder) -> UITableViewStyle {
        return UITableViewStyle.Plain;
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        // 1
        var flagAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Flag" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            
            let alertController = UIAlertController(
                title: "Report Comment",
                message: "Would you like to flag this comment as inappropriate?",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let ok = UIAlertAction(
                title: "Yes",
                style: UIAlertActionStyle.Default){ (action) in
                    
                    self.recipe?.incrementKey("flaggedCount")
                    self.recipe?.saveInBackground()
            }
            
            let no = UIAlertAction(
                title: "No",
                style: UIAlertActionStyle.Default) { (action) in
            }
            
            alertController.addAction(ok)
            alertController.addAction(no)
            self.presentViewController(alertController, animated: true, completion: nil)
        })
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            if let row = self.objectForRowAtIndex(indexPath.row) {
                tableView.beginUpdates()
                if self.showLoadMoreButton {
                    self.objects.removeAtIndex(self.objects.count - indexPath.row)
                } else {
                    self.objects.removeAtIndex(self.objects.count - indexPath.row - 1)
                }
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.endUpdates()
                row.deleteInBackground()
                
                self.recipe?.incrementKey("commentsCount", byAmount: -1)
                self.recipe?.saveInBackground()
            }
        })
        flagAction.backgroundColor = UIColor.orangeColor()
        
        var isCurUser = false
        
        if let row = objectForRowAtIndex(indexPath.row), fromUser = row["fromUser"] as? PFUser, curUser = PFUser.currentUser() {
            if fromUser.objectId == curUser.objectId {
                isCurUser = true
            }
        }
        
        if isCurUser {
            return [deleteAction]
        } else {
            return [flagAction]
        }

        
        
    }
    
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}