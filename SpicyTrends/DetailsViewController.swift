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
    @IBOutlet private var contentView:UIView!
    
    @IBOutlet private var rankView:UIView!
    @IBOutlet public var mainImage:MainImageView!
    @IBOutlet private var trendLabel:UILabel!
    @IBOutlet private var rankImage:UIImageView!
    @IBOutlet private var wikiView:WikipediaDescriptionView!
    @IBOutlet private var newsCollectionView:NewsCollectionView!
    @IBOutlet private var tweetsCollectionView:TweetsCollectionView!
    @IBOutlet private var relatedTopicsView:TagsView!
    @IBOutlet private var goToGoogleButton:UIButton!
    @IBOutlet private var goToWikipediaButton:UIButton!

    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentSizeHeight: NSLayoutConstraint!

    @IBOutlet weak var contentViewY: NSLayoutConstraint!

    public var transitionFrame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        goToGoogleButton.alpha = 0
        goToWikipediaButton.alpha = 0
        mainImage.alpha = 0
        
        scrollView.isPagingEnabled = false
        scrollView.clipsToBounds = false
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -30)
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 4
        contentView.layer.cornerRadius = 4
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.white
        
        // Configure Ranking Circle
        rankView.layer.cornerRadius = rankView.frame.width / 2
        rankView.layer.borderWidth = 1
        rankView.backgroundColor = UIColor.clear
        
        switch trend.state
        {
            case "same":
                break
            case "new":
                rankImage.image = UIImage.init(named: "statusIconNEW")
                break
            case "up":
                rankImage.image = UIImage.init(named: "statusIconUP")
                break
            case "down":
                rankImage.image = UIImage.init(named: "statusIconDOWN")
                break
            default:
                break
        }
        
        // Configure Ranking Label
        let rankLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 35, height: 35))
        rankLabel.text = "\(rank+1)"
        rankLabel.textAlignment = .center
        rankLabel.font = UIFont.systemFont(ofSize: 17)
        rankView.addSubview(rankLabel)
        
        let colors = TrendColors.init()
        let hColor = colors.hottnessColorFrom(indexPath: rank)
        rankView.layer.borderColor = hColor.cgColor
        rankLabel.textColor = hColor
        
        // Start getting main image
        mainImage.getImage(word: trend.title)
        
        // Set Trend Title
        trendLabel.text = trend.title
        trendLabel.textColor = UIColor.darkGray
        //trendLabel.textColor = hColor

        // Show a description for the keyword (if we have one)
        wikiView.setWiki(wiki: trend.wiki)
        
        contentViewY.constant = 10
        contentViewHeight.constant = 215 + 65 + wikiView.frame.height + 30 + 25
        self.view.layoutIfNeeded()
        
        // Configure buttons size and layout
        let w:CGFloat = (UIScreen.main.bounds.size.width - 75) / 2
        goToGoogleButton.translatesAutoresizingMaskIntoConstraints = false
        goToWikipediaButton.translatesAutoresizingMaskIntoConstraints = false
        goToGoogleButton.widthAnchor.constraint(equalToConstant: w).isActive = true
        goToWikipediaButton.widthAnchor.constraint(equalToConstant: w).isActive = true
        goToGoogleButton.layer.cornerRadius = 4
        goToWikipediaButton.layer.cornerRadius = 4
 
        if (wikiView.isWikiSetted == false)
        {goToWikipediaButton.alpha = 0}
 
        if let news = trend.news?.news
        {
            newsCollectionView.setNews(news: news)
        }
                
        tweetsCollectionView.delegate = self
        tweetsCollectionView.getTweets(word: trend.title, region: country)
        
        updateHeight()
        
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
        newHeight = newHeight + mainImage.frame.height + 15
        newHeight = newHeight + rankView.frame.height + 15
        newHeight = newHeight + wikiView.wikiLabel.frame.height + 15
        newHeight = newHeight + goToGoogleButton.frame.size.height + 15
        if newsCollectionView.newsData.count > 0
        {
            newHeight = newHeight + 125
        }
        newHeight = newHeight + 15

        if tweetsCollectionView.tweetsData.count > 0
        {
            newHeight = newHeight + 125 + 15
        }
        
        contentViewY.constant = 10
        contentViewHeight.constant = newHeight
        contentSizeHeight.constant = newHeight
        
        UIView.animate(withDuration: 1)
        {
            self.goToGoogleButton.alpha = 1
            self.goToWikipediaButton.alpha = 1
            self.mainImage.alpha = 1
            self.view.layoutIfNeeded()
        }
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
    
    @IBAction func closeDetailsButtonPressed(_ sender: Any)
    {
        guard let _ = delegate?.setTransitionImage(image: mainImage.imageView.image!) else { return }
        navigationController?.popViewController(animated: true)
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
        let y = transitionY()
        return CGRect.init(x: 15, y: y, width: self.view.frame.width-30, height: transitionFrame.size.height)
    }
    
    func transitionY()->CGFloat
    {
        var xFix:CGFloat = 0
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
        {
            //iPhone X
            xFix = 23
        }
        return 215+10+20+xFix
    }
}

extension DetailsViewController:TweetsCollectionViewDelegate
{
    func tweetsDidLoad()
    {
        self.updateHeight()
    }
}
