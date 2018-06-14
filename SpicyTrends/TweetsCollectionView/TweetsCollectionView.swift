//
//  TweetsCollectionView.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 31/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class TweetsCollectionView: UIView
{
    var timr=Timer()
    var w:CGFloat=0.0
    
    fileprivate let tweetCellID = "TweetCell"
    private var tweetsData:[TweetData] = []
    private var collectionView:UICollectionView!
    private let netManager = NetworkManager.init()
    private var activityIndicator:UIActivityIndicatorView!

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.startLoader()
        
        self.backgroundColor = UIColor.green

        let headerHeight:CGFloat = 30
        let sectionLabel = UILabel.init(frame: CGRect.init(x: 8, y: 0, width: 160, height: headerHeight))
        sectionLabel.text = "Related Tweets"
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 22)
        sectionLabel.textColor = UIColor.darkGray
        self.addSubview(sectionLabel)
        
        let nib = UINib(nibName: tweetCellID, bundle: nil)
        let screen = UIScreen.main.bounds
        let l = UICollectionViewFlowLayout.init();l.scrollDirection = .horizontal
        l.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let f = CGRect.init(x: 0, y: headerHeight, width: screen.width, height: self.frame.height-headerHeight)
        collectionView = UICollectionView.init(frame: f, collectionViewLayout: l)
        collectionView.register( nib, forCellWithReuseIdentifier: tweetCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        self.addSubview(collectionView)
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
        collectionView.backgroundColor = UIColor.clear
        
    }
    
    func startLoader()
    {
        let screen = UIScreen.main.bounds
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = UIColor.darkGray
        activityIndicator.center.x = (screen.width - 16) / 2
        activityIndicator.center.y = 75
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
        self.tweetsData = tweetsData
        collectionView.reloadData()
        
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
        if tweetsData.count > 0
        {
            self.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = self.heightAnchor.constraint(equalToConstant: 170)
            NSLayoutConstraint.activate([heightConstraint])
            self.backgroundColor = .clear
        }
        else
        {
            print("no tweets")
            self.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = self.heightAnchor.constraint(equalToConstant: 0)
            NSLayoutConstraint.activate([heightConstraint])
        }
    }
}

extension TweetsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width-16, height: collectionView.frame.height)
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
        cell.dateView.text = tweetsData[indexPath.row].created_at
        cell.textLabel.text = tweetsData[indexPath.row].text
        cell.authorLabel.text = tweetsData[indexPath.row].user.name
        cell.setHashTags(hashtags: tweetsData[indexPath.row].entities.hashtags)
        return cell
    }
    
    
}

extension TweetsCollectionView
{
    

    
    func configAutoscrollTimer()
    {
        
        timr=Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(autoScrollView), userInfo: nil, repeats: true)
    }
    func deconfigAutoscrollTimer()
    {
        timr.invalidate()
        
    }
    func onTimer()
    {
        autoScrollView()
    }
    
    @objc func autoScrollView()
    {
        
        let initailPoint = CGPoint(x: w,y :0)
        
        if __CGPointEqualToPoint(initailPoint, collectionView.contentOffset)
        {
            if w<collectionView.contentSize.width
            {
                w += 0.5
            }
            else
            {
                w = -self.frame.size.width
            }
            
            let offsetPoint = CGPoint(x: w,y :0)
            
            collectionView.contentOffset=offsetPoint
            
        }
        else
        {
            w=collectionView.contentOffset.x
        }
    }
    
}

