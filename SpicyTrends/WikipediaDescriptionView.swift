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
    private var wikiLabel:UILabel!
    public var isDescriptionSet = false
    
    func setDescription(word:String)
    {
        guard let description = TrendsData.shared.wikis[word] else
        {noDescription();return}
        
        print("DESCRIPTION : \(description)")
        
        if description == "no-data"
        {noDescription();return}
        
        if description.count == 0
        {noDescription();return}

        wikiLabel.text = description
        let h:CGFloat = estimatedHeightOfLabel(text: description)
        wikiLabel.frame.size.height = h
        
        isDescriptionSet = true
        
        /*
        let buttonText = "Read More on Wikipedia"
        let wikipediaRange = NSRange(location: 12, length: 10)
        let allRange = NSRange(location: 0, length: 22)
        let attributedTitle = NSMutableAttributedString.init(string: buttonText)
        attributedTitle.addAttribute(NSAttributedStringKey.font,
        value: UIFont(name: "Hoefler Text", size: 16)!, range: wikipediaRange)
        attributedTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray, range: allRange)
        */
 
        /*
        let screen = UIScreen.main.bounds
        let readMoreButton = UIButton.init(type: UIButtonType.roundedRect)
        readMoreButton.frame = CGRect.init(x: screen.width-5-8-180-8, y: h+10, width: 180, height: 30)
        readMoreButton.backgroundColor = UIColor.clear
        readMoreButton.layer.cornerRadius = 4
        readMoreButton.clipsToBounds = true
        readMoreButton.setTitleColor(UIColor.lightGray, for: .normal)
        readMoreButton.layer.borderColor = UIColor.lightGray.cgColor
        readMoreButton.layer.borderWidth = 2
        readMoreButton.setAttributedTitle(attributedTitle, for: .normal)
        self.addSubview(readMoreButton)
        */
 
        self.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: h)
        NSLayoutConstraint.activate([heightConstraint])
        
        //self.backgroundColor = UIColor.clear
    }
    
    func noDescription()
    {
        print("NoDescription")
    }
    
    func estimatedHeightOfLabel(text: String) -> CGFloat
    {
        let size = CGSize(width: self.frame.width - 16, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [kCTFontAttributeName: UIFont.systemFont(ofSize: 18)]
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes as [NSAttributedStringKey : Any], context: nil).height
        return rectangleHeight
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        let screen = UIScreen.main.bounds
        wikiLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: screen.size.width-16, height: 0))
        wikiLabel.numberOfLines = 0
        wikiLabel.font = UIFont.systemFont(ofSize: 18)
        wikiLabel.textColor = UIColor.darkText
        self.addSubview(wikiLabel)
        
        self.backgroundColor = .clear
    }
}
