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
    
    var cell: IngredientCell?
    
    @IBOutlet weak var postView: UITextField!
    @IBOutlet weak var directions: UITextView!
    @IBOutlet weak var imagePost: UIImageView!
    
    @IBAction func clearButton(sender: AnyObject) {
        resetUI()
    }
    
    @IBAction func addIngredient(sender: AnyObject) {
        ingredients.append("")
        
        var indexPath = NSIndexPath(forRow: ingredients.count-1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? IngredientCell {
            cell.ingredientField.becomeFirstResponder()
        }
    }
    
    func resetUI(){
        view.endEditing(true)
        directions.text = "How is this made?"
        postView.text = ""
        ingredients = []
        imagePost.image = UIImage(named: "AddPhoto")
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postView.delegate = self
        directions.delegate = self
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Ingredient", forIndexPath: indexPath) as! IngredientCell
        cell.postViewController = self
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
            
            let testObject = PFObject(className: "recipe")
            
            testObject["directions"] = self.directions.text
            testObject["photo"] = self.imageString
            testObject["text"] = self.postView.text
            testObject["users"] = PFUser.currentUser()
            testObject["ingredients"] = ingredients
            testObject["ingredientsString"] = " ".join(ingredients)
            testObject["flaggedCount"] = 0
            testObject["count"] = 0
            testObject.saveInBackground()
            resetUI()
            self.tabBarController?.selectedIndex = 0
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



