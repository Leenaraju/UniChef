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

    
    var recipe: PFObject? {
        didSet {
            directions.text = recipe?["directions"] as? String
            
            }
            
        }
    }
