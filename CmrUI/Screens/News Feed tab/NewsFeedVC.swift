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

private struct Constants {
    
    let kReuseCellID = "FeedNewsCell"
    let kReuseCellTextID = "FeedNewsTextCell"
    let kReuseHeader = "FeedNewsSectionHeader"
    let kImgName = "pict_"
    let kImgCellHeight: CGFloat = 0.866
    
    enum SegueID: String {
        case detailedFeedNews = "DetailedFeedNews"
        case descriptionFeedNews = "DescriptionFeedNews"
    }
    
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

class NewsFeedVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    //Will b moved to the model later, it's a stub for now
    fileprivate var dataSource = [FeedItem]()
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var transitionIndexPath: IndexPath?
    private var customInteractor : CustomInteractor?
    private var selectedFrame : CGRect?
    var zoomTransition: ZoomTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        
        dataSource = [
            FeedItem(image: UIImage(named: Constants().kImgName + "\(1)"), title: "First title", subtitle: "First subtitle", content: "First content", feedType: FeedType.feedImage),
            FeedItem(image: nil, title: "First text title", subtitle: "Only text subtitle", content: "", feedType: FeedType.feedText),
            FeedItem(image: UIImage(named: Constants().kImgName + "\(2)"), title: "Second title", subtitle: "Second subtitle", content: "Second content", feedType: FeedType.feedImage),
            FeedItem(image: UIImage(named: Constants().kImgName + "\(3)"), title: "Third title", subtitle: "Third subtitle", content: "The photographs are stunning: a giant mountain of ice towers over a tiny village, with colorful homes reminiscent of little doll houses against the stark, blue-gray landscape.\nBut for the people living in those houses – that beauty could be life-threatening.\nIts kind of like, if you lived in the suburbs, and you woke up one morning and looked out, and there was a skyscraper next to your house,\n says David Holland, an oceanographer at New York University who does research in Greenland during the summer months.I'd be the first to get out of there.\nHe says that's why authorities have taken action to evacuate those living closest to the water from the village of Innaarsuit, where the iceberg has parked itself just off the coast. According to the BBC, the village has just 169 residents.\nIn these shallow bays, these icebergs may drift in and become stuck, grounded on the sea floor, Holland says.So that's what happened to one of these bergs.Holland says it can be quite alarming for residents. Article continues after sponsorship These are small villages with little houses located right at the shoreline, and all of a sudden icebergs show up, and they look like New York skyscrapers, they're just towering, he says.They're very unstable, and they can break up.\nLast year in northwestern Greenland, four people died when a landslide resulted in a tsunami that swamped a number of homes.That disaster is fresh in peoples' minds, says glaciologist Anna Hogg at the University of Leeds, who also does research in Greenland.\nMassive Iceberg Makes A Stop Off Newfoundland Coast World Massive Iceberg Makes A Stop Off Newfoundland Coast There's a risk that a large chunk of ice could break off this very large iceberg, fall into the ocean, and cause a mini-tidal wave that will wash up and hit the village, Dr. Hogg says.\n We know that icebergs are quite fragile things, they've got lots of fractures through them, she adds.\n\nOne surprising thing about many of the seaside communities in Greenland, Hogg says, is that despite the marine-based economy, most people can't swim. Hogg has spent a lot of time doing research near the village that's currently under threat from the iceberg, and says this adds to the risk of a potential tidal wave or flooding.\nThere's only one swimming pool in Greenland. It's in Nuuk, which is much further down the coast than this village that we're talking about, Hogg says. If you think about it, why would they be able to swim? The ocean water is just so cold; you can't even put your toe in without it being unbearably freezing.\nLocal authorities and media are keeping close watch on the iceberg: the newspaper Sermitsiaq reported today that it moved 500-600 meters during the night.\nThough the process of glaciers losing ice is natural, and happens every summer, the waters around Greenland have warmed in recent decades, which means that it's happening at a faster rate.", feedType: FeedType.feedImage),
            FeedItem(image: UIImage(named: Constants().kImgName + "\(4)"), title: "Fourth title", subtitle: "Fourth subtitle", content: "Fourth content", feedType: FeedType.feedImage),
            FeedItem(image: nil, title: "A huge iceberg has drifted close to a village in western Greenland, prompting a partial evacuation in case it splits and the resulting wave swamps homes.",
                     subtitle: "Massive iceberg threatens Greenland village", content: "The photographs are stunning: a giant mountain of ice towers over a tiny village, with colorful homes reminiscent of little doll houses against the stark, blue-gray landscape.\nBut for the people living in those houses – that beauty could be life-threatening.\nIts kind of like, if you lived in the suburbs, and you woke up one morning and looked out, and there was a skyscraper next to your house,\n says David Holland, an oceanographer at New York University who does research in Greenland during the summer months.I'd be the first to get out of there.\nHe says that's why authorities have taken action to evacuate those living closest to the water from the village of Innaarsuit, where the iceberg has parked itself just off the coast. According to the BBC, the village has just 169 residents.\nIn these shallow bays, these icebergs may drift in and become stuck, grounded on the sea floor, Holland says.So that's what happened to one of these bergs.Holland says it can be quite alarming for residents. Article continues after sponsorship These are small villages with little houses located right at the shoreline, and all of a sudden icebergs show up, and they look like New York skyscrapers, they're just towering, he says.They're very unstable, and they can break up.\nLast year in northwestern Greenland, four people died when a landslide resulted in a tsunami that swamped a number of homes.That disaster is fresh in peoples' minds, says glaciologist Anna Hogg at the University of Leeds, who also does research in Greenland.\nMassive Iceberg Makes A Stop Off Newfoundland Coast World Massive Iceberg Makes A Stop Off Newfoundland Coast There's a risk that a large chunk of ice could break off this very large iceberg, fall into the ocean, and cause a mini-tidal wave that will wash up and hit the village, Dr. Hogg says.\n We know that icebergs are quite fragile things, they've got lots of fractures through them, she adds.\n\nOne surprising thing about many of the seaside communities in Greenland, Hogg says, is that despite the marine-based economy, most people can't swim. Hogg has spent a lot of time doing research near the village that's currently under threat from the iceberg, and says this adds to the risk of a potential tidal wave or flooding.\nThere's only one swimming pool in Greenland. It's in Nuuk, which is much further down the coast than this village that we're talking about, Hogg says. If you think about it, why would they be able to swim? The ocean water is just so cold; you can't even put your toe in without it being unbearably freezing.\nLocal authorities and media are keeping close watch on the iceberg: the newspaper Sermitsiaq reported today that it moved 500-600 meters during the night.\nThough the process of glaciers losing ice is natural, and happens every summer, the waters around Greenland have warmed in recent decades, which means that it's happening at a faster rate."
,
                feedType: FeedType.feedText),
                FeedItem(image: UIImage(named: Constants().kImgName + "\(5)"), title: "Fifth title", subtitle: "Fifth subtitle", content: "Fifth content", feedType: FeedType.feedImage)
        ]
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
            let item  = dataSource[(transitionIndexPath?.row)!]
            feedDetailedVC.feedItem = item
            //feedDetailedVC.transitioningDelegate = self
            feedDetailedVC.modalPresentationStyle = UIModalPresentationStyle.custom
            feedDetailedVC.navigationItem.hidesBackButton = true
        }
    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if dataSource[indexPath.item].feedType == FeedType.feedImage {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().kReuseCellID, for: indexPath) as! FeedNewsCell
            
            cell.backgroundImageView.image = dataSource[indexPath.item].image
            cell.titleTextView.text = dataSource[indexPath.item].title
            cell.subtitleLabel.text = dataSource[indexPath.item].subtitle
            cell.backgroundColor = UIColor.red
            cell.isUserInteractionEnabled = true
            cell.titleTextView.isUserInteractionEnabled = false
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().kReuseCellTextID, for: indexPath) as! FeedNewsTextCell
            cell.titleTextView.text = dataSource[indexPath.item].title
            cell.subtitleLabel.text = dataSource[indexPath.item].subtitle
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
        
        self.performSegue(withIdentifier: "DetailedFeedNews", sender: nil)
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
        let item = dataSource[indexPath.item]
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
        let item  = dataSource[(transitionIndexPath?.row)!]
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
        let item  = dataSource[(transitionIndexPath?.row)!]
        var img: UIImage = UIImage()
        if item.image != nil {
            img = item.image!
        }
        
        self.zoomTransition = ZoomTransition(duration: TimeInterval(UINavigationControllerHideShowBarDuration), isPresenting: true, originFrame: frame, image: img)
        return self.zoomTransition
    }
}
