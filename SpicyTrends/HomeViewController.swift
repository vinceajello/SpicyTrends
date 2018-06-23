//
//  HomeViewController.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 26/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController
{
    var regionMenu:RegionMenuView!
    let countries = Countries.init()
    let userRegion = UserRegion.init()
    
    var sourcesMenu:SourcesMenuView!
    
    @IBOutlet private weak var collectionView: TrendsCollectionView!
    @IBOutlet private weak var accessoryView: UIView!
    @IBOutlet private weak var date: UILabel!
    
    let netManager = NetworkManager.init()
    var alertView:NoTrendsAlertView!
    var loader:AJProgressView!
    
    var transitionImage = UIImage.init(named: "Placeholder")
    var transitionFrame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Create tool bar in the navigation
        self.drawAccessoryView()
        
        // Create loader
        self.initLoader()

        // assign collection view custom delegate
        let topInset:CGFloat = 90
        collectionView.customDelegate = self
        collectionView.frame = CGRect.init(x: 0, y: topInset, width: self.view.frame.width, height: self.view.frame.height-topInset)
        
        // start firstr loading after a little delay
        self.reloadData()
    }
    
    func reloadDataAfterDelay(delay:TimeInterval)
    {
        DispatchQueue.main.async
        {
            self.loader.show()
            self.view.isUserInteractionEnabled = false
            self.date.text = "- - -"
            
            self.collectionView.trends = []
            TrendsData.shared.trends = []
            self.collectionView.reloadData()
        }
        
        self.perform(#selector(self.getTrendsData(region:)), with: self.regionMenu.currentRegion, afterDelay: delay)
    }
    
    func reloadData()
    {
        // Get trends data
        self.reloadDataAfterDelay(delay: 0)
    }
    
    override func didReceiveMemoryWarning()
    {super.didReceiveMemoryWarning()}
}

//
// MARK: AccessoryView + RegionMenu + SourceMenu
//

extension HomeViewController:RegionMenuDelegate, SourcesMenuViewDelegate
{
    func regionMenuDidOpen()
    {
        if alertView != nil
        {
            UIView.animate(withDuration: 0.5)
            {
                self.alertView.alpha = 0
            }
        }
    }
    
    func regionMenuDidClose()
    {
        self.perform(#selector(displayAlertView), with: nil, afterDelay: 0.5)
    }
    
    @objc func displayAlertView()
    {
        if alertView != nil
        {
            UIView.animate(withDuration: 0.5)
            {
                self.alertView.alpha = 1
            }
        }
    }
    
    func drawAccessoryView()
    {
        accessoryView.backgroundColor = UIColor.clear
        drawRegionMenu()
        drawSourcesMenu()
    }
    
    func drawRegionMenu()
    {
        let f = CGRect.init(x: 0, y: 0, width: (accessoryView.frame.size.width/2)-6, height: 35)
        regionMenu = RegionMenuView.init(frame: f, userRegion: userRegion.code, parentView: self.view)
        regionMenu.delegate = self
        accessoryView.addSubview(regionMenu)
    }
    
    func drawSourcesMenu()
    {
        let f = CGRect.init(x: regionMenu.frame.width + 12, y: 0, width: (accessoryView.frame.size.width/2)-6, height: 35)
        sourcesMenu = SourcesMenuView.init(frame: f, parentView: self.view)
        sourcesMenu.delegate = self
        accessoryView.addSubview(sourcesMenu)
    }
    
    func didSelectRegion(code: String)
    {
        print("Selected Region : \(code)")
        regionMenu.currentRegion = code
        print("CURRENT COUTRY : \(regionMenu.currentRegion)")
        reloadDataAfterDelay(delay:1)
    }
}

//
// MARK: Init & Setup Loader
//

extension HomeViewController
{
    func initLoader()
    {
        loader = AJProgressView()
        loader.imgLogo = UIImage(named:"LoaderIcon")!
        loader.firstColor = TrendColors().fireRed
        loader.secondColor = TrendColors().hotOrange
        loader.duration = 3.0
        loader.lineWidth = 5.0
        loader.bgColor =  UIColor.black.withAlphaComponent(0.5)
    }
}

//
// MARK: Network request
//

extension HomeViewController
{
    @objc func getTrendsData(region:String)
    {
        netManager.getTrendsData(region: region)
        {
            (success, response) in
            
            if success != true || response?.data.count == 0
            {self.showNoTrendsAlert(error: "Error: Unable to get Trends.");return}
            
            guard let trends = response?.data else
            {self.showNoTrendsAlert(error: "Error: Unable to get Trends.");return}

            DispatchQueue.main.async
            {
                self.loader.hide()
                self.view.isUserInteractionEnabled = true
                var time = response!.updatedAt
                time.removeLast(3)
                self.date.text = "Last update: "+time
                self.collectionView.setTrends(trends: trends)
            }
        }
    }
}

//
// MARK: Navigation
//

extension HomeViewController: TrendsCollectionViewDelegate, DetailsViewControllerDelegate
{
    func trendDidSelected(indexPath: IndexPath)
    {
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let cellFrame = collectionView.convert((attributes?.frame)!, to: self.view)
        let cell = collectionView!.cellForItem(at: indexPath)
        let cellRender = image(with: cell!)

        transitionImage = cellRender
        transitionFrame = cellFrame

        // push the new view controller
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailsController =
        storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsController.country = regionMenu.currentRegion
        detailsController.rank = indexPath.row
        detailsController.trend = collectionView.trends[indexPath.row]
        detailsController.delegate = self
        detailsController.transitionFrame = cellFrame
        self.navigationController?.pushViewController(detailsController, animated: true)
    }
    
    func setTransitionImage(image: UIImage)
    {
        
    }
}

extension HomeViewController: ZoomTransitionSourceDelegate
{
    func transitionSourceImageView() -> UIImageView
    {
        let imageView = UIImageView.init(image: transitionImage)
        imageView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.clipsToBounds = true
        return imageView
    }
    
    func transitionSourceImageViewFrame(forward: Bool) -> CGRect
    {
        let y = transitionFrame.origin.y
        return CGRect.init(x: 15, y: y , width: self.view.frame.width-30, height: transitionFrame.size.height)
    }
    
    func image(with view: UIView) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext()
        {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}

//
// MARK: No Trends Alert
//

extension HomeViewController: NoTrendsAlertViewDelegate
{
    func reloadButtonPressed()
    {
        UIView.animate(withDuration: 0.3, animations:
        {
            self.alertView.alpha = 0
        })
        { (success) in
            
            self.alertView.removeFromSuperview()
            self.reloadDataAfterDelay(delay: 1)
        }
    }
    
    func showNoTrendsAlert(error:String)
    {
        print("No Trends Found - Error \(error)")
        DispatchQueue.main.async
        {
            self.loader.hide()
            self.view.isUserInteractionEnabled = true
            self.date.text = "- - -"
            self.showAlertView()
        }
    }
    
    func showAlertView()
    {
        DispatchQueue.main.async
        {
            if self.alertView == nil
            {self.alertView = NoTrendsAlertView.init(frame: CGRect.init(x: 0, y: 0,
            width: self.view.frame.width, height: self.view.frame.height))}
            self.alertView.delegate = self
            self.alertView.alpha = 1
            self.view.addSubview(self.alertView)
        }
    }
}


