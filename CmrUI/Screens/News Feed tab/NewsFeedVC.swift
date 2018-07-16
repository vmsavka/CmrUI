//
//  NewsFeedVC.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/13/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

private let kReuseCellID = "FeedNewsCell"
private let kReuseCellTextID = "FeedNewsTextCell"
private let kReuseHeader = "FeedNewsSectionHeader"
private let kImgName = "pict_"
private let kImgCellHeight: CGFloat = 0.866

fileprivate struct NewsFeedInsets {
    static let kInterItemsSpacing: CGFloat = 14
    static let kTopEdgeInset: CGFloat = 8
    static let kBottomEdgeInset: CGFloat = 8
    static let kLeftEdgeInset: CGFloat = 16
    static let kRightEdgeInset: CGFloat = 16
}

private struct Constants {
    enum SegueID: String {
        case cardCreationSummary = "DetailedFeedNews"
        case enterCardAmount = "DescriptionFeedNews"
    }
}

fileprivate enum FeedType: Int {
    case feedImage = 0
    case feedText = 1
    case count = 2
}

// Will be replaced by mediator for download manager
fileprivate struct FeedItem {
    let image: UIImage?
    let title: String?
    let subtitle: String?
    let feedType: FeedType?
}

class NewsFeedVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Will b moved to the model later, it's a stub for now
    fileprivate var dataSource = [FeedItem]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        
        dataSource = [
            FeedItem(image: UIImage(named: kImgName + "\(1)"), title: "First title", subtitle: "First subtitle", feedType: FeedType.feedImage),
            FeedItem(image: nil, title: "First text title", subtitle: "Only text subtitle", feedType: FeedType.feedText),
            FeedItem(image: UIImage(named: kImgName + "\(2)"), title: "Second title", subtitle: "Second subtitle", feedType: FeedType.feedImage),
            FeedItem(image: UIImage(named: kImgName + "\(3)"), title: "Third title", subtitle: "Third subtitle", feedType: FeedType.feedImage),
            FeedItem(image: UIImage(named: kImgName + "\(4)"), title: "Fourth title", subtitle: "Fourth subtitle", feedType: FeedType.feedImage),
            FeedItem(image: nil, title: "A huge iceberg has drifted close to a village in western Greenland, prompting a partial evacuation in case it splits and the resulting wave swamps homes.", subtitle: "Massive iceberg threatens Greenland village", feedType: FeedType.feedText),
            FeedItem(image: UIImage(named: kImgName + "\(5)"), title: "Fifth title", subtitle: "Fifth subtitle", feedType: FeedType.feedImage)
        ]
    }
    
    func setupAppearance() {
        view.backgroundColor = UIColor.white
        collectionView.backgroundColor = UIColor.white
        
        collectionView?.contentInset = UIEdgeInsets(top: NewsFeedInsets.kTopEdgeInset,
                                                         left: NewsFeedInsets.kLeftEdgeInset,
                                                         bottom: NewsFeedInsets.kBottomEdgeInset,
                                                         right: NewsFeedInsets.kRightEdgeInset)
        collectionView?.register(UINib(nibName: "\(FeedNewsCell.self)", bundle: nil), forCellWithReuseIdentifier: kReuseCellID)
        collectionView?.register(UINib(nibName: "\(FeedNewsTextCell.self)", bundle: nil), forCellWithReuseIdentifier: kReuseCellTextID)
        // Register XIB for Supplementary View Reuse
        let header = UINib(nibName: "FeedNewsSectionHeader", bundle: Bundle.main)
        collectionView.register(header, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kReuseHeader)
        
        customCollectionViewLayout?.delegate = self
        customCollectionViewLayout?.interItemsSpacing = NewsFeedInsets.kInterItemsSpacing
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if dataSource[indexPath.item].feedType == FeedType.feedImage {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseCellID, for: indexPath) as! FeedNewsCell
            
            cell.backgroundImageView.image = dataSource[indexPath.item].image
            cell.titleTextView.text = dataSource[indexPath.item].title
            cell.subtitleLabel.text = dataSource[indexPath.item].subtitle
            cell.backgroundColor = UIColor.red
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReuseCellTextID, for: indexPath) as! FeedNewsTextCell
            cell.titleTextView.text = dataSource[indexPath.item].title
            cell.subtitleLabel.text = dataSource[indexPath.item].subtitle
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kReuseHeader, for: indexPath) as? FeedNewsSectionHeader {
            // Configure Supplementary View
            supplementaryView.backgroundColor = .random()
            supplementaryView.titleHeader.text = "WEDNESDAY \(indexPath.section + 1) JUNE "
            
            return supplementaryView
        }
        else {
            return UICollectionReusableView()
        }
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
        let item = dataSource[indexPath.item]
        if item.feedType == FeedType.feedImage {
//            if let height = item.image?.size.height {
//                return height
//            }
//            else {
                return kImgCellHeight * collectionView.frame.size.width
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
