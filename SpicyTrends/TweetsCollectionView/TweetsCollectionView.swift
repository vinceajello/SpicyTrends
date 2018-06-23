//
//  TweetsCollectionView.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 31/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

protocol TweetsCollectionViewDelegate
{
    func tweetsDidLoad()
}

class TweetsCollectionView: UIView
{
    fileprivate let tweetCellID = "TweetCell"
    public var tweetsData:[TweetData] = []
    public var collectionView:UICollectionView!
    private let netManager = NetworkManager.init()
    private var activityIndicator:UIActivityIndicatorView!
    public var delegate:TweetsCollectionViewDelegate!

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.startLoader()
        
        let headerHeight:CGFloat = 20
        let sectionLabel = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: 160, height: headerHeight))
        sectionLabel.text = "Related Tweets"
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 22)
        sectionLabel.textColor = UIColor.darkGray
        self.addSubview(sectionLabel)
        
        let nib = UINib(nibName: tweetCellID, bundle: nil)
        let screen = UIScreen.main.bounds
        let l = UICollectionViewFlowLayout.init();l.scrollDirection = .horizontal
        l.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        let f = CGRect.init(x: 0, y: headerHeight + 5, width: screen.width-30, height: 100)
        collectionView = UICollectionView.init(frame: f, collectionViewLayout: l)
        collectionView.register( nib, forCellWithReuseIdentifier: tweetCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        self.addSubview(collectionView)
        
        self.clipsToBounds = false
        self.backgroundColor = UIColor.clear
        collectionView.backgroundColor = UIColor.clear
    }
    
    func startLoader()
    {
        let screen = UIScreen.main.bounds
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = UIColor.darkGray
        activityIndicator.center.x = (screen.width - 20) / 2
        activityIndicator.center.y = 75
        activityIndicator.color = UIColor.red
        activityIndicator.tintColor = UIColor.green
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func getTweets(word:String,region:String)
    {
        netManager.getTweets(word: word, region: region)
        {
            (tweetsData, error) in
            
            if error != nil
            {
                print("get tweets fail")
                return
            }
            self.setTweets(tweetsData: tweetsData!)
        }
    }
    
    func setTweets(tweetsData:[TweetData])
    {
        if tweetsData.count > 0
        {
            self.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = self.heightAnchor.constraint(equalToConstant: 130)
            NSLayoutConstraint.activate([heightConstraint])
        }
        else
        {
            print("no tweets")
            self.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = self.heightAnchor.constraint(equalToConstant: 0)
            NSLayoutConstraint.activate([heightConstraint])
        }
        
        self.tweetsData = tweetsData
        collectionView.reloadData()
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
        guard let _ = delegate?.tweetsDidLoad() else { return }
    }
}

extension TweetsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width-30, height: collectionView.frame.height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return tweetsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tweetCellID, for: indexPath) as! TweetCell
        cell.dateView.text = "@"+tweetsData[indexPath.row].user.screen_name
        cell.textLabel.text = tweetsData[indexPath.row].text
        cell.authorLabel.text = tweetsData[indexPath.row].user.name
        cell.setHashTags(hashtags: tweetsData[indexPath.row].entities.hashtags)
        return cell
    }
    
    
}

