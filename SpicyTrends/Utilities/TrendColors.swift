//
//  TrendColors.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 01/06/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class TrendColors
{
    let fireRed:UIColor = UIColor.init(red: 209/255, green: 38/255, blue: 49/255, alpha: 1)
    let hotOrange:UIColor = UIColor.init(red: 253/255, green: 99/255, blue: 1/255, alpha: 1)
    
    func hottnessColorFrom(indexPath:Int)->UIColor
    {
        // map red 209 -> 253
        let mRed = map(value: CGFloat(indexPath+1), xmin: 0, xmax: 15, ymin: 209, ymax: 253) / 255
        
        // map green 38 -> 99
        let mGreen = map(value: CGFloat(indexPath+1), xmin: 0, xmax: 15, ymin: 38, ymax: 99) / 255
        
        // map blue 49 -> 1
        let mBlue = map(value: CGFloat(indexPath+1), xmin: 0, xmax: 15, ymin: 49, ymax: 1) / 255
        
        return UIColor.init(red: mRed, green: mGreen, blue: mBlue, alpha: 1)
    }
    
    func map(value:CGFloat,xmin:CGFloat,xmax:CGFloat,ymin:CGFloat,ymax:CGFloat)->CGFloat
    {
        return ymin+(value-xmin)*(ymax-ymin)/(xmax-xmin)
    }
}
