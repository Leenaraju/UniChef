//
//  DetailViewController.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/15/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit


class DetailView: UIView {

    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var directions: UITextView!

    
    var recipe: PFObject? {
        didSet {
            recipeLabel.text = recipe?["text"] as? String
            directions.text = recipe?["directions"] as? String
            if let file = recipe?["photo"] as? PFFile, urlString = file.url, url = NSURL(string: urlString) {
                recipeImage.sd_setImageWithURL(url)
            }
          
        }
    }
}