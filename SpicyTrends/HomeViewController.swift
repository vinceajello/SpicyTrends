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
    
    @IBOutlet private weak var collectionView: TrendsCollectionView!
    @IBOutlet private weak var accessoryView: UIView!
    @IBOutlet private weak var date: UILabel!

    let netManager = NetworkManager.init()
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

        // Get trends data
        getTrends(region: regionMenu.currentRegion)
    }
    
    func getTrends(region:String)
    {
        loader.show()
     
        collectionView.trends = []
        TrendsData.shared.wikis = [:]
        TrendsData.shared.news = [:]
        collectionView.reloadData()
        
    
        netManager.getGTrends(region: region)
        {
            (success, trends) in
            
            if success != true && trends.count > 0
            {
                self.showNoTrendsAlert(error: "Error: Unable to get Trends.")
                return
            }
            
            var trendslist:[Trend] = []
            if trends.count > 15
            {
                for i in 0...14
                {
                    trendslist.append(trends[i])
                }
            }
            else {trendslist = trends}
            
            DispatchQueue.main.async
            {
                self.loader.hide()
                self.collectionView.setTrends(trends: trendslist)
            }
        }
    }
    
    func showNoTrendsAlert(error:String)
    {
        print("No Trends Found - Error \(error)")

        loader.hide()
        print("No Trends Found")
    }

    override func didReceiveMemoryWarning()
    {super.didReceiveMemoryWarning()}
}

//
// MARK: AccessoryView + RegionMenu + SourceMenu
//

extension HomeViewController:RegionMenuDelegate
{
    func drawAccessoryView()
    {
        accessoryView.backgroundColor = UIColor.clear
        accessoryView.frame.size.width = self.view.frame.width - 10
        drawRegionMenu()
    }
    
    func drawRegionMenu()
    {
        let f = CGRect.init(x: 0, y: 0, width: accessoryView.frame.size.width, height: 35)
        regionMenu = RegionMenuView.init(frame: f, userRegion: userRegion.code, parentView: self.view)
        regionMenu.delegate = self
        accessoryView.addSubview(regionMenu)
    }
    
    func didSelectRegion(code: String)
    {
        print("Selected Region : \(code)")
        self.getTrends(region:code)
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

















extension HomeViewController: TrendsCollectionViewDelegate, DetailsViewControllerDelegate
{
    func setTransitionImage(image: UIImage)
    {
        transitionImage = image
    }
    
    func trendDidSelected(indexPath: IndexPath)
    {
        guard let trend = collectionView?.trends[indexPath.row] else { return }
        print("Trend Selected \(trend.title)")
        
        // update sizes for transition
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let cellRect = attributes?.frame;
        transitionFrame = collectionView.convert(cellRect!, to: collectionView.superview)
        
        // reset the transition image
        transitionImage = UIImage.init(named: "Placeholder")
        
        // push the new view controller
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailsController = storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsController.country = regionMenu.currentRegion
        detailsController.rank = indexPath.row
        detailsController.trend = collectionView.trends[indexPath.row]
        detailsController.delegate = self
        self.navigationController?.pushViewController(detailsController, animated: true)
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
        return imageView
    }
    
    func transitionSourceImageViewFrame(forward: Bool) -> CGRect
    {
        let y = transitionFrame.origin.y
        return CGRect.init(x: 0, y: y , width: self.view.frame.width, height: transitionFrame.size.height)
    }
}













