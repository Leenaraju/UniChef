//
//  InstructionsViewController.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/23/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

class InstructionsViewController: UITableViewController {
    
    @IBOutlet weak var directions: UITextView!
    
    var recipe: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        directions.text = recipe?["directions"] as? String
        tableView.reloadData()
    }
    
    var ingredients: [String]? {
        return recipe?["ingredients"] as? [String]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ingCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = ingredients?[indexPath.row]
        
        return cell
    }    
    
    @IBOutlet weak var flagButton: UIButton!
    
    @IBAction func flaggedContent(sender: AnyObject) {
        
        let alertController = UIAlertController(
            title: "Report Content",
            message: "Would you like to flag this recipe as inappropriate?",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(
            title: "Yes",
            style: UIAlertActionStyle.Default){ (action) in
                self.recipe?.incrementKey("flaggedCount")
                self.recipe?.saveInBackground()
                self.flagButton.enabled = false
        }
        
        let no = UIAlertAction(
            title: "No",
            style: UIAlertActionStyle.Default) { (action) in
        }
        
        alertController.addAction(ok)
        alertController.addAction(no)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients?.count ?? 0
    }
    
}
