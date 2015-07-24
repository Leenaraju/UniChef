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
    
    @IBOutlet weak var postView: UITextField!
    @IBOutlet weak var directions: UITextView!
    
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
    
    var reset:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postView.delegate = self
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
    
    @IBAction func postPressed(sender: AnyObject) {
        var arrayOfIngredients = [String]()
        let count = tableView.numberOfRowsInSection(0)
        
        let testObject = PFObject(className: "recipe")
        
        for i in 0..<count {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! IngredientCell
            
            arrayOfIngredients.append(cell.ingredientText)
        }
        
        testObject["directions"] = self.directions.text
        testObject["text"] = self.postView.text
        
        testObject["ingredients"] = arrayOfIngredients
        testObject["ingredientsString"] = " ".join(arrayOfIngredients)
        // Andrew did this
        
        testObject["count"] = 0
        testObject["replies"] = 0
        testObject.saveInBackground()
        
        
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
    
    
    func textViewDidChange(textView: UITextField) {
        if(reset == false){
            self.postView.text = String(Array(self.postView.text)[0])
            reset = true
        }
    }
}

