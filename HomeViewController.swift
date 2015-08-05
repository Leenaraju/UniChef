

//
//  HomeViewController.swift
//  UniChef
//
//  Created by Leena Annamraju on 8/4/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate {
    @IBAction func segChanged(sender: AnyObject) {
        tableViewController.changedSegIndexTo(segControl.selectedSegmentIndex)
    }
    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBOutlet var searchBarButtonItem: UIBarButtonItem!
    
    var tableViewController: TableViewController!
    

    @IBOutlet var searchBar : UISearchBar? = UISearchBar()

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar!.delegate = self;
        
        searchBar!.searchBarStyle = UISearchBarStyle.Minimal
                searchBarButtonItem = navigationItem.rightBarButtonItem
                //        searchBar.showsCancelButton = true
                searchBar.barTintColor = UIColor(red: 0.5, green: 0.5, blue: 0.431, alpha: 1)
                searchBar.tintColor = UIColor(red: 0.137, green: 0.408, blue: 0.431, alpha: 1)
                searchBar.backgroundImage = UIImage(named: "bgimage.png")
                searchBar.placeholder = "Find the events!"
                searchBar.autocorrectionType = UITextAutocorrectionType.Yes
                searchBar.autocapitalizationType = UITextAutocapitalizationType.Sentences

    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTable" {
            tableViewController = segue.destinationViewController as! TableViewController
        }
    }


}
