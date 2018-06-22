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
    let headerHeight:CGFloat = 20
    let totalHeight:CGFloat = 120
    fileprivate let newsCellID = "NewsCell"
    public var newsData:[News] = []
    public var collectionView:UICollectionView!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
                
        let sectionLabel = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: 60, height: headerHeight))
        sectionLabel.text = "News"
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 22)
        sectionLabel.textColor = UIColor.darkGray
        self.addSubview(sectionLabel)
        
        let nib = UINib(nibName: newsCellID, bundle: nil)
        let screen = UIScreen.main.bounds
        let l = UICollectionViewFlowLayout.init();l.scrollDirection = .horizontal
        l.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let f = CGRect.init(x: 0, y: headerHeight+5, width: screen.width-30, height: totalHeight-headerHeight)
        collectionView = UICollectionView.init(frame: f, collectionViewLayout: l)
        collectionView.register( nib, forCellWithReuseIdentifier: newsCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        self.addSubview(collectionView)
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        collectionView.backgroundColor = UIColor.clear
    }
    
    func setNews(news:[News])
    {
        self.newsData = news
        collectionView.reloadData()
        
        if newsData.count > 0
        {
            self.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = self.heightAnchor.constraint(equalToConstant: totalHeight+5)
            NSLayoutConstraint.activate([heightConstraint])
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
        return CGSize(width: collectionView.frame.width-10, height: collectionView.frame.height)
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
        cell.titleLabel.text = newsData[indexPath.row].title
        cell.sourceLabel.text = newsData[indexPath.row].news_source
        cell.loadImage(url: newsData[indexPath.row].image)
        return cell
    }
}
