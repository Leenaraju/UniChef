//
//  ProfileViewController.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/20/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit



class ProfileViewController: PFQueryTableViewController, UITextFieldDelegate  {
    
    var user: PFUser?
    
    @IBOutlet weak var upvotedCount: UILabel!
    
    @IBOutlet weak var uploadedCount: UILabel!
    
    @IBOutlet weak var browniePoints: UILabel!
    
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var savedRecipes: UISegmentedControl!
    
    private func getUser() -> PFUser? {
        if let user = user {
            return user
        } else {
            return PFUser.currentUser()
        }
    }
    
    @IBAction func savedRecipesChanged(sender: AnyObject) {
        loadObjects()
    }
    
    override func queryForTable() -> PFQuery {
        let query : PFQuery!
        if savedRecipes.selectedSegmentIndex == 0 {
            query = PFQuery(className: "UpvotedRecipe")
            query.whereKey("fromUser", equalTo: getUser()!)
            query.includeKey("toRecipe")
            query.includeKey("toRecipe.users")
            query.includeKey("fromUser")
        } else {
            query = PFQuery(className: "recipe")
            query.whereKey("users", equalTo: getUser()!)
            query.includeKey("users")
        }
        
        query.limit = 20
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        
        loadLikesCount()
        loadUploadCount()
        loadProfilePic()
        return query
    }
    
    private func loadUpvotes() {
        //if let text = tab
        //upvotedCount.text = text
        
    }
    
    private func loadUploaded() {
        if let text = getUser()?["count"] as? String {
            uploadedCount.text = text
        }
    }
    
    
    private func loadUsername() {
        if let usernameString = getUser()?["name"] as? String {
            username.text = usernameString
        }
    }
    
    private func loadProfilePic() {
        
        if let file = getUser()?["profilePic"] as? PFFile, urlString = file.url, url = NSURL(string: urlString) {
            profilePic.sd_setImageWithURL(url)
        }
        
        profilePic.layer.cornerRadius = profilePic.frame.width / 2
        
        
    }
    
    func textFieldShouldReturn(username: UITextField) -> Bool {
        PFUser.currentUser()?["name"] = username.text
        PFUser.currentUser()?.saveInBackground()
        username.resignFirstResponder()
        return true;
    }
    
    func textField(postView: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = count(postView.text.utf16) + count(string.utf16) - range.length
        return newLength <= 22 // Bool
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let id = getUser()?.objectId {
            getUser()?.fetchInBackground()
        }
        
        if let bPoints = getUser()?["points"] as? NSNumber {
            browniePoints.text = "\(bPoints)"
        }
        
        if let usernameString = getUser()?["name"] as? String {
            username.text = usernameString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        loadUpvotes()
        loadUploaded()
        
        loadUsername()
        
        var tgr = UITapGestureRecognizer(target:self, action:Selector("usernameTapped:"))
        //profilePic.addGestureRecognizer(tgr)
        
        self.savedRecipes.layer.borderWidth = 1.5
        self.savedRecipes.layer.cornerRadius = 0.0
        var grey : UIColor = UIColor(red: 240/255, green: 245/255, blue: 245/255, alpha: 1)
        self.savedRecipes.layer.borderColor = grey.CGColor
        
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
        self.profilePic.clipsToBounds = true
        self.profilePic.layer.borderWidth = 3.0
        var white : UIColor = UIColor.whiteColor()
        self.profilePic.layer.borderColor = white.CGColor
        
        if PFUser.currentUser()?.objectId != getUser()?.objectId {
            username.enabled = false
        }
    }
    
    private func loadLikesCount() {
        let query : PFQuery!
        query = PFQuery(className: "UpvotedRecipe")
        query.whereKey("fromUser", equalTo: getUser()!)
        query.countObjectsInBackgroundWithBlock { (count: Int32, error: NSError?) -> Void in
            if error == nil {
                self.upvotedCount.text = String(count)
                
            }
        }
    }
    
    //    private func loadBP() {
    ////        let query : PFQuery!
    ////        query = PFQuery(className: "User")
    ////        query.whereKey("username", equalTo: PFUser.currentUser()!)
    //
    //        let BPtext = PFUser.currentUser()?["points"] as? String
    //        browniePoints.text = BPtext
    //    }
    
    private func loadUploadCount() {
        let query : PFQuery!
        query = PFQuery(className: "recipe")
        query.whereKey("users", equalTo: getUser()!)
        query.countObjectsInBackgroundWithBlock { (count: Int32, error: NSError?) -> Void in
            if error == nil {
                self.uploadedCount.text = String(count)
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if PFUser.currentUser()?.objectId == getUser()?.objectId {
            return true
        }
        return false
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if let object = objectAtIndexPath(indexPath) {
                object.deleteInBackgroundWithBlock({ (success, error) -> Void in
                    self.loadObjects()
                })
            }
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        if let object = object {
            let cell = tableView.dequeueReusableCellWithIdentifier("UpvotedRecipeCell", forIndexPath: indexPath) as! UpvotedRecipeCell
            cell.indexPath = indexPath
            if(indexPath.row % 2 == 0){
                cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            } else{
                cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            }
            
            if savedRecipes.selectedSegmentIndex == 0 {
                cell.titleLabel?.text = object["toRecipe"]?["text"] as? String
            } else {
                cell.titleLabel?.text = object["text"] as? String
            }
            
            return cell
        }
        
        return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showQ" {
            if let vc = segue.destinationViewController as? SegContainer, cell = sender as? UpvotedRecipeCell {
                
                if savedRecipes.selectedSegmentIndex == 0 {
                    if let recipe = objectAtIndexPath(cell.indexPath)?["toRecipe"] as? PFObject {
                        vc.recipe = recipe
                        
                    }
                } else {
                    vc.recipe = objectAtIndexPath(cell.indexPath)
                }
            }
        }
    }
    
}



