//
//  ImportantStuff.swift
//  UniChef
//
//  Created by Leena Annamraju on 8/3/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

class ImportantStuff: UIViewController {

    @IBOutlet weak var importantText: UITextView!
    var importantStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        importantText.text = importantStr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
