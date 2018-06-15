//
//  WikiDescriptions.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 28/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class TrendsData: NSObject
{
    static let shared = TrendsData()
    var wikis:[String:String] = [:]
    var news:[String:[News]] = [:]
    var status:[String:String] = [:]
    var newsImages:[String:UIImage] = [:]
}
