//
//  TweetDetailViewController.swift
//  tweeple
//
//  Created by Sahil Arora on 9/29/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

protocol TweetDetailsViewControllerDelegate {
    func tweetFavoriteToggled(favoriteToggledTweet : Tweet) -> Void
}

class TweetDetailsViewController: UIViewController, ComposeViewControllerDelegate {

    @IBOutlet weak var retweetedImageView: UIImageView!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var retweetedImageHeight: NSLayoutConstraint!
    @IBOutlet weak var retweetedMarginTop: NSLayoutConstraint!
    
    @IBOutlet weak var userThumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var currTweet: Tweet = Tweet()
    
    var delegate: TweetDetailsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameLabel.text = currTweet.user?.name
        usernameLabel.text = "@\((currTweet.user?.screenname)!)"
        tweetLabel.text = currTweet.text
        
        userThumbImageView.setImageWithURL(NSURL(string: (currTweet.user?.profileImageUrlBigger)!))
        userThumbImageView.layer.cornerRadius = 8.0
        userThumbImageView.clipsToBounds = true
        
        timeLabel.text = currTweet.createdAtString
        
        retweetCountLabel.text = "\(currTweet.retweetedCount!)"
        favoriteCountLabel.text = "\(currTweet.favoritedCount!)"
        
        if (currTweet.retweetedStatus) != nil {
            retweetedMarginTop.constant = 10.0
            retweetedImageHeight.constant = 16.0
            
            retweetedImageView.hidden = false
            retweetedLabel.hidden = false
            retweetedLabel.text = "\((currTweet.retweetByUser?.name)!) retweeted"
        } else {
            retweetedMarginTop.constant = 0
            retweetedImageHeight.constant = 0
            
            retweetedImageView.hidden = true
            retweetedLabel.hidden = true
        }
        
        redrawFavButton()
        redrawRetweetButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var composeNavigationController = segue.destinationViewController as UINavigationController
        var composeViewController = composeNavigationController.viewControllers[0] as ComposeViewController
        
        composeViewController.templateTweet = currTweet
        if segue.identifier == "replyTweet" {
            composeViewController.newTweetType = 1
        } else if segue.identifier == "retweetTweet" {
            composeViewController.newTweetType = 2
        }
        
        composeViewController.delegate = self
    }
    
    func newTweetPosted(newTweetObj: Tweet, showOnTimeline: Bool) {
        currTweet = newTweetObj
        
        retweetCountLabel.text = "\(currTweet.retweetedCount!)"
        redrawRetweetButton()
    }
    
    @IBAction func onReply(sender: AnyObject) {
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
    }

    @IBAction func onFavorite(sender: AnyObject) {
        var params: [String:String] = [String:String]()
        
        params["id"] = currTweet.tweetIdString
        
        TwitterClient.sharedInstance.postToggleFavorite(params, isFav: currTweet.isFavorited!, completion: { (tweet, error) -> () in
            //Do something
        })
        
        currTweet.isFavorited = !(currTweet.isFavorited!)
        if currTweet.isFavorited == false {
            currTweet.favoritedCount = currTweet.favoritedCount! - 1
        } else {
            currTweet.favoritedCount = currTweet.favoritedCount! + 1
        }
        
        
        favoriteCountLabel.text = "\(currTweet.favoritedCount!)"
        redrawFavButton()

        delegate?.tweetFavoriteToggled(currTweet)
    }
    
    func redrawFavButton() {
        if currTweet.isFavorited == true {
            let favoriteOnImage = UIImage(named: "favorite_on") as UIImage
            favoriteButton.setImage(favoriteOnImage, forState: UIControlState.Normal)
        } else {
            let favoriteOffImage = UIImage(named: "favorite") as UIImage
            favoriteButton.setImage(favoriteOffImage, forState: UIControlState.Normal)
        }
    }
    
    func redrawRetweetButton() {
        if currTweet.isRetweeted == true {
            let retweetOnImage = UIImage(named: "retweet_on") as UIImage
            retweetButton.setImage(retweetOnImage, forState: UIControlState.Normal)
        } else {
            let retweetOffImage = UIImage(named: "retweet") as UIImage
            retweetButton.setImage(retweetOffImage, forState: UIControlState.Normal)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
