//
//  TweetCell.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 26/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class TweetCell: UICollectionViewCell
{
    @IBOutlet public weak var authorLabel: UILabel!
    @IBOutlet public weak var dateView: UILabel!
    @IBOutlet public weak var textLabel: UILabel!
    @IBOutlet public weak var hashtagsLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    func setHashTags(hashtags:[TwitterHashtag])
    {
        var string = "- - -"
        var array:[String] = []
        for hashtag in hashtags
        {array.append("#\(hashtag.text)")}
        
        if array.count > 0
        {string = array.joined(separator: " ")}
        
        hashtagsLabel.text = string
    }
}
