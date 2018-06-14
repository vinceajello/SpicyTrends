//
//  UserRegion.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 27/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class UserRegion: NSObject
{
    var code = "US" // Default
    
    override init()
    {
        super.init()
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
        {
            code = countryCode
        }
        print("User Region : \(code)")
    }
}
