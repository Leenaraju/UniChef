//
//  SegContainer.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/23/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

class SegContainer: UIViewController {
    
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var commentContainer: UIView!
    @IBOutlet weak var instructionContainer: UIView!
    
   
    var recipe: PFObject?
    
   
    
    @IBAction func shareText(sender: UIBarButtonItem) {
        
        var nameText = PFUser.currentUser()?["name"] as! String
        if PFUser.currentUser()?["name"] == nil{
            nameText = "Someone"
        }
        
        var name = recipe?["text"] as! String
        if recipe?["text"] == nil{
            name = ""
        }
        let image = UIImageView()
        if let url = recipe?["photo"] as? String {
            if let urlString = NSURL(string: url) {
                let pImage = UIImage(named: "cutlery")
                image.sd_setImageWithURL(urlString, placeholderImage: pImage)
                
            }
        }

        var testText = "\(nameText) sent you the recipe: \(name). Check out the app Edible to view this recipe."
        
        
        let activityViewController = UIActivityViewController(
            activityItems: [testText as NSString,image as UIImageView],
            applicationActivities: nil)
        
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    @IBAction func segChanged(sender: AnyObject) {
        switch segControl.selectedSegmentIndex
        {
        case 0:
            commentContainer.hidden = false
            instructionContainer.hidden = true
        case 1:
            commentContainer.hidden = true
            instructionContainer.hidden = false

            
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        var white : UIColor = UIColor.blackColor()
        segControl.layer.borderColor = white.CGColor
        commentContainer.hidden = false
        instructionContainer.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showIngredients" {
            if let vc = segue.destinationViewController as? InstructionsViewController {
                vc.recipe = recipe
                
                
            }
        }
        if segue.identifier == "showComments" {
            if let vc = segue.destinationViewController as? CommentsViewController {
                vc.recipe = recipe
                
                
            }
        }

    }
}