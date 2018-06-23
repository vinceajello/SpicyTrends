//
//  NoTrendsAlertView.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 18/06/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

protocol NoTrendsAlertViewDelegate
{
    func reloadButtonPressed()
}

class NoTrendsAlertView: UIView
{
    var delegate:NoTrendsAlertViewDelegate!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        let navigationBarHeight:CGFloat = 65
        let TBBOrder:CGFloat = 80
        let LRBorder:CGFloat = 30
        
        let backgroundView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        backgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        self.addSubview(backgroundView)
        
        let alertW = frame.width - (LRBorder * 2)
        var alertH = frame.height - (TBBOrder * 2) - navigationBarHeight
        
        alertH = 330 // fixed to 280
        let alertFrame = CGRect.init(x: LRBorder, y: TBBOrder + navigationBarHeight, width: alertW, height: alertH)
        let containerView = UIView.init(frame: alertFrame)
        containerView.layer.shadowRadius = 4
        containerView.layer.cornerRadius = 4
        containerView.layer.shadowOpacity = 1.0
        containerView.layer.shadowColor = UIColor(white: 0.2, alpha: 1.0).cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shouldRasterize = true
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        containerView.layer.rasterizationScale = UIScreen.main.scale
        backgroundView.addSubview(containerView)
        
        let TRButtonMargins:CGFloat = 10
        let TRButtonSize:CGFloat = 40
        let TRButtonX:CGFloat = containerView.frame.width - TRButtonSize - TRButtonMargins
        let TRButtonFrame = CGRect.init(x: TRButtonX, y: TRButtonMargins, width: TRButtonSize, height: TRButtonSize)
        let topRightButton = UIButton.init(type: .roundedRect)
        topRightButton.addTarget(self, action: #selector(reloadButtonPressed), for: .touchUpInside)
        topRightButton.frame = TRButtonFrame
        topRightButton.backgroundColor = UIColor.lightText
        topRightButton.setTitle("R", for: .normal)
        //containerView.addSubview(topRightButton)
        
        let logoSize:CGFloat = 90
        let logoYOffset:CGFloat = 90
        let logoX:CGFloat = (containerView.frame.width / 2) - (logoSize / 2)
        let logoY:CGFloat = (containerView.frame.height / 2) - (logoSize / 2) - logoYOffset
        let coldLogoView = UIImageView.init(frame: CGRect.init(x: logoX, y: logoY, width: logoSize, height: logoSize))
        coldLogoView.image = UIImage.init(named: "coldIcon")
        coldLogoView.layer.shadowRadius = 2
        coldLogoView.layer.shadowOpacity = 0.5
        coldLogoView.layer.shadowColor = UIColor(white: 0.2, alpha: 1.0).cgColor
        coldLogoView.layer.shadowOffset = CGSize(width: 2, height: 2)
        containerView.addSubview(coldLogoView)
        
        let titleY = coldLogoView.frame.origin.y + coldLogoView.frame.height + 20
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: titleY, width: containerView.frame.width, height: 30))
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.darkGray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.text = "Cold times..."
        containerView.addSubview(titleLabel)
        
        let descriptionY = titleLabel.frame.origin.y + titleLabel.frame.height + 5
        let descriptionLabel = UILabel.init(frame: CGRect.init(x: 20, y: descriptionY,
        width: containerView.frame.width-40, height: 75))
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.text = "Sorry, the network failed.\nCheck your internet connection or try later."
        descriptionLabel.numberOfLines = 0
        containerView.addSubview(descriptionLabel)
        
        let retrayButtonX:CGFloat = (containerView.frame.size.width / 2) - (100 / 2)
        let retrayButtonY:CGFloat = descriptionY + descriptionLabel.frame.size.height + 20
        let retrayButtonFrame = CGRect.init(x: retrayButtonX, y: retrayButtonY, width: 100, height: 40 )
        let retrayButton = UIButton.init(type: .roundedRect)
        retrayButton.addTarget(self, action: #selector(reloadButtonPressed), for: .touchUpInside)
        retrayButton.frame = retrayButtonFrame
        retrayButton.backgroundColor = UIColor(red:0.18, green:0.43, blue:0.68, alpha:1.0)
        retrayButton.layer.cornerRadius = 6
        retrayButton.setTitleColor(UIColor.white, for: .normal)
        retrayButton.setTitle("RETRY", for: .normal)
        containerView.addSubview(retrayButton)
        
        containerView.center = self.center
    }
    
    @objc func reloadButtonPressed()
    {guard let _ = delegate?.reloadButtonPressed() else { return }}

    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}
