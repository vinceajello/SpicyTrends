//
//  TrendCell.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 26/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class TrendCell: UICollectionViewCell
{
    @IBOutlet public weak var trendNameLabel: UILabel!
    @IBOutlet public weak var countView: UIView!
    @IBOutlet public weak var countLabel: UILabel!
    
    @IBOutlet public weak var descriptionLabel: UILabel!
    @IBOutlet public weak var sourceLabel: UILabel!
    @IBOutlet public weak var rankView: UIImageView!

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
        countView.backgroundColor = .white
        countLabel.adjustsFontSizeToFitWidth = true
        
        descriptionLabel.alpha = 0
        descriptionLabel.textColor = UIColor.gray
        descriptionLabel.backgroundColor = UIColor.clear
        descriptionLabel.numberOfLines = 0
    }
    
    func configureWith(indexPath: IndexPath,trend:Trend)
    {
        // default
        sourceLabel.text = ""
        sourceLabel.alpha = 0
        descriptionLabel.text = ""
        descriptionLabel.alpha = 0
        rankView.alpha = 0
        rankView.backgroundColor = .clear
        
        // set indexPath
        self.indexPath = indexPath

        // set counter colors
        let colors = TrendColors.init()
        let hColor = colors.hottnessColorFrom(indexPath: indexPath.row)
        countView.layer.borderColor = hColor.cgColor
        countLabel.textColor = hColor
        
        switch trend.state
        {
            case "same":
                break
            case "new":
                rankView.alpha = 1
                rankView.image = UIImage.init(named: "statusIconNEW")
                break
            case "up":
                rankView.alpha = 1
                rankView.image = UIImage.init(named: "statusIconUP")
                break
            case "down":
                rankView.alpha = 1
                rankView.image = UIImage.init(named: "statusIconDOWN")
                break
            default:
                break
        }
        
        if let n = trend.news
        {
            descriptionLabel.alpha = 1
            descriptionLabel.text = n.news.first?.title
            sourceLabel.alpha = 1
            sourceLabel.text = n.news.first?.news_source
            sourceLabel.font = UIFont.systemFont(ofSize: 15)
            return
        }
        else if let w = trend.wiki
        {
            if w.range(of:"may refer to:") == nil && w.count > 0
            {
                descriptionLabel.alpha = 1
                descriptionLabel.text = w
                sourceLabel.alpha = 1
                sourceLabel.text = "Wikipedia"
                sourceLabel.font = UIFont(name: "Hoefler Text", size: 15)
                return
            }
        }

    }
}
