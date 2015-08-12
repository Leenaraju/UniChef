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
       // directions.delegate = self
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        tableView.reloadData()
        
        sizeHeaderToFit()
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
    
    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = 153
        headerView.frame = frame
        
        tableView.tableHeaderView = headerView
        
        let footerView = tableView.tableFooterView!
        
        footerView.setNeedsLayout()
        footerView.layoutIfNeeded()
        
        let height1 = footerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame1 = footerView.frame
        frame1.size.height = 491
        footerView.frame = frame1
        
        tableView.tableFooterView = footerView
    }
}
//extension PostViewController: UITextViewDelegate {
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if range.location == 0 && textView.text == "" {
//            if text == ("\n") {
//                textView.text = ("1 ")
//                var cursor: NSRange = NSMakeRange(range.location + 3, 0)
//                textView.selectedRange = cursor
//                return false
//            }
//            else {
//                textView.text = ("1 \(text)")
//            }
//        }
//        var goBackOneLine: Bool = false
//        var stringPrecedingReplacement: String = textView.text.substringToIndex(range.location)
//        var yo = stringPrecedingReplacement.componentsSeparatedByString("\n").count+1
//        var currentLine: String = "\(yo)"
//        if text.rangeOfString("\n").location == 0 || range.length == 1 {
//            var combinedText: String = textView.text.stringByReplacingCharactersInRange(range, withString: text)
//            var lines: [AnyObject] = combinedText.componentsSeparatedByString("\n").mutableCopy()
//            if range.length == 1 {
//                if textView.text.characterAtIndex(range.location) >= "0" && textView.text.characterAtIndex(range.location) <= "9" {
//                    var index: UInt = 1
//                    var c: Character = textView.text.characterAtIndex(range.location)
//                    while c >= "0" && c <= "9" {
//                        c = textView.text.characterAtIndex(range.location - index)
//                        if c == "\n" {
//                            combinedText = textView.text.stringByReplacingCharactersInRange(NSMakeRange(range.location - index, range.length + index), withString: text)
//                            lines = combinedText.componentsSeparatedByString("\n").mutableCopy()
//                            goBackOneLine = true
//                        }
//                        index++
//                    }
//                }
//                if range.location == 1 {
//                    var firstRow: String = lines.objectAtIndex(0)
//                    if firstRow.length > 3 {
//                        return false
//                    }
//                    else {
//                        if lines.count == 1 {
//                            return false
//                        }
//                        else {
//                            if lines.count > 1 {
//                                lines.removeObjectAtIndex(0)
//                            }
//                        }
//                    }
//                }
//            }
//            var linesWithoutLeadingNumbers: [AnyObject] = NSMutableArray
//            for string: String in lines {
//                var stringWithoutLeadingNumbers: String = string.copy()
//                for var i = 0; i < string.length; i++ {
//                    var c: Character = string.characterAtIndex(i)
//                    if c >= "0" && c <= "9" {
//                        stringWithoutLeadingNumbers = stringWithoutLeadingNumbers.stringByReplacingCharactersInRange(NSMakeRange(0, 1), withString: "")
//                    }
//                    else {
//                        
//                    }
//                }
//                stringWithoutLeadingNumbers = stringWithoutLeadingNumbers.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//                linesWithoutLeadingNumbers.addObject(stringWithoutLeadingNumbers)
//            }
//            var linesWithUpdatedNumbers: [AnyObject] = NSMutableArray
//            for var i = 0; i < linesWithoutLeadingNumbers.count; i++ {
//                var updatedString: String = linesWithoutLeadingNumbers.objectAtIndex(i)
//                var lineNumberString: String = "\(i + 1) "
//                updatedString = lineNumberString.stringByAppendingString(updatedString)
//                linesWithUpdatedNumbers.addObject(updatedString)
//            }
//            var combinedString: String = ""
//            for var i = 0; i < linesWithUpdatedNumbers.count; i++ {
//                combinedString = combinedString.stringByAppendingString(linesWithUpdatedNumbers.objectAtIndex(i))
//                if i < linesWithUpdatedNumbers.count - 1 {
//                    combinedString = combinedString.stringByAppendingString("\n")
//                }
//            }
//            var cursor: NSRange
//            if text.isEqualToString("\n") {
//                cursor = NSMakeRange(range.location + currentLine.length + 2, 0)
//            }
//            else {
//                if goBackOneLine {
//                    cursor = NSMakeRange(range.location - 1, 0)
//                }
//                else {
//                    cursor = NSMakeRange(range.location, 0)
//                }
//            }
//            textView.selectedRange = cursor
//            textView.setText(combinedString)
//            return false
//        }
//        return true
//}
//
//}
