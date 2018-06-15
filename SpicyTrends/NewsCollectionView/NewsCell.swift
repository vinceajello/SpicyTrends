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
    
    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var sourceLabel: UILabel!
    let defaultImage = UIImage.init(named: "PlaceholderSquare")

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.lightText
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
    }
    
   
}


extension NewsCell
{
    func setImageFrom(url:String)
    {
        if let cached_image = getImageFromCache(url: url)
        {
            // set cached_image
            imageView.image = cached_image
            return
        }
        
        // download image
        downloadImage(link: url)
    }
    
    func getImageFromCache(url:String) -> UIImage?
    {
        if let image = TrendsData.shared.newsImages[url]
        {
            return image
        }
        return nil
    }
    
    func downloadImage(link:String)
    {
        TrendsData.shared.newsImages[link] = defaultImage
        guard let url = URL(string: link) else { return }
        
        URLSession.shared.dataTask(with: url)
        {
            data, response, error in
            
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            
            TrendsData.shared.newsImages[link] = image
            DispatchQueue.main.async()
            {
                self.imageView.image = image
            }
        }.resume()
    }
}
