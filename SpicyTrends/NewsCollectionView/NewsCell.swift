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
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
    
   
}

extension NewsCell
{
    func loadImage(url:String)
    {
        print(url)
        
        let fixedUrl = "http:"+url
        
        let image = TrendsData.shared.newsImages[fixedUrl]
        if image == nil
        {
            self.downloadImage(link: fixedUrl)
        }
        else
        {
            if let i = image
            {
                self.setImage(url:fixedUrl,image: i!)
            }
        }
    }

    func setImage(url:String,image:UIImage)
    {
        TrendsData.shared.newsImages[url] = image
        DispatchQueue.main.async()
        {
            self.imageView.image = image
        }
    }
    
     func downloadImage(link:String)
     {
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
        
            self.setImage(url:link,image: image)
        }.resume()
    }
}


