//
//  ProfileViewController.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/20/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit



class ProfileViewController: PFQueryTableViewController {
    
    @IBOutlet weak var upvotedCount: UILabel!
    
    @IBOutlet weak var uploadedCount: UILabel!
    
    @IBOutlet weak var browniePoints: UILabel!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var savedRecipes: UISegmentedControl!
    
    
    @IBAction func savedRecipesChanged(sender: AnyObject) {
        loadObjects()
    }
    
    override func queryForTable() -> PFQuery {
        let query : PFQuery!
        if savedRecipes.selectedSegmentIndex == 0 {
            query = PFQuery(className: "UpvotedRecipe")
            query.whereKey("fromUser", equalTo: PFUser.currentUser()!)
            query.includeKey("toRecipe")
            query.includeKey("fromUser")
        } else {
            query = PFQuery(className: "recipe")
            query.whereKey("users", equalTo: PFUser.currentUser()!)
            query.includeKey("users")
        }
        
        query.limit = 20
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        
        
        return query
    }
    
    private func loadUpvotes() {
        if let text = PFUser.currentUser()?["text"] as? String {
            upvotedCount.text = text
        }
    }
    
    private func loadUploaded() {
        if let text = PFUser.currentUser()?["text"] as? String {
            uploadedCount.text = text
        }
    }
    
    
    private func loadUsername() {
        if let usernameString = PFUser.currentUser()?["name"] as? String {
            username.text = usernameString
        }
    }
    
    private func loadProfilePic() {
        let imageName = "defaultProfilePic.png"
        
        profilePic.image = UIImage(named: imageName)
        profilePic.layer.cornerRadius = profilePic.frame.width / 2
        
        if let profilePicThumb = PFUser.currentUser()?["fromUser"]?["profilePicThumb"] as? PFFile {
            if let url = profilePicThumb.url {
                profilePic.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: imageName))
            }
        } else {
            if let profilePicStringUrl = PFUser.currentUser()?["fromUser"]?["profilePic"] as? String {
                if let url = NSURL(string: profilePicStringUrl) {
                    profilePic.sd_setImageWithURL(url, placeholderImage: UIImage(named: imageName))
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUpvotes()
        loadUploaded()
        loadUsername()
        
        var tgr = UITapGestureRecognizer(target:self, action:Selector("usernameTapped:"))
        profilePic.addGestureRecognizer(tgr)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
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
            
            if savedRecipes.selectedSegmentIndex == 0 {
                cell.titleLabel?.text = object["toRecipe"]?["text"] as? String
            } else {
                cell.titleLabel?.text = object["text"] as? String
            }
            
            return cell
        }
        
        return nil
    }
    
}



