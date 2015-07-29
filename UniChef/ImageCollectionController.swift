

class ImageCollectionController: UICollectionViewController {
    

    let headers = ["Api-Key" : "4emppqe237p9bajtqa43dvb5",
        "Accept" : "application/json"]
    
      //Secret: eV7W758ZsnAE6xRSgkksgp82we7AUrWDK2vq9DKGAVWGC
    
            let asyncConnection = UNIRest.get {
                    (request : UNISimpleRequest?) -> Void in
                    request?.url = "https://api.gettyimages.com/v3/search/images/creative?phrase=\(searchWord)"
                    request?.headers = headers
                    }.asJsonAsync {
                    (response : UNIHTTPJsonResponse?, error: NSError?) -> Void in
                    if error == nil {
                        let code = response?.code
                        let responseHeaders = response?.headers
                        let body = response?.body
                        let rawBody = response?.rawBody
}
}
}

private let reuseIdentifier = "imageCell"
private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

private var searches = [FlickrSearchResults]()
private let flickr = Flickr()

func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
}
}

extension ImageCollectionController : UICollectionViewDataSource {
    
    //1
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return searches.count
    }
    
    //2
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return searches[section].searchResults.count
    }
    
    //3
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCell
        //2
        let flickrPhoto = photoForIndexPath(indexPath)
        cell.backgroundColor = UIColor.blackColor()
        //3
        cell.imageView.image = flickrPhoto.thumbnail
        
        return cell
    }
    
}

extension ImageCollectionController : UITextFieldDelegate {
            func textFieldShouldReturn(textField: UITextField) -> Bool {
            // 1
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            textField.addSubview(activityIndicator)
            activityIndicator.frame = textField.bounds
            activityIndicator.startAnimating()
            flickr.searchFlickrForTerm(textField.text) {
            results, error in
            
            //2
            activityIndicator.removeFromSuperview()
            if error != nil {
    println("Error searching : \(error)")
            }
            
            if results != nil {
                //3
                println("Found \(results!.searchResults.count) matching \(results!.searchTerm)")
                self.searches.insert(results!, atIndex: 0)
                
                //4
                self.collectionView?.reloadData()
            }
            }
            
            textField.text = nil
            textField.resignFirstResponder()
            return true
            }
}

extension ImageCollectionController : UICollectionViewDelegateFlowLayout {
                    //1
                    func collectionView(collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
                
                let flickrPhoto =  photoForIndexPath(indexPath)
                //2
                if var size = flickrPhoto.thumbnail?.size {
                size.width += 10
                size.height += 10
                return size
                }
                return CGSize(width: 100, height: 100)
                    }
                    
                    //3
                    func collectionView(collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    insetForSectionAtIndex section: Int) -> UIEdgeInsets {
                    return sectionInsets
                    }
}
