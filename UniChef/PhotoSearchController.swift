//
//  PhotoSearchController.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/29/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit

class PhotoSearchController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var searchWord = ""
    var imagesURLs = [String]()
    
    var indexPath: NSIndexPath?
    
    var selectedImage = ""
    
    let searchbar = UISearchBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44))
    
    @IBOutlet weak var photoSearchBar: UISearchBar!
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "uploadPhoto" {
            if let vc = segue.destinationViewController as? PostViewController, cell = sender as? PhotoCell {
                
                let recipe = cell.imageView.image
                let playButton  = vc.imagePost
                playButton?.setImage(recipe, forState: .Normal)
               
                
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
    
    override func numberOfSectionsInCollectionView(collectionView:
        UICollectionView) -> Int {
            return 1
    }
    
    override func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return imagesURLs.count
    }
    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) ->
        UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell",
                forIndexPath: indexPath) as! PhotoCell
            
            
            if let url = NSURL(string: imagesURLs[indexPath.row]) {
                
                cell.imageView.sd_setImageWithURL(url, placeholderImage: nil)
            }
            return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedImage = imagesURLs[indexPath.row]
        self.performSegueWithIdentifier("popping", sender: nil)
    }
    
    private func loadImages() {
        if let text = self.searchWord.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet()) {
            let asyncConnection = UNIRest.get {
                (request : UNISimpleRequest?) -> Void in
                request?.url = "https://pixabay.com/api/?username=samo012&key=eb916c97225bcc704c0a&q=\(text)&image_type=photo"
                }.asJsonAsync{
                    (response : UNIHTTPJsonResponse?, error:NSError?) -> Void in
                    if error == nil {
                        let body = response?.body
                        
                        if let images = body?.JSONObject()["hits"] as? [[String: AnyObject]] {
                            self.imagesURLs = []
                            
                            for image in images {
                                if let url = image["previewURL"] as? String {
                                self.imagesURLs.append(url)
                                }
                            }
                            dispatch_async(dispatch_get_main_queue(),{
                                self.collectionView?.reloadData()
                                })
                        }
                    }
            }
        }
    }
}

extension PhotoSearchController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    self.searchWord = searchText
    loadImages()
    }
}