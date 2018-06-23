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
    public var trends: [Trend] = []
    let netManager = NetworkManager.init()
    
    fileprivate let trendCellID = "TrendCell"
    private var itemHeight: CGFloat = 60 // 130
    private let lineSpacing: CGFloat = 15
    private let xInset: CGFloat = 15
    private let topInset: CGFloat = 15
    
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
        TrendsData.shared.trends = trends
        self.trends = trends
        self.reloadData()
    }
}

extension TrendsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let itemWidth = UIScreen.main.bounds.width - (2 * xInset)
        let smallSize = CGSize(width: itemWidth, height: 65)
        var largeSize = CGSize(width: itemWidth, height: 0)
        let baseHeight:CGFloat = 65
        let sourceHeight:CGFloat = 33

        let trend = trends[indexPath.row]
        
        if let n = trend.news?.news
        {
            let h = heightForView(text: (n.first?.title)!, width: itemWidth-30)
            largeSize.height = baseHeight + h + sourceHeight
            return largeSize
        }
        
        if let w = trend.wiki
        {
            if w.range(of:"may refer to:") == nil && w.count > 0
            {
                let h = heightForView(text: w, width: itemWidth-30)
                largeSize.height = baseHeight + h + sourceHeight
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
        let trend = trends[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trendCellID, for: indexPath) as! TrendCell
        cell.trendNameLabel.text = trend.title
        cell.countLabel.text = "\(indexPath.row + 1)"
        cell.configureWith(indexPath: indexPath, trend: trend)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        guard let _ = customDelegate?.trendDidSelected(indexPath: indexPath) else { return }
    }
    
    func heightForView(text:String, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
}


