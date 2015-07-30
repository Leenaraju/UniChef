//
//  SearchRecipeCell.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/24/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import Foundation
import UIKit

class SearchRecipeCell: PFTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var topButton: UIButton!
    
    var indexPath: NSIndexPath?
    weak var tableView: UITableView!
    weak var object : PFObject?
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func topButton(sender: AnyObject) {
        if let object = object, id = object.objectId {
            
            let test = PFObject(className: "UpvotedRecipe")
            test["toRecipe"] = object
            test["fromUser"] = PFUser.currentUser()
            test.saveInBackground()
            
            var increment = 1
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if topButton.selected == true {
                bottomButton.selected = false
                topButton.selected = false
                increment = 0
                
                deleteUpvoteByUser(PFUser.currentUser()!, toRecipe: object)
                
            } else {
                bottomButton.selected = false
                topButton.selected = true
            }
            
            let num = -defaults.integerForKey(id) + increment
            
            defaults.setInteger(increment, forKey: id)
            
            object.incrementKey("count", byAmount: num)
            object.saveInBackground()
            
            if let countTotal = count.text?.toInt() {
                count.text = String(countTotal + num)
            }
            
            NSLog("Top Index Path \(indexPath?.row)")
        }
    }
    
    
    @IBAction func bottomButton(sender: AnyObject) {
        if let object = object, id = object.objectId {
            var increment = 1
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if bottomButton.selected == true {
                bottomButton.selected = false
                topButton.selected = false
                increment = 0
            }
                
            else {
                topButton.selected = false
                bottomButton.selected = true
            }
            
            deleteUpvoteByUser(PFUser.currentUser()!, toRecipe: object)
            
            let num = -defaults.integerForKey(id) - increment
            
            defaults.setInteger(-increment, forKey: id)
            
            object.incrementKey("count", byAmount: num)
            object.saveInBackground()
            
            if let countTotal = count.text?.toInt() {
                count.text = String(countTotal + num)
            }
            
            NSLog("Top Index Path \(indexPath?.row)")
        }
    }
    
    
    private func deleteUpvoteByUser(user: PFUser, toRecipe recipe: PFObject) {
        let query = PFQuery(className: "UpvotedRecipe")
        
        query.whereKey("fromUser", equalTo: user)
        query.whereKey("toRecipe", equalTo: recipe)
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            PFObject.deleteAllInBackground(objects)
        }
    }
    
}