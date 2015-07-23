//
//  PopUpViewController.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/22/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit


class PopUpViewController: UIViewController {
    @IBOutlet weak var searchBarPopUpView: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let headers = [
        "X-Mashape-Key":"IKUrXnbKFFmshr5HrALYklWxx5ZHp139cmGjsny82VwhkLDWGd",
        "Accept" : "application/json"
    ]
    
    
    enum State {
        case DefaultMode
        case SearchMode
    }
    
    var searchText = ""
    
    var state: State = .DefaultMode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarPopUpView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func loadObjects() {
        var escapedSearchText = searchText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        UNIRest.get {
            (request : UNISimpleRequest?)-> Void in
            request?.url = "https://nutritionix-api.p.mashape.com/v1_1/search/\(escapedSearchText!)?fields=item_name%2Citem_id%2Cbrand_name%2Cnf_calories%2Cnf_total_fat"
            request?.headers = self.headers
            }.asJsonAsync {
                (response : UNIHTTPJsonResponse?, error: NSError?) -> Void in
                if error == nil {
                    let code = response?.code
                    let responseHeaders = response?.headers
                    let body = response?.body
//                    let rawBody = response?.rawBody
//                    let names = body?.JSONObject()["item_name"] as? String
                     println(body?.JSONObject())
                    
                    
                }
                
        }
    }

}


extension PopUpViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println(searchText)
        self.searchText = searchText
        loadObjects()
    }
    
}