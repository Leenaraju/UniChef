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
        if topButton.selected == true {
            topButton.selected = false
            bottomButton.selected = false
              let countTotal = count.text?.toInt()
                if countTotal < 0
            {
                object?.incrementKey("count", byAmount: 1)

            }
            else{
                object?.incrementKey("count", byAmount: -1)
            }
        }
        if let object = object, id = object.objectId {
            let defaults = NSUserDefaults.standardUserDefaults()
            bottomButton.selected = false
            topButton.selected = true
            
            let num = -defaults.integerForKey(id) + 1
            
            defaults.setInteger(1, forKey: id)
            
            object.incrementKey("count", byAmount: num)
            object.saveInBackground()
            
            if let countTotal = count.text?.toInt() {
                count.text = String(countTotal + num)
            }
            
            NSLog("Top Index Path \(indexPath?.row)")
        }
        
    }
    
    
    @IBAction func bottomButton(sender: AnyObject) {
        if bottomButton.selected == true{
            bottomButton.selected = false
            let countTotal = count.text?.toInt()
            if countTotal < 0
    
                {
                    object?.incrementKey("count", byAmount: 1)
                    
            }
            else{
                object?.incrementKey("count", byAmount: -1)
            }        }
        if let object = object, id = object.objectId {
            let defaults = NSUserDefaults.standardUserDefaults()
            bottomButton.selected = true
            topButton.selected = false
            
            let num = -defaults.integerForKey(id) - 1
            
            defaults.setInteger(-1, forKey: id)
            
            object.incrementKey("count", byAmount: num)
            object.saveInBackground()
            
            if let countTotal = count.text?.toInt() {
                count.text = String(countTotal + num)
            }
            
            NSLog("Top Index Path \(indexPath?.row)")
        }
    }
}