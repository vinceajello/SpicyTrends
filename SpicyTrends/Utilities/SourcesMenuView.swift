//
//  SourcesMenuView.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 31/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

protocol SourcesMenuViewDelegate
{
    /*
    func didSelectRegion(code:String)
    func regionMenuDidOpen()
    func regionMenuDidClose()
    */
}

class SourcesMenuView: UIView
{
    private var sourcesMenu:JNDropDownMenu!
    var delegate:SourcesMenuViewDelegate!

    var currentSource:String!
    
    init(frame: CGRect,parentView:UIView)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        sourcesMenu = JNDropDownMenu(origin: CGPoint(x: 0, y: 0), height: frame.height, width:frame.width, parentView:parentView, menuType:JNDropDownMenu.DropDownType.Sources)
        sourcesMenu.layer.cornerRadius = 2
        //regionMenu.layer.borderColor = TrendColors().hotOrange.cgColor
        //regionMenu.layer.borderWidth = 1
        sourcesMenu.clipsToBounds = true
        sourcesMenu.textColor = .gray
        sourcesMenu.textFont = UIFont.boldSystemFont(ofSize: 14.0)
        sourcesMenu.cellBgColor = UIColor.lightText
        sourcesMenu.arrowColor = UIColor.black
        sourcesMenu.cellSelectionColor = UIColor.lightText
        sourcesMenu.datasource = self
        sourcesMenu.delegate = self
        self.addSubview(sourcesMenu)
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}

extension SourcesMenuView: JNDropDownMenuDelegate, JNDropDownMenuDataSource
{
    func didSelectRow(at indexPath: JNIndexPath, for menu: JNDropDownMenu)
    {
        
    }
    
    func searchTextDidChange(text: String)
    {
        
    }
    
    func menuDidOpen()
    {
        
    }
    
    func menuDidClose()
    {
        
    }
    
    func numberOfRows(in column: NSInteger, for menu: JNDropDownMenu) -> Int
    {
        return Sources.init().all.count
    }
    
    func titleForRow(at indexPath: JNIndexPath, for menu: JNDropDownMenu) -> String
    {
        return Sources.init().all[indexPath.row]
    }
    
    
}

/*
extension SourcesMenuView: JNDropDownMenuDelegate, JNDropDownMenuDataSource
{
    func menuDidOpen()
    {
        print("menuDidOpen")
        regionMenu.searchBar.text = ""
        searchTextDidChange(text: "")
        guard let _ = delegate?.regionMenuDidOpen() else { return }
    }
    
    func menuDidClose()
    {
        print("menuDidClose")
        guard let _ = delegate?.regionMenuDidClose() else { return }
    }
    
    func searchTextDidChange(text: String)
    {
        if text.count > 0
        {
            var newData:[String] = []
            for c in allCountries.all
            {
               let sub = c.value.prefix(text.count)
               if sub.lowercased() == text.lowercased()
               {
                    newData.append(c.key)
               }
            }
            tableDatas = newData
        }
        else
        {
            tableDatas = allCountries.allCodes
        }
        regionMenu.tableView.reloadData()
    }
    
    func numberOfColumns(in menu: JNDropDownMenu) -> NSInteger {return 1}
    func didSelectRow(at indexPath: JNIndexPath, for menu: JNDropDownMenu)
    {
        let code = allCountries.allCodes[indexPath.row]
        guard let _ = delegate?.didSelectRegion(code: code) else {return}
    }
    
    func numberOfRows(in column: NSInteger, for menu: JNDropDownMenu) -> Int
    {
        return tableDatas.count
    }
    
    func titleForRow(at indexPath: JNIndexPath, for menu: JNDropDownMenu) -> String
    {
        return tableDatas[indexPath.row]
    }
    
    func setIndexFromUserRegion()
    {
        for (index, code) in allCountries.allCodes.enumerated()
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
 */
