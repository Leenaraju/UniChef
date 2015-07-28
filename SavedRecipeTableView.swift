//
//  SavedRecipeTableView.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/27/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

class SavedRecipeTableView: PFQueryTableViewController {

    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "UpvotedRecipe")
        query.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        query.includeKey("toRecipe")
        return query
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        if let object = object {
            let cell = tableView.dequeueReusableCellWithIdentifier("UpvotedRecipeCell", forIndexPath: indexPath) as! UpvotedRecipeCell
            
            cell.titleLabel?.text = object["toRecipe"]?["text"] as? String
            
            return cell
        }
        
        return nil
}
    
}