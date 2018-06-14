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
        activityIndicator.center.x = UIScreen.main.bounds.width - 20
        activityIndicator.center.y = 20
        self.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func getMainImage(word:String)
    {
        DispatchQueue.main.async
        {
            self.netManager.getImage(word:word)
            {
                (success, response) in
                
                self.activityIndicator.startAnimating()
                self.activityIndicator.alpha = 0
                
                if success != true
                {print("Error : \(response)")}
            
                print("WIKI IMAGE LINK : \(response)")
                self.imageView.downloadedFrom(link: response)
            }
        }
    }
}

extension UIImageView
{
    func downloadedFrom(url: URL)
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
                self.image = image
            }
        }.resume()
    }
    func downloadedFrom(link: String)
    {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url)
    }
}
