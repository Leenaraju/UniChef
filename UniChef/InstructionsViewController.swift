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
    
    @IBOutlet weak var instructionsViewController: UITextView!
    
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients?.count ?? 0
    }
    
}
