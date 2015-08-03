//
//  SegContainer.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/23/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

class SegContainer: UIViewController {
    var recipe: PFObject?
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var commentContainer: UIView!
    @IBOutlet weak var instructionContainer: UIView!
    
    @IBOutlet weak var flaggedContent: UIBarButtonItem!
    
    @IBOutlet weak var flagButton: UIBarButtonItem!
    @IBAction func flaggedContent(sender: AnyObject) {
        
        let alertController = UIAlertController(
            title: "Report Content",
            message: "Would you like to flag this recipe as inappropriate?",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(
            title: "Yes",
            style: UIAlertActionStyle.Default){ (action) in
                self.recipe?.incrementKey("flaggedCount")
                let flagCount = self.recipe?.valueForKey("flaggedCount") as! Int
                self.flagButton.enabled = false
        }
            
            let no = UIAlertAction(
                title: "No",
                style: UIAlertActionStyle.Default) { (action) in
        }
        
        alertController.addAction(ok)
        alertController.addAction(no)
        self.presentViewController(alertController, animated: true, completion: nil)
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
        
        commentContainer.hidden = false
        instructionContainer.hidden = true
        // Do any additional setup after loading the view.
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