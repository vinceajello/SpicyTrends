//
//  MainImageView.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 01/06/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class MainImageView: UIView
{
    let netManager = NetworkManager.init()
    var imageView:UIImageView!
    var activityIndicator:UIActivityIndicatorView!

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.clipsToBounds = true
        
        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage.init(named: "Placeholder")
        self.addSubview(imageView)
        
        imageView.autoresizingMask = [.flexibleWidth]
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = true
                
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activityIndicator.center.x = 0
        activityIndicator.center.y = 0
        self.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func getImage(word:String)
    {
        let image = TrendsData.shared.mainImages[word]
        if image == nil
        {
            self.downloadImage(word: word)
        }
        else
        {
            if let i = image
            {
                self.setImage(word:word,image: i!)
            }
        }
    }
    
    func downloadImage(word:String)
    {
        self.netManager.getImage(word:word)
        {
            (success, response) in
            
            self.activityIndicator.startAnimating()
            self.activityIndicator.alpha = 0
            
            if success != true
            {print("Error : \(response)")}
            
            print("WIKI IMAGE LINK : \(response)")
            self.imageView.downloadedFrom(word: word, link: response)
        }
    }
    
    func setImage(word:String,image:UIImage)
    {
        TrendsData.shared.mainImages[word] = image
        DispatchQueue.main.async()
        {
            self.imageView.image = image
        }
    }
}

extension UIImageView
{
    func downloadedFrom(word:String, url: URL)
    {
        URLSession.shared.dataTask(with: url)
        {
            data, response, error in
            
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            DispatchQueue.main.async()
            {
                TrendsData.shared.mainImages[word] = image
                self.image = image
            }
        }.resume()
    }
    func downloadedFrom(word:String,link: String)
    {
        guard let url = URL(string: link) else { return }
        downloadedFrom(word: word, url: url)
    }
}
