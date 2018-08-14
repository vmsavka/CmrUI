//
//  ProfileVC.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/23/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

fileprivate struct Insets {
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

fileprivate struct LayoutInsets {
    static let kInterSpacing: CGFloat = 14
    static let kSide: CGFloat = 20
}

private struct Constants {
    let kReuseChartCell = "TotalPhotosChartCell"
    let kReuseBatteryCell = "BatteryRemainingCell"
    let kProfileInfoCell = "ProfileInfoCell"
    let kSunsetRemainingCell = "SunsetRemainingCell"
    let kImgCellHeight: CGFloat = 0.866
    
    let backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
}

class ProfileVC: UICollectionViewController, UINavigationControllerDelegate, NewsFeedVMProtocol, ProfileLayoutDelegate, ProfileTabView, AddChildVCProtocol {

    var configurator = ProfileConfiguratorImplementation()
    var presenter: ProfilePresenter!
    
    fileprivate var transitionIndexPath: IndexPath?
    private var customInteractor : CustomInteractor?
    private var selectedFrame : CGRect?
    var zoomTransition: ZoomTransition?
    var offsetIndexes: [CGFloat]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        configurator.configure(profileVC: self)
        presenter.viewDidLoad()
        
        //self.navigationController?.delegate = self
    }
    
    func setupAppearance() {
        view.backgroundColor = Constants().backgroundColor
        collectionView?.backgroundColor = Constants().backgroundColor
        
        collectionView?.contentInset = UIEdgeInsets(top: Insets.kTopEdgeInset,
                                                    left: Insets.kLeftEdgeInset,
                                                    bottom: Insets.kBottomEdgeInset,
                                                    right: Insets.kRightEdgeInset)
        collectionView?.register(UINib(nibName: "\(ProfileInfoCell.self)", bundle: nil), forCellWithReuseIdentifier: Constants().kProfileInfoCell)
        collectionView?.register(UINib(nibName: "\(TotalPhotosChartCell.self)", bundle: nil), forCellWithReuseIdentifier: Constants().kReuseChartCell)
        collectionView?.register(UINib(nibName: "\(SunsetRemainingCell.self)", bundle: nil), forCellWithReuseIdentifier: Constants().kSunsetRemainingCell)
        collectionView?.register(UINib(nibName: "\(BatteryRemainingCell.self)", bundle: nil), forCellWithReuseIdentifier: Constants().kReuseBatteryCell)
        
        
        collectionView?.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellWithReuseIdentifier: "ProfileInfoCell")
        
        

        customCollectionViewLayout?.delegate = self
        customCollectionViewLayout?.interItemsSpacing = Insets.kInterItemsSpacing
        let roundFrame = (collectionView?.frame.size.width)!/2 - 29
        customCollectionViewLayout?.itemSizes = [
            CGSize(width: (collectionView?.frame.size.width)! - 50, height: (collectionView?.frame.size.height)! * 0.25),
            CGSize(width: roundFrame, height: roundFrame),
            CGSize(width: roundFrame, height: roundFrame),
            CGSize(width: (collectionView?.frame.size.width)! - 50, height: (collectionView?.frame.size.height)! * 0.21),
        ]
        customCollectionViewLayout?.xOffsets = [10, 10, (customCollectionViewLayout?.itemSizes[1].width)! + 18, 10]
        customCollectionViewLayout?.yOffsets = [0]
        customCollectionViewLayout?.yOffsets.append((customCollectionViewLayout?.itemSizes[0].height)! + 12)
        customCollectionViewLayout?.yOffsets.append((customCollectionViewLayout?.itemSizes[0].height)! + 12)
        customCollectionViewLayout?.yOffsets.append((customCollectionViewLayout?.yOffsets.last)! + (customCollectionViewLayout?.itemSizes[2].height)! + 12)

        /*
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 20))
        label.font = UIFont(name: "Noteworthy-Bold", size: 25)
        label.text = "wristcam"
        label.textAlignment = NSTextAlignment.center
        self.navigationItem.titleView = label*/
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
//        if type(of: segue.destination) == NewsFeedDetailedVC.self {
//            let feedDetailedVC = (segue.destination as! NewsFeedDetailedVC)
//            let item  = viewModel.dataSource[(transitionIndexPath?.row)!]
//            feedDetailedVC.ProfileItem = item
//            //feedDetailedVC.transitioningDelegate = self
//            feedDetailedVC.modalPresentationStyle = UIModalPresentationStyle.custom
//            feedDetailedVC.navigationItem.hidesBackButton = true
//        }
        presenter.router.prepare(for: segue, sender: sender)
    }
    
    func updateDataSource() {
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = ProfileItemType(rawValue: indexPath.row)
        switch (type) {
        case .profileInfo?:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileInfoCell", for: indexPath) as! ProfileInfoCell
            presenter.configure(cell: cell, forRow: type?.rawValue ?? 0)
            cell.parentVC = self
            return cell
        case .batteryRemaining?:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().kReuseBatteryCell, for: indexPath) as! BatteryRemainingCell
            presenter.configure(cell: cell, forRow: type?.rawValue ?? 0)
            return cell
        case .sunsetRemaining?:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().kSunsetRemainingCell, for: indexPath) as! SunsetRemainingCell
            presenter.configure(cell: cell, forRow: type?.rawValue ?? 0)
            return cell
        case .photosTotalChart?:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().kReuseChartCell, for: indexPath) as! TotalPhotosChartCell
            presenter.configure(cell: cell, forRow: type?.rawValue ?? 0)
            return cell
        case .count?:
            return UICollectionViewCell()
        case .none:
            return UICollectionViewCell()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        transitionIndexPath = indexPath
        
        //self.performSegue(withIdentifier: SegueID.detailedFeedNews.rawValue, sender: nil)
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let board = UIStoryboard.storyboardWith(name: .newsFeed)
        //        let feedDetailedVC = board.instantiateViewController(withIdentifier: "NewsFeedDetailedVC") as! NewsFeedDetailedVC
        //
        //        let item  = dataSource[(transitionIndexPath?.row)!]
        //        feedDetailedVC.ProfileItem = item
        //        self.present(feedDetailedVC, animated: true, completion: nil)
    }
    // MARK: UICollectionViewLayout
    
    public var customCollectionViewLayout: ProfileLayout? {
        get {
            return collectionView?.collectionViewLayout as? ProfileLayout
        }
        set {
            if newValue != nil {
                self.collectionView?.collectionViewLayout = newValue!
            }
        }
    }
    
    func addChildVC(childController: UIViewController, containerView: UIView) {
        self.addChildViewController(childController)
        containerView.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
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

//extension ProfileVC: CollectionViewFlowLayoutDelegate {
//    func collectionView(_ collectionView: UICollectionView, widthForItemAt indexPath: IndexPath) -> CGFloat {
//        return collectionView.frame.size.width
//    }

//    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
//        return (customCollectionViewLayout?.itemSizes.count)! > indexPath.row ? customCollectionViewLayout?.itemSizes[indexPath.row].height ?? 80 : 80
//    }
//}

extension ProfileVC {
    func collectionView(_ collectionView: UICollectionView, frameForItemAt indexPath: IndexPath, columnNumber: Int) -> CGFloat {
        return 0
    }
}

extension ProfileVC {
    func refreshProfileView() {
        self.collectionView?.reloadData()
    }
    
    func displayProfileRetrievalError(title: String, message: String) {
    }
}
