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
    let time: Date? = nil
}

class NewsFeedVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, NewsFeedVMProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var transitionIndexPath: IndexPath?
    private var customInteractor : CustomInteractor?
    private var selectedFrame : CGRect?
    var zoomTransition: ZoomTransition?
    
    lazy fileprivate var viewModel: NewsFeedVM = {
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
        collectionView.backgroundColor = Constants().backgroundColor
        
        collectionView?.contentInset = UIEdgeInsets(top: NewsFeedInsets.kTopEdgeInset,
                                                         left: NewsFeedInsets.kLeftEdgeInset,
                                                         bottom: NewsFeedInsets.kBottomEdgeInset,
                                                         right: NewsFeedInsets.kRightEdgeInset)
        collectionView?.register(UINib(nibName: "\(FeedNewsCell.self)", bundle: nil), forCellWithReuseIdentifier: Constants().kReuseCellID)
        collectionView?.register(UINib(nibName: "\(FeedNewsTextCell.self)", bundle: nil), forCellWithReuseIdentifier: Constants().kReuseCellTextID)
        // Register XIB for Supplementary View Reuse
        let header = UINib(nibName: "FeedNewsSectionHeader", bundle: Bundle.main)
        collectionView.register(header, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants().kReuseHeader)
        
        customCollectionViewLayout?.delegate = self
        customCollectionViewLayout?.interItemsSpacing = NewsFeedInsets.kInterItemsSpacing
        
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
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if type(of: segue.destination) == NewsFeedDetailedVC.self {
            let feedDetailedVC = (segue.destination as! NewsFeedDetailedVC)
            let item  = viewModel.dataSource[(transitionIndexPath?.row)!]
            feedDetailedVC.feedItem = item
            //feedDetailedVC.transitioningDelegate = self
            feedDetailedVC.modalPresentationStyle = UIModalPresentationStyle.custom
            feedDetailedVC.navigationItem.hidesBackButton = true
        }
    }
    
    func updateDataSource() {
    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.dataSource[indexPath.item].feedType == FeedType.feedImage {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().kReuseCellID, for: indexPath) as! FeedNewsCell
            
            cell.backgroundImageView.image = viewModel.dataSource[indexPath.item].image
            cell.titleTextView.text = viewModel.dataSource[indexPath.item].title
            cell.subtitleLabel.text = viewModel.dataSource[indexPath.item].subtitle
            cell.backgroundColor = UIColor.red
            cell.isUserInteractionEnabled = true
            cell.titleTextView.isUserInteractionEnabled = false
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().kReuseCellTextID, for: indexPath) as! FeedNewsTextCell
            cell.titleTextView.text = viewModel.dataSource[indexPath.item].title
            cell.subtitleLabel.text = viewModel.dataSource[indexPath.item].subtitle
            cell.isUserInteractionEnabled = true
            cell.titleTextView.isUserInteractionEnabled = false
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants().kReuseHeader, for: indexPath) as? FeedNewsSectionHeader {
            // Configure Supplementary View
            supplementaryView.backgroundColor = .random()
            supplementaryView.titleHeader.text = "WEDNESDAY \(indexPath.section + 1) JUNE "
            
            return supplementaryView
        }
        else {
            return UICollectionReusableView()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        transitionIndexPath = indexPath
        
        self.performSegue(withIdentifier: SegueID.detailedFeedNews.rawValue, sender: nil)
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {


        
        
//        let board = UIStoryboard.storyboardWith(name: .newsFeed)
//        let feedDetailedVC = board.instantiateViewController(withIdentifier: "NewsFeedDetailedVC") as! NewsFeedDetailedVC
//
//        let item  = dataSource[(transitionIndexPath?.row)!]
//        feedDetailedVC.feedItem = item
//        self.present(feedDetailedVC, animated: true, completion: nil)
    }
    // MARK: UICollectionViewLayout
    
    public var customCollectionViewLayout: FeedNewsLayout? {
        get {
            return collectionView.collectionViewLayout as? FeedNewsLayout
        }
        set {
            if newValue != nil {
                self.collectionView?.collectionViewLayout = newValue!
            }
        }
    }
    
    // MARK: Section header

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        self.collectionView?.collectionViewLayout.invalidateLayout()
//    }
}

extension NewsFeedVC: CollectionViewFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, widthForItemAt indexPath: IndexPath) -> CGFloat {
        return collectionView.frame.size.width
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.dataSource[indexPath.item]
        if item.feedType == FeedType.feedImage {
//            if let height = item.image?.size.height {
//                return height
//            }
//            else {
                return Constants().kImgCellHeight * collectionView.frame.size.width
//            }
        }
        else if item.feedType == FeedType.feedText {
            let font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            let size = font?.sizeOfString(string: item.title!, constrainedToWidth: collectionView.frame.size.width - 16)
            
            return (size?.height)! + CGFloat(46)
        }
        return 60.0
    }
}

extension NewsFeedVC: UICollectionViewDelegateFlowLayout {
    
    // MARK: - Collection View Delegate Flow Layout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 44.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 80.0)
    }
}

// MARK: Navigation transition


extension NewsFeedVC {
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let ci = customInteractor else { return nil }
        return ci.transitionInProgress ? customInteractor : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let cell = self.collectionView.cellForItem(at: transitionIndexPath!)
        let frame = cell?.frame
        let item  = viewModel.dataSource[(transitionIndexPath?.row)!]
        var img: UIImage = UIImage()
        if item.image != nil {
            img = item.image!
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
        let item  = viewModel.dataSource[(transitionIndexPath?.row)!]
        var img: UIImage = UIImage()
        if item.image != nil {
            img = item.image!
        }
        
        self.zoomTransition = ZoomTransition(duration: TimeInterval(UINavigationControllerHideShowBarDuration), isPresenting: true, originFrame: frame, image: img)
        return self.zoomTransition
    }
}
