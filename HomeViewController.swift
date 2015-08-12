

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
    
    lazy var searchBars:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 297, 20))
    
    var searchText = ""
    
    @IBAction func searchButton(sender: AnyObject) {
        var rightNavBarButton = UIBarButtonItem(customView: searchBars)
        searchBars.delegate = self
        searchBars.becomeFirstResponder()
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        searchBars.placeholder = "Search by recipe or ingredients"
        searchBars.searchBarStyle = UISearchBarStyle.Prominent
        searchBars.autocorrectionType = UITextAutocorrectionType.Yes
        searchBars.tintColor = UIColor.grayColor()
        searchBars.barTintColor = UIColor.whiteColor()
        
        
    }
    
    enum State {
        case DefaultMode
        
        case SearchMode
    }
    
    var state: State = .DefaultMode {
        didSet {
            switch (state) {
            case .DefaultMode:
                searchBars.resignFirstResponder()
                searchBars.showsCancelButton = false
                self.navigationItem.rightBarButtonItem = searchBarButtonItem
                
            case .SearchMode:
                let searchText = searchBars.text ?? ""

                searchBars.setShowsCancelButton(true, animated: true) //4
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTable" {
            tableViewController = segue.destinationViewController as! TableViewController
        }
    }
    
    
}
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        tableViewController.searchWithText(searchText)
        //loadObjects()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        state = .SearchMode
        tableViewController.isSearching = true
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        state = .DefaultMode
        tableViewController.isSearching = false
    }
    
}
