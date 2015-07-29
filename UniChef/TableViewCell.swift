//
//  TableViewCell.swift
//  UniChef
//
//  Created by Andrew/Leena on 7/15/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

class TableViewCell: PFTableViewCell {
    

    weak var object : PFObject?
    
    @IBOutlet weak var recipeText: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    weak var tableView: UITableView!
    
    var indexPath: NSIndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
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

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}