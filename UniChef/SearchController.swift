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
    
   
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "recipe"
        self.textKey = "text"
        self.pullToRefreshEnabled = true
        self.objectsPerPage = 200
    }
    
    
    @IBAction func segControl(sender: AnyObject) {
        loadObjects()
    }
    
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
        tableView.reloadData()
    }
    
    enum State {
        case DefaultMode
        case SearchMode
    }
    
    var state: State = .DefaultMode {
        didSet {
            // update notes and search bar whenever State changes
            switch (state) {
            case .DefaultMode:
                searchBar.resignFirstResponder() // 3
                searchBar.showsCancelButton = false
            case .SearchMode:
                let searchText = searchBar?.text ?? ""
                searchBar.setShowsCancelButton(true, animated: true) //4
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "recipe")
        query.whereKey("text", matchesRegex: searchText, modifiers: "i")
        
//            let ingredients = searchText.componentsSeparatedByString(" ")
//            for ingredient in ingredients {
//                query.whereKey("ingredientsString", matchesRegex: ingredient, searchText, modifiers: "i")
//            }
        
        
        query.includeKey("users")
        
        return query
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        performSegueWithIdentifier("showDetails", sender: cell)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath) as! TableViewCell
        
        if let object = object, id = object.objectId {
            
            cell.recipeText.text = object.valueForKey("text") as? String
            cell.recipeText.numberOfLines = 0
            let score = object.valueForKey("count") as! Int
            if let timeAgo = object.createdAt?.timeAgoSimple {
                cell.time.text = timeAgo + " ago"
            }
            cell.count.text = "\(score)"
            cell.indexPath = indexPath
            cell.object = object
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            if defaults.integerForKey(id) == -1 {
                cell.topButton.selected = false
                cell.bottomButton.selected = true
            } else if defaults.integerForKey(id) == 1 {
                cell.topButton.selected = true
                cell.bottomButton.selected = false
            } else {
                cell.topButton.selected = false
                cell.bottomButton.selected = false
            }
            
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails" {
            if let vc = segue.destinationViewController as? SegContainer, cell = sender as? TableViewCell {
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
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        state = .DefaultMode
    }
    
}
