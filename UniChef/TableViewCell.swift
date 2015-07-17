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
    
    @IBOutlet weak var yakText: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var replies: UILabel!
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
       let defaults = NSUserDefaults.standardUserDefaults()
        
        if bottomButton.selected == true {
            bottomButton.selected = false
            bottomButton.enabled = true
            
            if let object = object, id = object.objectId {
                 let num = -defaults.integerForKey(id)
                
                defaults.setInteger(1, forKey: object.objectId!)
                
                object.incrementKey("count", byAmount: num + 1)
                object.saveInBackground()
                self.tableView.reloadData()
               NSLog("Top Index Path \(indexPath?.row)")
                topButton.selected = true
                topButton.enabled = false
            }
            
            
            
        }
        else{
            if let object = object {
                object.incrementKey("count")
                object.saveInBackground()
                self.tableView.reloadData()
                NSLog("Top Index Path \(indexPath?.row)")
                topButton.selected = true
                topButton.enabled = false
            }
            
        }
    }
    
    
    @IBAction func bottomButton(sender: AnyObject) {
        
        if topButton.selected == true {
            topButton.selected = false
            topButton.enabled = true
            
        
        
            if let object = object {
                object.incrementKey("count", byAmount: -2)
                object.saveInBackground()
                self.tableView.reloadData()
                NSLog("Bottom Index Path \(indexPath?.row)")
                bottomButton.selected = true
                bottomButton.enabled = false
                
                
            }
        }
            
        else{
            
            if let object = object {
                object.incrementKey("count", byAmount: -1)
                object.saveInBackground()
                self.tableView.reloadData()
                NSLog("Bottom Index Path \(indexPath?.row)")
                bottomButton.selected = true
                bottomButton.enabled = false
            }
            
        }
}
}