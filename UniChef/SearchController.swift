////
////  SearchController.swift
////  UniChef
////
////  Created by Leena Annamraju on 7/20/15.
////  Copyright (c) 2015 Andrew/Leena. All rights reserved.
////
//
import UIKit
//
class SearchController: PFQueryTableViewController {
    var recipe: PFObject?

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBAction func segControl(sender: AnyObject) {
        loadObjects()
    }
    
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "recipe")
        
        if segControl.selectedSegmentIndex == 0 {
            // search based on title
            query.whereKey("text", matchesRegex: searchText, modifiers: "i")
        }
        else{
            //search by ingredients
            let ingredients = searchText.componentsSeparatedByString(" ")
            for ingredient in ingredients {
                query.whereKey("ingredientsString", matchesRegex: ingredient, modifiers: "i")
            }
        }
        
        return query
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        if let object = object {
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchRecipeCell", forIndexPath: indexPath) as! SearchRecipeCell
            
            cell.titleLabel?.text = object["text"] as? String
            
            return cell
        }
        
        return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showD" {
            if let vc = segue.destinationViewController as? SegContainer, cell = sender as? SearchRecipeCell {
                let recipe = objectAtIndexPath(cell.indexPath)
                vc.recipe = recipe
            }
        }
    }
    
}

extension SearchController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        loadObjects()
        
        searchBar.returnKeyType = UIReturnKeyType.Done

    }
    
}
