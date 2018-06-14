//
//  RegionMenuView.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 31/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

protocol RegionMenuDelegate
{
    func didSelectRegion(code:String)
}

class RegionMenuView: UIView
{
    private var regionMenu:JNDropDownMenu!
    let countries = Countries.init()
    var userRegion:String!
    var currentRegion:String!
    var delegate:RegionMenuDelegate!
    var colors = TrendColors.init()

    init(frame: CGRect,userRegion:String,parentView:UIView)
    {
        super.init(frame: frame)
        
        self.userRegion = userRegion
        
        regionMenu = JNDropDownMenu(origin: CGPoint(x: 0, y: 0), height: frame.height, width:(frame.width-6)/2, parentView:parentView)
        regionMenu.layer.cornerRadius = 2
        //regionMenu.layer.borderColor = TrendColors().hotOrange.cgColor
        //regionMenu.layer.borderWidth = 1
        regionMenu.clipsToBounds = true
        regionMenu.textColor = TrendColors.init().fireRed
        regionMenu.textFont = UIFont.boldSystemFont(ofSize: 14.0)
        regionMenu.cellBgColor = UIColor.lightText
        regionMenu.arrowColor = UIColor.black
        regionMenu.cellSelectionColor = UIColor.lightText
        regionMenu.updateColumnTitleOnSelection = true
        regionMenu.datasource = self
        regionMenu.delegate = self
        self.addSubview(regionMenu)
        
        self.setIndexFromUserRegion()
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}

extension RegionMenuView: JNDropDownMenuDelegate, JNDropDownMenuDataSource
{
    func numberOfColumns(in menu: JNDropDownMenu) -> NSInteger {return 1}
    func didSelectRow(at indexPath: JNIndexPath, for menu: JNDropDownMenu)
    {
        let code = countries.allCodes[indexPath.row]
        guard let _ = delegate?.didSelectRegion(code: code) else {return}
    }
    
    func numberOfRows(in column: NSInteger, for menu: JNDropDownMenu) -> Int
    {return countries.allCodes.count}
    func titleForRow(at indexPath: JNIndexPath, for menu: JNDropDownMenu) -> String
    {return countries.allCodes[indexPath.row]}
    
    func setIndexFromUserRegion()
    {
        for (index, code) in countries.allCodes.enumerated()
        {
            if code == userRegion
            {
                currentRegion = code
                regionMenu.selectRow(row: index, in: 0)
                print("Current Region : \(currentRegion)")
            }
        }
    }
}
