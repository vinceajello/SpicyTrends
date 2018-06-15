//
//  DetailsViewController.swift
//  SpicyTrends
//
//  Created by Vincenzo Ajello on 30/05/18.
//  Copyright © 2018 mskaline. All rights reserved.
//

import UIKit

protocol DetailsViewControllerDelegate
{
    func setTransitionImage(image:UIImage)
}

class DetailsViewController: UIViewController
{
    public var trend:Trend!
    public var rank:Int = 0
    public var country:String!
    
    var delegate:DetailsViewControllerDelegate!
    
    let netManager = NetworkManager.init()
    @IBOutlet private var scrollView:UIScrollView!
    @IBOutlet private var rankView:UIView!
    @IBOutlet private var mainImage:MainImageView!
    @IBOutlet private var trendLabel:UILabel!
    @IBOutlet private var wikiView:WikipediaDescriptionView!
    @IBOutlet private var newsCollectionView:NewsCollectionView!
    @IBOutlet private var tweetsCollectionView:TweetsCollectionView!
    @IBOutlet private var relatedTopicsView:TagsView!
    @IBOutlet private var goToGoogleButton:UIButton!
    @IBOutlet private var goToWikipediaButton:UIButton!

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        //tweetsCollectionView.configAutoscrollTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        //tweetsCollectionView.deconfigAutoscrollTimer()
    }
    
    @objc func back()
    {
        guard let _ = delegate?.setTransitionImage(image: mainImage.imageView.image!) else { return }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        scrollView.isPagingEnabled = false
        let back = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action: #selector(self.back))
        self.navigationItem.leftBarButtonItem = back
        
        // Configure Ranking Circle
        rankView.layer.cornerRadius = rankView.frame.width / 2
        rankView.layer.borderWidth = 1
        rankView.backgroundColor = UIColor.clear
        //mainImage.addSubview(rankView)
        
        // Configure Ranking Label
        let rankLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        rankLabel.text = "\(rank+1)"
        rankLabel.textAlignment = .center
        rankLabel.font = UIFont.boldSystemFont(ofSize: 22)
        rankView.addSubview(rankLabel)
        
        let colors = TrendColors.init()
        let hColor = colors.hottnessColorFrom(indexPath: rank)
        rankView.layer.borderColor = hColor.cgColor
        rankLabel.textColor = hColor
        
        /*
        // configure Flag icon
        let flagIcon = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: circleSize/2, height: circleSize/2))
        flagIcon.backgroundColor = UIColor.brown
        flagIcon.layer.cornerRadius = circleSize / 4
        flagIcon.image = UIImage.init(named: country)
        flagIcon.clipsToBounds = true
        flagIcon.center.x = circleView.center.x + 20
        flagIcon.center.y = circleView.center.y + 20
        mainImage.addSubview(flagIcon)
        */
 
        /*
        // Search on Google Button
        let screen = UIScreen.main.bounds
        let googleSearchButton = UIButton.init(type: .custom)
        googleSearchButton.frame = CGRect.init(x: screen.width-50-10, y: 0, width: 50, height: 50)
        googleSearchButton.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        googleSearchButton.layer.borderWidth = 1
        googleSearchButton.layer.cornerRadius = googleSearchButton.frame.width / 2
        googleSearchButton.clipsToBounds = true
        googleSearchButton.setImage(UIImage.init(named: "SearchOnGoogle"), for: .normal)
        googleSearchButton.backgroundColor = UIColor.lightText.withAlphaComponent(0.6)
        mainImage.addSubview(googleSearchButton)
        googleSearchButton.center.y = circleView.center.y
        */
        
        // Start getting main image
        mainImage.getMainImage(word: trend.title)
        
        // Set Trend Title
        trendLabel.text = trend.title
        trendLabel.textColor = hColor

        // Show a description for the keyword (if we have one)
        wikiView.setDescription(word: trend.title)
        
        // Configure buttons size and layout
        let w:CGFloat = (UIScreen.main.bounds.size.width - 25) / 2
        goToGoogleButton.translatesAutoresizingMaskIntoConstraints = false
        goToWikipediaButton.translatesAutoresizingMaskIntoConstraints = false
        goToGoogleButton.widthAnchor.constraint(equalToConstant: w).isActive = true
        goToWikipediaButton.widthAnchor.constraint(equalToConstant: w).isActive = true
        goToGoogleButton.layer.cornerRadius = 4
        goToWikipediaButton.layer.cornerRadius = 4

        if wikiView.isDescriptionSet != true
        {goToWikipediaButton.alpha = 0}
                
        newsCollectionView.setNews(news: TrendsData.shared.news[trend.title]!)
        
        //NSLayoutConstraint.activate([heightConstraint])
        
        
        // Start getting related tweets
        //tweetsCollectionView.getTweets(word: trend.title, region: country)
 
        //self.updateHeight()
        
        // Get suggested word from api
        /*
        netManager.getSuggestionsByKeyword(word: trend.title)
        {
            (success, response) in
            
            if success == true
            {
                //print("Suggestions : \(response)")
                let suggestions = self.limitSuggestionsTo(max: 5, suggestions: response)
                self.showRelatedTopics(suggested:suggestions)
                return
            }
            print("no-suggestions error (\(response)")
        }
         */
    }

    func updateHeight()
    {
        var newHeight:CGFloat = 0
        for view in self.view.subviews
        {
            newHeight = newHeight + view.frame.height
        }
        scrollView.contentSize.height = newHeight
    }
    
    func showRelatedTopics(suggested:[String])
    {
        relatedTopicsView.lineBreakMode = .byTruncatingTail
        relatedTopicsView.append(contentsOf: suggested)
    }
    
    func limitSuggestionsTo(max:Int,suggestions:String)->[String]
    {
        let a = suggestions.components(separatedBy: ", ")
        var o:[String] = []
        if a.count > 10
        {for i in 0...max-1
        {o.append(a[i])}}
        else {o = a}
        return o
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

extension DetailsViewController:ZoomTransitionDestinationDelegate
{
    func transitionDestinationImageViewFrame(forward: Bool) -> CGRect
    {
        return CGRect.init(x: 0, y: 65, width: self.view.frame.width, height: 215)
    }
    
    
}
