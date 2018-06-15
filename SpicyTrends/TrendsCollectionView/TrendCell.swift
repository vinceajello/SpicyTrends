//
//  TrendCell.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 26/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

protocol TrendCellDelegate
{
    func cellDidFinishLoading(indexPath:IndexPath)
}

class TrendCell: UICollectionViewCell
{
    let netManager = NetworkManager.init()
    var delegate:TrendCellDelegate!
    
    @IBOutlet private weak var trendNameLabel: UILabel!
    @IBOutlet private weak var countView: UIView!
    @IBOutlet public weak var countLabel: UILabel!
    
    @IBOutlet public weak var descriptionLabel: UILabel!
    @IBOutlet public weak var activityView: UIActivityIndicatorView!
    var loader: AJProgressView!

    var indexPath:IndexPath!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.masksToBounds = false
        
        trendNameLabel.adjustsFontSizeToFitWidth = true
        
        countView.layer.cornerRadius = countView.frame.size.width / 2
        countView.clipsToBounds = true
        countView.layer.borderColor = UIColor.lightGray.cgColor
        countView.layer.borderWidth = 1
        countView.backgroundColor = .clear
        countLabel.adjustsFontSizeToFitWidth = true
        
        descriptionLabel.alpha = 0
        descriptionLabel.textColor = UIColor.lightGray
    }
    
    func configureWith(indexPath: IndexPath,trend:Trend)
    {
        // set title
        trendNameLabel.text = trend.title
        
        // set counter
        countLabel.text = "\(indexPath.row + 1)"
        
        // set indexPath
        self.indexPath = indexPath

        // set counter colors
        let colors = TrendColors.init()
        let hColor = colors.hottnessColorFrom(indexPath: indexPath.row)
        countView.layer.borderColor = hColor.cgColor
        countLabel.textColor = hColor
        
        // configure description wiki / news
        self.configureDescription(word: trend.title)
    }
    
    func configureDescription(word:String)
    {
        printSafe(string: "Configure cell with word : \(word)")
        var news:[News] = []
        var wiki = ""
        if let w = TrendsData.shared.wikis[word] { wiki = w }
        if let n = TrendsData.shared.news[word] { news = n }

        if wiki.count > 0 || news.count > 0
        {
            printSafe(string: "News for \(word) : \(String(describing: news))")
            printSafe(string: "Wiki for \(word) : \(String(describing: wiki))")
            self.updateDescription(word: word)
        }
        else
        {
            printSafe(string: "!!! No news or wiki found for word \(word)")
            self.getDescription(word: word)
        }
    }
    
    func getDescription(word:String)
    {
        activityView.startAnimating()

        netManager.getDescriptionByKeyword(word: word)
        {
            (success, response) in
            
            self.activityView.stopAnimating()
            self.activityView.alpha = 0
            
            if success != true
            {
                TrendsData.shared.status[word] = "network-error"
                //TrendsData.shared.news[word] = "network-error"
                //TrendsData.shared.wikis[word] = "network-error"
                return
            }
            
            var news:[News] = []
            var wiki = "no-data"
            
            if let n = response?.news.news
            { if n.count > 0 { news = n } }
            
            if let w = response?.wiki
            { if w.count > 0 { wiki = w } }
            
            self.printSafe(string: "News Response for word \(word) : \(news)")
            self.printSafe(string: "Wiki Response for word \(word) : \(wiki)")
            
            TrendsData.shared.news[word] = news
            TrendsData.shared.wikis[word] = wiki
            
            self.updateDescription(word: word)
            guard let _ = self.delegate?.cellDidFinishLoading(indexPath: self.indexPath) else { return }
        }
    }
    
    func updateDescription(word:String)
    {
        var news = "";var wiki = ""
        if let w = TrendsData.shared.wikis[word] { wiki = w }
        if let n = TrendsData.shared.news[word]
        {
            if n.count >= 0
            {
                news = n[0].title
            }
        }
        
        if news.count > 0 && news != "no-data"
        {
            self.descriptionLabel.text = news
            self.descriptionLabel.alpha = 1
        }
        else if wiki.count > 0 && wiki != "no-data"
        {
            self.descriptionLabel.text = wiki
            self.descriptionLabel.alpha = 1
        }
        else
        {
            self.descriptionLabel.text = ""
            self.descriptionLabel.alpha = 0
        }
        self.activityView.alpha = 0
    }
}

extension TrendCell
{
    func printSafe(string:String)
    {
        //print("Quick_Disable \(string)")
    }
}
