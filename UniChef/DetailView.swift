//
//  DetailViewController.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/15/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit


class DetailView: UIView {
    
    weak var viewController : UIViewController?
    
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var username: UIButton!
    
    @IBAction func username(sender: AnyObject) {
        viewController?.performSegueWithIdentifier("openProfile", sender: recipe?["users"] as? PFUser)
        
    }
    
    var recipe: PFObject? {
        didSet {
            recipeLabel.text = recipe?["text"] as? String
            recipeImage.image = nil
            
            if let user = recipe?["users"] as? PFUser, name = user["name"] as? String {
                username.setTitle("By: \(name)", forState: .Normal)
            }
            
            if let url = recipe?["photo"] as? String {
                if let urlString = NSURL(string: url) {
                    let pImage = UIImage(named: "cutlery")
                    recipeImage.sd_setImageWithURL(urlString, placeholderImage: pImage)
                    
                }
            }
            
            
        }
    }
}
