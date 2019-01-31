//
//  JNDropDownMenu.swift
//  RollbarClient
//
//  Created by Javal Nanda on 4/26/17.
//  Copyright © 2017 Javal Nanda. All rights reserved.
//

import UIKit

public enum ArrowPosition: String {
    case Left
    case Right
}

public struct JNIndexPath {
    public var column = 0
    public var row = 0
    init(column: NSInteger, row: NSInteger) {
        self.column = column
        self.row = row
    }
}

public protocol JNDropDownMenuDataSource: class {
    func numberOfRows(in column: NSInteger, for menu: JNDropDownMenu) -> Int
    func titleForRow(at indexPath: JNIndexPath, for menu: JNDropDownMenu) -> String
    func numberOfColumns(in menu: JNDropDownMenu) -> NSInteger
    func titleFor(column: Int, menu: JNDropDownMenu) -> String
}

public extension JNDropDownMenuDataSource {
    func numberOfColumns(in menu: JNDropDownMenu) -> NSInteger {
        return 1
    }
    
    func titleFor(column: Int, menu: JNDropDownMenu) -> String {
        return menu.datasource?.titleForRow(at: JNIndexPath(column: column, row: 0), for: menu) ?? ""
    }
}

public protocol JNDropDownMenuDelegate: class {
    func didSelectRow(at indexPath: JNIndexPath, for menu: JNDropDownMenu)
    func searchTextDidChange(text:String)
    func menuDidOpen()
    func menuDidClose()
}

public class JNDropDownMenu: UIView {

    let countries = Countries.init()
    let sources = Sources.init()
    
    var origin = CGPoint(x: 0, y: 0)
    var currentSelectedMenuIndex = -1
    var show = false
    var tableView = UITableView()
    var backGroundView = UIView()
    var numOfMenu = 1
    //data source
    var array: [String] = []
    //layers array
    var titleImage:UIImageView!
    var titles: [CATextLayer] = []
    var indicators: [CAShapeLayer] = []
    var bgLayers: [CALayer] = []
    var flagImage:UIImageView!
    
    var searchBar:UISearchBar!
    
    // custom msk
    var parentView:UIView!
    
    //
    open var textColor = UIColor.black
    open var arrowColor = UIColor.black
    open var cellBgColor = UIColor.white
    open var cellSelectionColor = UIColor.init(white: 0.9, alpha: 1.0)
    open var textFont = UIFont.systemFont(ofSize: CGFloat(14.0))
    open var updateColumnTitleOnSelection = true
    open var arrowPostion: ArrowPosition = .Right
    open weak var datasource: JNDropDownMenuDataSource? {
        didSet {
            //configure view
            self.numOfMenu = (datasource?.numberOfColumns(in: self))!
            setUpUI()
        }
    }

    open weak var delegate: JNDropDownMenuDelegate?
    func setUpUI() {
        let textLayerInterval = self.frame.size.width / CGFloat(( self.numOfMenu * 2))
        let bgLayerInterval = self.frame.size.width / CGFloat(self.numOfMenu)
        var tempTitles: [CATextLayer] = []
        var tempIndicators: [CAShapeLayer] = []
        var tempBgLayers: [CALayer] = []
        
        for i in 0..<self.numOfMenu
        {
            //bgLayer
            let bgLayerPosition = CGPoint(x: (Double(i)+0.5) * Double(bgLayerInterval),
                                          y: Double(self.frame.size.height/2))
            let bgLayer = self.createBgLayer(color: cellBgColor, position: bgLayerPosition)
            self.layer.addSublayer(bgLayer)
            tempBgLayers.append(bgLayer)
            
            //title
            let titlePosition = CGPoint(x: Double((i * 2 + 1)) * Double(textLayerInterval) - 5,
                                        y: Double(self.frame.size.height / 2))
            let titleString = self.datasource?.titleFor(column: i, menu: self)
            let title = self.createTextLayer(string: titleString!, color: self.textColor, point: titlePosition)
            
            if menuType == .Countries
            {
                self.layer.addSublayer(title)
            }
            else
            {
                titleImage = UIImageView.init(frame: CGRect.init(x: 0, y: 10, width: 90, height: 15))
                titleImage.image = UIImage.init(named: "GoogleSourcesIcon")
                titleImage.center.x = self.center.x
                self.addSubview(titleImage)
            }
            
            tempTitles.append(title)
            
            // Flag image
            flagImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 16.8, height: 12))
            flagImage.layer.cornerRadius = 4
            flagImage.backgroundColor = .clear
            flagImage.center.y = titlePosition.y
            flagImage.frame.origin.x = 10
            
            if menuType == .Countries
            {
                self.layer.addSublayer(flagImage.layer)
            }
            
            let indicatorPosition = CGPoint(x: titlePosition.x + title.bounds.size.width / 2 + 8,
                                        y: self.frame.size.height / 2)
            
            //indicator
            let indicator = self.createIndicator(color: self.arrowColor,
                                                 point: indicatorPosition)
            //self.layer.addSublayer(indicator)
            tempIndicators.append(indicator)
            
        }
        titles = tempTitles
        indicators = tempIndicators
        bgLayers = tempBgLayers
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public var menuType:DropDownType!
    public enum DropDownType:String
    {
        case Countries = "Google"
        case Sources = "Twitter"
    }
    
    public init(origin: CGPoint, height: CGFloat, width: CGFloat, parentView:UIView, menuType:DropDownType)
    {
        self.parentView = parentView
        self.menuType = menuType
        let screenSize = UIScreen.main.bounds.size

        super.init(frame: CGRect(origin: CGPoint.init(x: 0, y: 0), size: CGSize(width:width, height: height)))
        self.currentSelectedMenuIndex = -1
        self.show = false
        
        var xFix:CGFloat = 0
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
        {
            //iPhone X
            xFix = 20
        }
        
        // search bar by mspaki
        let searchBarY:CGFloat = 70 + xFix
        var searchBarHeight:CGFloat = 0
        
        if menuType == .Countries
        {
            searchBarHeight = 44
            searchBar = UISearchBar.init(frame: CGRect.init(x: 15, y: searchBarY, width: screenSize.width-30, height: searchBarHeight))
            //searchBar.frame.origin.x = ((screenSize.width - 30) / 2) - 125
            searchBar.layer.cornerRadius = 4
            searchBar.clipsToBounds = true
            searchBar.barTintColor = .white
            searchBar.delegate = self
            searchBar.placeholder = "Search"
        }
        
        //tableView init
        let tableViewY:CGFloat = searchBarY + searchBarHeight + 3
        self.tableView = UITableView.init(frame: CGRect(origin: CGPoint(x: 0, y :tableViewY), size: CGSize(width: 250, height: 0)))
        self.tableView.frame.origin.x = screenSize.width / 2 - 125
        self.tableView.rowHeight = 38
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.layer.cornerRadius = 8
        self.tableView.clipsToBounds = true
        self.tableView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -6)

        
        //self tapped
        self.backgroundColor = UIColor.white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.menuTapped(paramSender:)))
        self.addGestureRecognizer(tapGesture)
        //background init and tapped
        self.backGroundView = UIView.init(frame: CGRect(origin: CGPoint(x: 0, y :0),
                                size: CGSize(width: screenSize.width, height: screenSize.height)))
        
        self.backGroundView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.0)
        self.backGroundView.isOpaque = false
        let bgTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped(paramSender:)))
        self.backGroundView.addGestureRecognizer(bgTapGesture)
        //add bottom shadow
        let bottomShadow = UIView.init(frame: CGRect(origin: CGPoint(x: 0, y :self.frame.size.height-0.5),
                                        size: CGSize(width: screenSize.width, height: 0.5)))
        bottomShadow.backgroundColor = UIColor.lightGray
        self.addSubview(bottomShadow)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createBgLayer(color: UIColor, position: CGPoint) -> CALayer {
        let layer = CALayer()
        layer.position = position
        layer.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.frame.size.width/CGFloat(self.numOfMenu), height: self.frame.size.height-1))
        layer.backgroundColor = color.cgColor
        return layer
    }

    func createIndicator(color: UIColor, point: CGPoint) -> CAShapeLayer {
        let layer = CAShapeLayer()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 8, y: 0))
        path.addLine(to: CGPoint(x: 4, y: 5))
        path.close()

        layer.path = path.cgPath
        layer.lineWidth = 1.0
        layer.fillColor = color.cgColor

        let bound = CGPath(__byStroking: layer.path!, transform: nil, lineWidth: layer.lineWidth, lineCap: .butt, lineJoin: .miter, miterLimit: layer.miterLimit)!

        layer.bounds = bound.boundingBoxOfPath

        layer.position = point

        return layer
    }

    func createTextLayer(string: String, color: UIColor, point: CGPoint) -> CATextLayer {

        let size = self.calculateTitleSizeWith(string: string)

        let layer = CATextLayer()
        let sizeWidth = (size.width < (self.frame.size.width / CGFloat(self.numOfMenu)) - 25) ? size.width : self.frame.size.width / CGFloat(self.numOfMenu) - 25
        layer.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: sizeWidth, height: size.height))
        layer.string = string
        layer.fontSize = textFont.pointSize
        layer.alignmentMode = CATextLayerAlignmentMode.center
        layer.foregroundColor = color.cgColor
        layer.contentsScale = UIScreen.main.scale
        layer.position = point

        return layer
    }

    func calculateTitleSizeWith(string: String) -> CGSize {
        let dict = [kCTFontAttributeName: textFont]
        let constraintRect = CGSize(width: 280, height: 0)
        let rect = string.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: dict as [NSAttributedString.Key : Any], context: nil)
        return rect.size
    }

}

// Tag gesture
extension JNDropDownMenu {

    @objc func menuTapped(paramSender: UITapGestureRecognizer)
    {
        let touchPoint = paramSender.location(in: self)

        //calculate index
        let tapIndex = Int(touchPoint.x / (self.frame.size.width / CGFloat(self.numOfMenu)))

        for i in 0..<self.numOfMenu where i != tapIndex {
            self.animateIndicator(indicator: indicators[i], forward: false, completion: { _ in
                self.animateTitle(title: titles[i], show: false, completion: {_ in
                })
            })
            self.bgLayers[i].backgroundColor = cellBgColor.cgColor
        }

        if tapIndex == self.currentSelectedMenuIndex && self.show
        {
            guard let _ = delegate?.menuDidClose() else {return}
            
            if searchBar != nil { searchBar.resignFirstResponder() }
            
            searchBar.resignFirstResponder()
            self.animate(indicator: indicators[self.currentSelectedMenuIndex], background: self.backGroundView, tableView: self.tableView, title: titles[self.currentSelectedMenuIndex], forward: false, completion: { _ in
                self.currentSelectedMenuIndex = tapIndex
                self.show = false
            })
            self.bgLayers[tapIndex].backgroundColor = cellBgColor.cgColor

        }
        else
        {
            guard let _ = delegate?.menuDidOpen() else {return}
            self.currentSelectedMenuIndex = tapIndex
            self.tableView.reloadData()
            self.animate(indicator: indicators[tapIndex], background: self.backGroundView, tableView: self.tableView, title: titles[tapIndex], forward: true, completion: { _ in
                self.show = true
            })
            self.bgLayers[tapIndex].backgroundColor = cellSelectionColor.cgColor
        }

    }

    @objc func backgroundTapped(paramSender: UITapGestureRecognizer? = nil)
    {
        self.animate(indicator: indicators[currentSelectedMenuIndex], background: self.backGroundView, tableView: self.tableView, title: titles[self.currentSelectedMenuIndex], forward: false) { _ in
            self.show = false
        }
        if searchBar != nil { searchBar.resignFirstResponder() }
        guard let _ = delegate?.menuDidClose() else {return}
        self.bgLayers[self.currentSelectedMenuIndex].backgroundColor = cellBgColor.cgColor
    }

}

// Animation
extension JNDropDownMenu {

    func animateIndicator(indicator: CAShapeLayer, forward: Bool, completion: ((Bool) -> Swift.Void)) {

        let angle = forward ? Double.pi : 0
        let rotate = CGAffineTransform(rotationAngle: CGFloat(angle))
        indicator.transform = CATransform3DMakeAffineTransform(rotate)
        completion(true)
    }

    func animateBackGroundView(view: UIView, show: Bool, completion: @escaping ((Bool) -> Swift.Void)) {
        if show
        {
            parentView.superview?.addSubview(view)
            //view.superview?.addSubview(self)
            UIView.animate(withDuration: 0.2, animations: {
                view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.3)
                completion(true)
            })
        } else
        {
            UIView.animate(withDuration: 0.2, animations: {
                view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.0)
            }, completion: { _ in
                view.removeFromSuperview()
                completion(true)
            })
        }
    }

    func animateTableView(tableView: UITableView, show: Bool, completion: @escaping ((Bool) -> Swift.Void))
    {
        if show
        {
            tableView.frame = CGRect(origin: CGPoint(x: tableView.frame.origin.x, y: tableView.frame.origin.y),
            size: CGSize(width: tableView.frame.width, height: 0))

            // msk hack
            parentView.superview?.addSubview(tableView)
            
            if menuType == .Countries
            {
                parentView.superview?.addSubview(searchBar)
            }
            
            let tableViewHeight = (CGFloat(tableView.numberOfRows(inSection: 0)) * tableView.rowHeight) < UIScreen.main.bounds.height-(self.origin.y+100) ? (CGFloat(tableView.numberOfRows(inSection: 0)) * tableView.rowHeight) : UIScreen.main.bounds.height-(self.origin.y+100)

            UIView.animate(withDuration: 0.2, animations:
            {
                self.tableView.frame = CGRect(origin: CGPoint(x: tableView.frame.origin.x, y: tableView.frame.origin.y),
                size: CGSize(width: tableView.frame.width, height: (tableViewHeight + 20)/2))
                completion(true)
            })
        }
        else
        {
            UIView.animate(withDuration: 0.2, animations:
            {
                self.tableView.frame = CGRect(origin: CGPoint(x: tableView.frame.origin.x, y: tableView.frame.origin.y),
                size: CGSize(width: tableView.frame.width, height: 0))
            },
            completion:
            {
                (_) in
                tableView.removeFromSuperview()
                if self.menuType == .Countries
                {
                    self.searchBar.removeFromSuperview()
                }
                completion(true)
            })
        }
    }

    func animateTitle(title: CATextLayer, show: Bool, completion: ((Bool) -> Swift.Void)) {
        let size = self.calculateTitleSizeWith(string: title.string as? String ?? "")
        let sizeWidth = (size.width < (self.frame.size.width / CGFloat(self.numOfMenu)) - 25) ? size.width : self.frame.size.width / CGFloat(self.numOfMenu) - 25
        title.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: sizeWidth, height: size.height))

        flagImage.frame.origin.x = title.position.x - (sizeWidth / 2) - 20
        
        completion(true)
    }

    func animate(indicator: CAShapeLayer, background: UIView, tableView: UITableView, title: CATextLayer, forward: Bool, completion: @escaping ((Bool) -> Swift.Void)) {

        animateIndicator(indicator: indicator, forward: forward, completion: {_ in
            animateTitle(title: title, show: forward, completion: {_ in
                animateBackGroundView(view: background, show: forward, completion: {_ in
                    self.animateTableView(tableView: tableView, show: forward, completion: {_ in
                            completion(true)
                    })
                })
            })
        })
    }

}

// TableView DataSource - Delegate
extension JNDropDownMenu: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(self.datasource != nil, "menu's dataSource shouldn't be nil")

        return (self.datasource?.numberOfRows(in: self.currentSelectedMenuIndex, for: self))!
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "DropDownMenuCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        }

        assert(self.datasource != nil, "menu's datasource shouldn't be nil")

        let code = self.datasource?.titleForRow(at: JNIndexPath(column: self.currentSelectedMenuIndex, row: indexPath.row), for: self)
        
        if menuType == .Sources
        {
            cell?.textLabel?.text = code
            cell?.imageView?.alpha = 0
        }
        else if menuType == .Countries
        {
            cell?.textLabel?.text = countries.all[code!]
            cell?.imageView?.image = UIImage.init(named: code!)
        }
        
        cell?.backgroundColor = cellBgColor
        cell?.textLabel?.font = textFont
       // cell?.textLabel?.textAlignment = .center
       // cell?.textLabel?.backgroundColor = .orange
        cell?.textLabel?.layoutIfNeeded()
        cell?.separatorInset = UIEdgeInsets.zero
        
        if let b = self.titles[self.currentSelectedMenuIndex].string as? String
        {
            if let a = cell?.textLabel?.text
            {
                if a == b
                {
                    cell?.backgroundColor = cellSelectionColor
                }
            }
        }

        return cell!
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.confiMenuWith(row: indexPath.row)
        self.delegate?.didSelectRow(at: JNIndexPath(column: self.currentSelectedMenuIndex, row: indexPath.row), for: self)
    }

    func confiMenuWith(row: NSInteger) {
        let title = self.titles[self.currentSelectedMenuIndex]
        if updateColumnTitleOnSelection
        {
            let code = self.datasource?.titleForRow(at: JNIndexPath(column: self.currentSelectedMenuIndex, row: row), for: self)
            let name = self.countries.all[code!]
            title.string = name
            
            if let image = UIImage.init(named: code!)
            {
                flagImage.alpha = 1
                flagImage.image = image
            }
            else
            {
                flagImage.alpha = 0
            }
        }
        self.animate(indicator: indicators[self.currentSelectedMenuIndex], background: self.backGroundView, tableView: self.tableView, title: titles[self.currentSelectedMenuIndex], forward: false) { _ in
            self.show = false
        }
        self.bgLayers[self.currentSelectedMenuIndex].backgroundColor = cellBgColor.cgColor
        let indicator = self.indicators[self.currentSelectedMenuIndex]
        indicator.position = CGPoint(x: title.position.x + title.frame.size.width / 2 + 8, y: indicator.position.y)
    }

    open func dismiss() {
        self.backgroundTapped(paramSender: nil)
    }

    func selectRow(row: NSInteger, in component: NSInteger) {
        self.currentSelectedMenuIndex = component
        self.confiMenuWith(row: row)
    }
}

extension JNDropDownMenu: UISearchBarDelegate
{
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        guard let _ = delegate?.searchTextDidChange(text: searchText) else {return}
    }
}
