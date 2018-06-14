//
//  NewsCollectionView.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 13/06/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class NewsCollectionView: UIView
{
    fileprivate let newsCellID = "NewsCell"
    private var newsData:[News] = []
    private var collectionView:UICollectionView!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
                
        let headerHeight:CGFloat = 30
        let sectionLabel = UILabel.init(frame: CGRect.init(x: 8, y: 0, width: 160, height: headerHeight))
        sectionLabel.text = "News"
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 22)
        sectionLabel.textColor = UIColor.darkGray
        self.addSubview(sectionLabel)
        
        let nib = UINib(nibName: newsCellID, bundle: nil)
        let screen = UIScreen.main.bounds
        let l = UICollectionViewFlowLayout.init();l.scrollDirection = .horizontal
        l.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let f = CGRect.init(x: 0, y: headerHeight, width: screen.width, height: self.frame.height-headerHeight)
        collectionView = UICollectionView.init(frame: f, collectionViewLayout: l)
        collectionView.register( nib, forCellWithReuseIdentifier: newsCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        self.addSubview(collectionView)
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.green
        collectionView.backgroundColor = UIColor.clear
    }
    
    func setNews(news:[News])
    {
        self.newsData = news
        collectionView.reloadData()
        
        if newsData.count > 0
        {
            self.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = self.heightAnchor.constraint(equalToConstant: 170)
            NSLayoutConstraint.activate([heightConstraint])
            self.backgroundColor = .clear
        }
        else
        {
            print("no news")
            self.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = self.heightAnchor.constraint(equalToConstant: 0)
            NSLayoutConstraint.activate([heightConstraint])
        }
    }
}

extension NewsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
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
        return newsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsCellID, for: indexPath) as! NewsCell
        //cell.dateView.text = n[indexPath.row].created_at
        //cell.textLabel.text = tweetsData[indexPath.row].text
        //cell.authorLabel.text = tweetsData[indexPath.row].user.name
        //cell.setHashTags(hashtags: tweetsData[indexPath.row].entities.hashtags)
        return cell
    }
    
    
}
