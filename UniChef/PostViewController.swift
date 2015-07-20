//
//  PostViewController.swift
//  UniChef
//
//  Created by Andrew/Leena on 7/15/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextFieldDelegate {
    var scoreArray = []
    
    @IBOutlet weak var postView: UITextField!
    
    var reset:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postView.delegate = self
        self.postView.becomeFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func postPressed(sender: AnyObject) {
        
        
        let testObject = PFObject(className: "recipe")
        
        testObject["text"] = self.postView.text
        testObject["count"] = 0
        testObject["replies"] = 0
        testObject.saveInBackground()
        
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    func textViewDidChange(textView: UITextField) {
        if(reset == false){
            self.postView.text = String(Array(self.postView.text)[0])
            reset = true
        }
    }
}

