//
//  NavController.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 08/06/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class NavController: UINavigationController
{
    private let zoomNavigationControllerDelegate = ZoomNavigationControllerDelegate()

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        delegate = zoomNavigationControllerDelegate
    }
}
