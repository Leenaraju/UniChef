//
//  SearchController.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/20/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
 
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    enum State {
        case DefaultMode
        case SearchMode
    }
    
    var searchText = ""
    
    var state: State = .DefaultMode
    private func loadObjects() {
        
        let object = PFObject(className: "recipe")
        let ingredientList: AnyObject? = object["ingredients"]
      //  return ingredientList

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SearchController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println(searchText)
        self.searchText = searchText
        loadObjects()
    }
    
}
