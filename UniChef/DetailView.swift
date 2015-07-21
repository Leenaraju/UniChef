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
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!

    
    var recipe: PFObject? {
        didSet {
            recipeLabel.text = recipe?["text"] as? String
            descriptionLabel.text = recipe?["description"] as? String
            if let file = recipe?["photo"] as? PFFile, urlString = file.url, url = NSURL(string: urlString) {
                recipeImage.sd_setImageWithURL(url)
            }
          
        }
    }
}