//
//  Trend.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 26/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

struct Trend:Codable
{
    let title:String
    
    init(title: String)
    {
        self.title = title
    }
}
