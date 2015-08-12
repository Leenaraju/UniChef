//
//  IngredientCell.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/21/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

class IngredientCell: UITableViewCell {
    
    @IBAction func changedTextValue(sender: AnyObject) {
        
        if let textField = sender as? UITextField where !textField.text.isEmpty {
            if let indexPath = postViewController?.tableView.indexPathForCell(self) {
                let row = indexPath.row
                postViewController?.ingredients[row] = textField.text
            }
        }
    }
    
    var postViewController: PostViewController?
    
    @IBOutlet weak var ingredientField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
