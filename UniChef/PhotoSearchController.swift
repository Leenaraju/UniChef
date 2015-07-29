//
//  PhotoSearchController.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/29/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class PhotoSearchController: UICollectionViewController {
    
    var searchWord: String?
    
    var indexPath: NSIndexPath?
    
    let searchbar = UISearchBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44))
    
    @IBOutlet weak var photoSearchBar: UISearchBar!
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "uploadPhoto" {
            if let vc = segue.destinationViewController as? PostViewController, cell = sender as? PhotoCell {
                // let recipe = objectAtIndexPath(cell.indexPath)
                //vc.recipe = recipe
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.delegate = self
        self.collectionView?.addSubview(searchbar)
        
        searchbar.text = searchWord
        
        loadImages()
        
    }
    
    
    private func loadImages() {
        let headers = [ "Authorization":"eb916c97225bcc704c0a",
            "Accept" : "application/json"
        ]
        let asyncConnection = UNIRest.get {
            (request : UNISimpleRequest?) -> Void in
            request?.url = "https://pixabay.com/api/?username=samo012&key=eb916c97225bcc704c0a&q=\(self.searchWord)&image_type=photo"
            request?.headers = headers
            }.asJsonAsync{
                (response : UNIHTTPJsonResponse?, error:NSError?) -> Void in
                if error == nil {
                    let code = response?.code
                    let responseHeaders = response?.headers
                    let body = response?.body
                    let rawBody = response?.rawBody
                    
                    if let images = body?.JSONObject()["previewURL"] as? [String]{
                        for image in images{
                        println(image)
                        }
                    }
                }
        }
    }
}

extension PhotoSearchController: UISearchBarDelegate {
                func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
                println(searchText)
                }
}