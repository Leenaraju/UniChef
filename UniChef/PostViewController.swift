//
//  PostViewController.swift
//  UniChef
//
//  Created by Andrew/Leena on 7/15/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

class PostViewController: UITableViewController, UITextFieldDelegate {
    
    var ingredients: [String] = []
    
    var imageString: String = ""
    
    @IBOutlet weak var postView: UITextField!
    @IBOutlet weak var directions: UITextView!
    
    @IBOutlet weak var imagePost: UIImageView!
    
    
    
    
    @IBAction func addIngredient(sender: AnyObject) {
        ingredients.append("")
        
        var indexPath = NSIndexPath(forRow: ingredients.count-1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
        
        //        tableView.reloadData()
        //
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewControllerWithIdentifier("popUpVC") as! UIViewController
        //        vc.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        //        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    //var reset:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postView.delegate = self
        directions.delegate = self
        
        //  self.postView.becomeFirstResponder()
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        tableView.reloadData()
        
        
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Ingredient", forIndexPath: indexPath) as! IngredientCell
        
        cell.ingredientField.text = ingredients[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    
    func textField(postView: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = count(postView.text.utf16) + count(string.utf16) - range.length
        return newLength <= 25 // Bool
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPhoto" {
            if let vc = segue.destinationViewController as? PhotoSearchController {
                let title = self.postView.text
                vc.searchWord = title
            }
        }
    }
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
        if segue.identifier == "popping" {
            if let vc = segue.sourceViewController as? PhotoSearchController {
                let urlString = vc.selectedImage
                imageString = urlString
                if let url = NSURL(string: urlString) {
                    imagePost.sd_setImageWithURL(url, placeholderImage: nil)
                }
                // change image here to url
            }
        }
    }
    
    @IBAction func postPressed(sender: AnyObject) {
        if (self.postView.text.isEmpty) || (self.directions.text == "How is this made?"){
            
            let alert = UIAlertView()
            alert.title = "No Text"
            alert.message = "Please complete all fields before submitting your recipe."
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
            
        else {
            
            var arrayOfIngredients = [String]()
            let count = tableView.numberOfRowsInSection(0)
            
            let testObject = PFObject(className: "recipe")
            
            for i in 0..<count {
                let indexPath = NSIndexPath(forRow: i, inSection: 0)
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! IngredientCell
                
                arrayOfIngredients.append(cell.ingredientText)
            }
            
            testObject["directions"] = self.directions.text
            testObject["photo"] = self.imageString
            testObject["text"] = self.postView.text
            testObject["users"] = PFUser.currentUser()
            testObject["ingredients"] = arrayOfIngredients
            testObject["ingredientsString"] = " ".join(arrayOfIngredients)
            testObject["flaggedCount"] = 0
            testObject["count"] = 0
            testObject.saveInBackground()
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
}
extension PostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "How is this made?" {
            textView.font = UIFont (name: "Avenir-Book", size: 14)
            textView.text = "1.  "
            
        }
    }
    
    
}

//func textViewDidEndEditing(textView: UITextView) {
//    if textView.text == "" {
//        textView.text = "How is this made?"
//    }
//}


