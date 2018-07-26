//
//  NewsFeedVC.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/13/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

fileprivate struct NewsFeedInsets {
    static let kInterItemsSpacing: CGFloat = 14
    static let kTopEdgeInset: CGFloat = 8
    static let kBottomEdgeInset: CGFloat = 8
    static let kLeftEdgeInset: CGFloat = 16
    static let kRightEdgeInset: CGFloat = 16
    static let kBarHeight: CGFloat = 0.2
}

fileprivate enum SegueID: String {
    case detailedFeedNews = "DetailedFeedNews"
    case descriptionFeedNews = "DescriptionFeedNews"
}

private struct Constants {
    
    let kReuseCellID = "FeedNewsCell"
    let kReuseCellTextID = "FeedNewsTextCell"
    let kReuseHeader = "FeedNewsSectionHeader"
    let kImgName = "pict_"
    let kImgCellHeight: CGFloat = 0.866
    let headerHeight = 40.0
    
    let backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
}

public enum FeedType: Int {
    case feedImage = 0
    case feedText = 1
    case count = 2
}

// Will be replaced by mediator for download manager
public struct FeedItem {
    let image: UIImage?
    let title: String?
    let subtitle: String?
    let content: String?
    let feedType: FeedType?
    let time: Date?
}

class NewsFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NewsFeedVMProtocol {
    //UIViewControllerTransitioningDelegate, UINavigationControllerDelegate,  {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var transitionIndexPath: IndexPath? = IndexPath()
    private var customInteractor : CustomInteractor?
    private var selectedFrame : CGRect?
    var zoomTransition: ZoomTransition?
    
    lazy fileprivate var viewModel: NewsFeedDataSource = {
        return NewsFeedVM(delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        
        viewModel.populateDataSource()
        
        //self.navigationController?.delegate = self
    }
    
    func setupAppearance() {
        view.backgroundColor = Constants().backgroundColor
        tableView.backgroundColor = Constants().backgroundColor
        tableView?.contentInset = UIEdgeInsets(top: 0,
                                                         left: 0,
                                                         bottom: NewsFeedInsets.kBottomEdgeInset + NewsFeedInsets.kBarHeight * view.frame.size.width,
                                                         right: 0)
        tableView?.register(UINib(nibName: "\(FeedNewsCell.self)", bundle: nil), forCellReuseIdentifier: Constants().kReuseCellID)
        tableView?.register(UINib(nibName: "\(FeedNewsTextCell.self)", bundle: nil), forCellReuseIdentifier: Constants().kReuseCellTextID)
        // Register XIB for Supplementary View Reuse
        let header = UINib(nibName: Constants().kReuseHeader, bundle: Bundle.main)
        tableView.register(header, forHeaderFooterViewReuseIdentifier: Constants().kReuseHeader)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 20))
        label.font = UIFont(name: "Noteworthy-Bold", size: 25)
        label.text = "wristcam"
        label.textAlignment = NSTextAlignment.center
        self.navigationItem.titleView = label
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.endAppearanceTransition()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if type(of: segue.destination) == NewsFeedDetailedVC.self {
            if let feedDetailedVC = segue.destination as? NewsFeedDetailedVC {
                let item  = viewModel.feedItemForIndex(index: transitionIndexPath!)
                feedDetailedVC.feedItem = item
                //feedDetailedVC.transitioningDelegate = self
                //feedDetailedVC.modalPresentationStyle = UIModalPresentationStyle.custom
                feedDetailedVC.navigationItem.hidesBackButton = true
            }
        }
    }
    
    func updateDataSource() {
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupedFeeds[viewModel.sectionKeys[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feed = viewModel.feedItemForIndex(index: indexPath)
        if feed?.feedType == FeedType.feedImage {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants().kReuseCellID, for: indexPath) as! FeedNewsCell
            
            cell.backgroundImageView.image = feed?.image
            cell.titleTextView.text = feed?.title
            cell.subtitleLabel.text = feed?.subtitle
            cell.isUserInteractionEnabled = true
            cell.titleTextView.isUserInteractionEnabled = false
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants().kReuseCellTextID, for: indexPath) as! FeedNewsTextCell
            cell.titleTextView.text = feed?.title
            cell.subtitleLabel.text = feed?.subtitle
            cell.isUserInteractionEnabled = true
            cell.titleTextView.isUserInteractionEnabled = false
            return cell
        }
     }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        transitionIndexPath = indexPath
        
        let storyboard = UIStoryboard(name: "NewsFeed", bundle: nil)
        let feedDetailedVC = storyboard.instantiateViewController(withIdentifier: "NewsFeedDetailedVC") as! NewsFeedDetailedVC
        
        let item  = viewModel.feedItemForIndex(index: transitionIndexPath!)
        feedDetailedVC.feedItem = item
        feedDetailedVC.navigationItem.hidesBackButton = true
        self.navigationController?.present(feedDetailedVC, animated: true, completion: nil)

        return true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants().headerHeight)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants().kReuseHeader) as! FeedNewsSectionHeader
        let time = viewModel.sectionKeys[section]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM, YYYY"
        
        header.titleHeader.text = dateFormatter.string(from: time).uppercased()
        return header
    }
}

extension NewsFeedVC {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.feedItemForIndex(index: indexPath)
        if item?.feedType == FeedType.feedImage {
            return Constants().kImgCellHeight * tableView.frame.size.width
        }
        else if item?.feedType == FeedType.feedText {
            let font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            let size = font?.sizeOfString(string: (item?.title!)!, constrainedToWidth: tableView.frame.size.width - 16)
            
            return (size?.height)! + CGFloat(46)
        }
        return 120.0
    }
}

// MARK: Navigation transition

extension NewsFeedVC {
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let ci = customInteractor else { return nil }
        return ci.transitionInProgress ? customInteractor : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let cell = self.tableView.cellForRow(at: transitionIndexPath!)
        let frame = cell?.frame
        let item  = viewModel.feedItemForIndex(index: transitionIndexPath!)
        var img: UIImage = UIImage()
        if item?.image != nil {
            img = (item?.image!)!
        }
        
        switch operation {
        case .push:
            self.customInteractor = CustomInteractor(attachTo: toVC)
            return ZoomTransition(duration: TimeInterval(10), isPresenting: true, originFrame: frame!, image: img)
        default:
            return ZoomTransition(duration: TimeInterval(UINavigationControllerHideShowBarDuration), isPresenting: false, originFrame: frame!, image: img)
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let frame = self.selectedFrame else { return nil }
        let item  = viewModel.feedItemForIndex(index: transitionIndexPath!)
        var img: UIImage = UIImage()
        if item?.image != nil {
            img = (item?.image!)!
        }
        
        self.zoomTransition = ZoomTransition(duration: TimeInterval(UINavigationControllerHideShowBarDuration), isPresenting: true, originFrame: frame, image: img)
        return self.zoomTransition
    }
}
