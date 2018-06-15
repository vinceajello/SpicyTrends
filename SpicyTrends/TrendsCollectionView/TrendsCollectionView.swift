//
//  TrendsCollectionView.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 26/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

protocol TrendsCollectionViewDelegate
{
    func trendDidSelected(indexPath:IndexPath)
}

class TrendsCollectionView: UICollectionView
{
    public var firstLoad:Bool = false
    public var trends: [Trend] = []
    let netManager = NetworkManager.init()
    
    fileprivate let trendCellID = "TrendCell"
    private var itemHeight: CGFloat = 60 // 130
    private let lineSpacing: CGFloat = 10
    private let xInset: CGFloat = 5
    private let topInset: CGFloat = 0
    
    var customDelegate: TrendsCollectionViewDelegate?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        
        let nib = UINib(nibName: trendCellID, bundle: nil)
        self.register( nib, forCellWithReuseIdentifier: trendCellID)
        self.contentInset.bottom = itemHeight
        
        self.layoutCollectionView()
    }
    
    func layoutCollectionView()
    {
        self.backgroundColor = .clear

        guard let layout = self.collectionViewLayout as? VegaScrollFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.collectionViewLayout.invalidateLayout()
    }
    
    func setTrends(trends:[Trend])
    {
        firstLoad = true
        self.trends = trends
        self.reloadData()
    }
}

extension TrendsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TrendCellDelegate
{
    
    func cellDidFinishLoading(indexPath: IndexPath)
    {
        //let layout = self.collectionViewLayout as! VegaScrollFlowLayout
        //layout.invalidateLayout()
        
        let layout = VegaScrollFlowLayout()
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        self.setCollectionViewLayout(layout, animated: false)
        
        if firstLoad == true
        {
            firstLoad = false
            //xself.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
        let smallSize = CGSize(width: itemWidth, height: 70)
        let largeSize = CGSize(width: itemWidth, height: 130)

        let word = trends[indexPath.row]
        guard let news = TrendsData.shared.news[word.title] else {return smallSize}
        guard let wiki = TrendsData.shared.wikis[word.title] else {return smallSize}
        
        if news.count > 0
        {
            return largeSize
        }
        
        if wiki.count > 0
        {
            if wiki != "no-data"
            {
                return largeSize
            }
        }
        
        return smallSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return trends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trendCellID, for: indexPath) as! TrendCell
        let trend = trends[indexPath.row]
        cell.delegate = self
        cell.configureWith(indexPath: indexPath, trend: trend)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {        
        guard let _ = customDelegate?.trendDidSelected(indexPath: indexPath) else { return }
    }
}
