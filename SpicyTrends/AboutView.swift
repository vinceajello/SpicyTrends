//
//  AboutView.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 24/06/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class AboutView: UIView
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        let backgroundView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        backgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        self.addSubview(backgroundView)
        
        let aboutView = Bundle.main.loadNibNamed("AboutView", owner: nil, options: nil)?.first as? AboutViewNIB
        aboutView?.frame = CGRect.init(x: 15, y: 100, width: frame.width-30, height: 450)
        aboutView?.layer.cornerRadius = 6
        aboutView?.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.addSubview(aboutView!)
        
        aboutView?.center = self.center        
    }
    
    @objc func close()
    {
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}

class AboutViewNIB: UIView
{
    @IBOutlet public weak var closeButton:UIButton!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}
