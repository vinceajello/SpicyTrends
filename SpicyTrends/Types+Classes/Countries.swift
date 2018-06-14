//
//  Countries.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 27/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

struct Countries
{
    let all:[String:String] = ["AR":"Argentina",
                               "AU":"Australia",
                               "AT":"Austria",
                               "BE":"Belgium",
                               "BR":"Brazil",
                               "CA":"Canada",
                               "CL":"Chile",
                               "CO":"Colombia",
                               "CZ":"Czech Republic",
                               "DK":"Denmark",
                               "EG":"Egypt",
                               "FI":"Finland",
                               "FR":"France",
                               "DE":"Germany",
                               "GR":"Greece",
                               "HK":"Hong Kong",
                               "HU":"Hungary",
                               "IN":"India",
                               "ID":"Indonesia",
                               "IL":"Israel",
                               "IT":"Italy",
                               "JP":"Japan",
                               "KE":"Kenya",
                               "MY":"Malaysia",
                               "MX":"Mexico",
                               "NL":"Netherlands",
                               "NE":"Nigeria",
                               "NO":"Norway",
                               "PH":"Philippines",
                               "PL":"Poland",
                               "PT":"Portugal",
                               "RO":"Romania",
                               "RU":"Russia",
                               "SA":"Saudi Arabia",
                               "SG":"Singapore",
                               "ZA":"South Africa",
                               "KP":"South Korea",
                               "ES":"Spain",
                               "SE":"Sweden",
                               "CH":"Switzerland",
                               "TW":"Taiwan",
                               "TH":"Thailand",
                               "TR":"Turkey",
                               "UA":"Ukraine",
                               "GB":"United Kingdom",
                               "US":"United States",
                               "VN":"Vietnam"]
    
    let allCodes:[String] = ["AR","AU","AT","BE","BR","CA","CL","CO","CZ","DK",
                          "EG","FI","FR","DE","GR","HK","HU","IN","ID","IL",
                          "IT","JP","KE","MY","MX","NL","NE","NO","PH","PL",
                          "PT","RO","RU","SA","SG","ZA","KP","ES","SE","CH",
                          "TW","TH","TR","UA","GB","US","VN"]
}

class Country: NSObject
{
    let countries = Countries.init()
    var name:String
    var code:String
    var flag:UIImage
    
    init(code:String)
    {
        self.code = code
        if let name = countries.all[code]
        {
            self.name = name
        }
        else
        {
            self.name = "United States"
            self.code = "US"
        }
        self.flag = UIImage.init(named: code)!
        
        super.init()        
    }
    
    init(name:String)
    {
        let keys = (countries.all as NSDictionary).allKeys(for: name) as! [String]
        
        if let code = keys.first
        {
            self.code = code
        }
        else
        {
            self.code = "US" // Default
        }

        self.flag = UIImage.init(named: code)!
        self.name = name
        
        super.init()
    }
}
