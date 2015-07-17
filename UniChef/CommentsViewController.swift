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
    }
    
    func loadObjects() {
        //let query = PFQuery(className: parseClassName ?? "")
        let query = PFQuery(className: "Yak")

        query.whereKey("sport", equalTo: App.type)
        
        if let video = video {
            query.whereKey("toVideo", equalTo: video)
        } else {
            // IF we have no owner, we don't wanna load anything
            query.whereKey("sport", equalTo: "nothing")
        }
        
        query.includeKey("fromUser")
        
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
                    //                    self.refreshControl?.endRefreshing()
                    if self.curPage == 0 {
                        self.scrollToBottom()
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
    
    func scrollToBottom() {
        if tableView.contentSize.height > tableView.frame.size.height {
            //            let offset = CGPointMake(0, tableView.contentSize.height - tableView.frame.size.height)
            //            tableView.setContentOffset(offset, animated: false)
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: tableView(tableView, numberOfRowsInSection: 0) - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.None, animated: false)
        }
    }
    
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
        object["toVideo"] = video
        object["sport"] = video?["sport"]
        object["text"] = self.textView.text
        object["postedAt"] = NSDate()
        
        object.saveInBackground()
        
        objects.insert(object, atIndex: 0)
        tableView.reloadData()
        self.textView.text = ""
        self.scrollToBottom()
        
        video?.incrementKey("commentsCount")
        video?.saveInBackground()
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
        if editingStyle ==  UITableViewCellEditingStyle.Delete {
            if let row = objectForRowAtIndex(indexPath.row) {
                tableView.beginUpdates()
                if showLoadMoreButton {
                    objects.removeAtIndex(objects.count - indexPath.row)
                } else {
                    objects.removeAtIndex(objects.count - indexPath.row - 1)
                }
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.endUpdates()
                row.deleteInBackground()
                
                video?.incrementKey("commentsCount", byAmount: -1)
                video?.saveInBackground()
            }
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let row = objectForRowAtIndex(indexPath.row), fromUser = row["fromUser"] as? PFUser, curUser = PFUser.currentUser() {
            if fromUser.objectId == curUser.objectId {
                return true
            }
        }
        
        return false
    }
}