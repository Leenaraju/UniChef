//
//  ProfileViewController.swift
//  UniChef
//
//  Created by Leena Annamraju on 7/20/15.
//  Copyright (c) 2015 Andrew/Leena. All rights reserved.
//

import UIKit



class ProfileViewController: UIViewController {

    @IBOutlet weak var upvotedCount: UILabel!
    
    @IBOutlet weak var uploadedCount: UILabel!
    
    @IBOutlet weak var browniePoints: UILabel!
    
    @IBOutlet weak var upvoted: UIButton!
    
    @IBOutlet weak var uploaded: UIButton!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    private func loadUpvotes() {
        if let text = PFUser.currentUser()?["text"] as? String {
            upvotedCount.text = text
        }
    }
    
    private func loadUploaded() {
        if let text = PFUser.currentUser()?["text"] as? String {
            uploadedCount.text = text
        }
    }
    
    
    private func loadUsername() {
        if let usernameString = PFUser.currentUser()?["name"] as? String {
         username.text = usernameString
        }
    }
    
    private func loadProfilePic() {
        let imageName = "defaultProfilePic.png"
        
        profilePic.image = UIImage(named: imageName)
        profilePic.layer.cornerRadius = profilePic.frame.width / 2
        
        if let profilePicThumb = PFUser.currentUser()?["fromUser"]?["profilePicThumb"] as? PFFile {
            if let url = profilePicThumb.url {
                profilePic.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: imageName))
            }
        } else {
            if let profilePicStringUrl = PFUser.currentUser()?["fromUser"]?["profilePic"] as? String {
                if let url = NSURL(string: profilePicStringUrl) {
                    profilePic.sd_setImageWithURL(url, placeholderImage: UIImage(named: imageName))
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUpvotes()
        loadUploaded()
        loadUsername()
        
        var tgr = UITapGestureRecognizer(target:self, action:Selector("usernameTapped:"))
        profilePic.addGestureRecognizer(tgr)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}
