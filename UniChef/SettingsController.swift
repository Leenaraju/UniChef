//
//  SettingsController.swift
//  UniChef
//
//  Created by Leena Annamraju on 8/3/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRules" {
            if let vc = segue.destinationViewController as? ImportantStuff {
                let title = "dese r da rules"
                vc.importantStr = title
            }
        }
        if segue.identifier == "showPrivacy" {
            if let vc = segue.destinationViewController as? ImportantStuff {
                let title = "dis is da privacy"
                vc.importantStr = title
            }
        }
        if segue.identifier == "showTerms" {
            if let vc = segue.destinationViewController as? ImportantStuff {
                let title = "terms bitch"
                vc.importantStr = title
            }
        }

    }

}