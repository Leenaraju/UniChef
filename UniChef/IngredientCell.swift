//
//  IngredientCell.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/21/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

class IngredientCell: UITableViewCell {
    var indexPath: NSIndexPath?

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