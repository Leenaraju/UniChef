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
        println(data?["fromUser"])
        if let user = data?["fromUser"] as? PFUser, name = user["name"] as? String {
            username.setTitle(name, forState: UIControlState.Normal)
        }
    }
    
    private func loadProfilePic() {
        
        if let file = data?["fromUser"] as? PFUser, image = file["profilePic"] as? PFFile, urlString = image.url, url = NSURL(string: urlString) {
            profilePic.sd_setImageWithURL(url)
        }
  
        
        profilePic.layer.cornerRadius = profilePic.frame.width / 2
    }

}