//
//  LoadMoreCell.swift
//  iScoot
//
//  Created by Abdulrahman AlZanki on 7/5/15.
//  Copyright (c) 2015 Abdulrahman AlZanki. All rights reserved.


import Foundation

class LoadMoreCell: UITableViewCell {
    
    // Check if this is gonna leak in the future
    weak var vc : CommentsViewController? {
        didSet {
            loadMoreButton.setTitle("Load More", forState: UIControlState.Normal)
        }
    }
    
    @IBOutlet weak var loadMoreButton: UIButton!
    
    @IBAction func loadMoreTapped(sender: AnyObject) {
        loadMoreButton.setTitle("Loading...", forState: UIControlState.Normal)
        vc?.loadNextPage()
    }
}