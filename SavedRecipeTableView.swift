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
        let query = PFQuery(className: "recipe")
        return query
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        if let object = object {
            let cell = tableView.dequeueReusableCellWithIdentifier("UpvotedRecipeCell", forIndexPath: indexPath) as! UpvotedRecipeCell
            
            cell.titleLabel?.text = object["text"] as? String
            
            return cell
        }
        
        return nil
}
}