//
//  WikipediaDescriptionView.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 31/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class WikipediaDescriptionView: UIView
{
    public var wikiLabel:UILabel!
    public var isWikiSetted = false
    
    func setWiki(wiki:String!)
    {
        print("Wiki : \(wiki)")
        var h:CGFloat = 0
        if let w = wiki
        {
            if w.range(of:"may refer to:") == nil && w.count > 0
            {
                wikiLabel.text = w
                h = heightForView(text: w, width: wikiLabel.frame.size.width)
                isWikiSetted = true
            }
        }
        
        print("wiki h : \(h)")
        wikiLabel.frame.size.height = h
        self.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: h)
        NSLayoutConstraint.activate([heightConstraint])
    }
    
    func noDescription()
    {
        print("NoDescription")
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
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        print("init wiki")
        
        self.clipsToBounds = true
        let screen = UIScreen.main.bounds
        wikiLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: screen.size.width-60, height: 0))
        wikiLabel.numberOfLines = 0
        wikiLabel.font = UIFont.systemFont(ofSize: 15)
        wikiLabel.textColor = UIColor.gray
        self.addSubview(wikiLabel)
        
        self.backgroundColor = .clear
    }
}
