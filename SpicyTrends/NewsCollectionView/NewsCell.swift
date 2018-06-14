//
//  NewsCell.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 26/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class NewsCell: UICollectionViewCell
{
    /*
    @IBOutlet public weak var authorLabel: UILabel!
    @IBOutlet public weak var dateView: UILabel!
    @IBOutlet public weak var textLabel: UILabel!
    @IBOutlet public weak var hashtagsLabel: UILabel!
    */
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.blue
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
}
