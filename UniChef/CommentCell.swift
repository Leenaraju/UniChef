class CommentCell: PFTableViewCell {
    weak var viewController : CommentsViewController?
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    
    var data : PFObject? {
        didSet {
            loadContentLabel()
            loadTimeLabel()
            loadUsername()
            loadProfilePic()
            
            var tgr = UITapGestureRecognizer(target:self, action:Selector("usernameTapped:"))
            profilePic.addGestureRecognizer(tgr)
        }
    }
    
    private func loadContentLabel() {
        if let text = data?["text"] as? String {
            contentLabel.text = text
        }
    }
    
    private func loadTimeLabel() {
        if let date = data?["postedAt"] as? NSDate {
            timeLabel.text = date.timeAgoSimple
        }
    }
    
    private func loadUsername() {
        if let usernameString = data?["fromUser"]?["username"] as? String {
            username.setTitle(usernameString, forState: UIControlState.Normal)
        }
    }
    
    private func loadProfilePic() {
        let imageName = "defaultProfilePic.png"
        
        profilePic.image = UIImage(named: imageName)
        profilePic.layer.cornerRadius = profilePic.frame.width / 2
        
        if let profilePicThumb = data?["fromUser"]?["profilePicThumb"] as? PFFile {
            if let url = profilePicThumb.url {
                profilePic.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: imageName))
            }
        } else {
            if let profilePicStringUrl = data?["fromUser"]?["profilePic"] as? String {
                if let url = NSURL(string: profilePicStringUrl) {
                    profilePic.sd_setImageWithURL(url, placeholderImage: UIImage(named: imageName))
                }
            }
        }
}

}