//
//  ProfileBadgesCollectionVC.swift
//  CmrUI
//

import UIKit

private let badgesCellIdentifier = "ProfileBadgesCell"

private struct Constants {
    static let sectionInsets = UIEdgeInsets(top: 1.0, left: 5.0, bottom: 1.0, right: 5.0)
    static let cellSize = Device.IS_4_INCHES_OR_SMALLER() ?
    CGSize(width: 24, height: 24) : CGSize(width: 32, height: 32)
}

fileprivate enum SegueID: String {
    case addNewBadge = "addNewBadge"
    case detailedBadgeInfo = "detailedBadgeInfo"
}

typealias selectBadgeCallback = ((Badge) -> Void)

class ProfileBadgesCollectionVC: UICollectionViewController {
    
    fileprivate typealias c = Constants
    
    lazy fileprivate var viewModel: ProfileBadgesCollectionVM = {
        return ProfileBadgesCollectionVM(delegate: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        viewModel.loadUserBadges()
    }
    
    func setupUI() {
        collectionView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "\(ProfileBadgesCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(ProfileBadgesCell.self)")
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (viewModel.statuses?.count ?? 0) + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: badgesCellIdentifier, for: indexPath) as! ProfileBadgesCell
        
        if viewModel.statuses == nil || indexPath.row == (viewModel.statuses?.count)! {
            cell.setImage(image: UIImage(named: "add_new_status"))
        }
        else if let statuses = viewModel.statuses {
            cell.setImage(image: statuses[indexPath.row].image())
        }
        cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if indexPath.row == viewModel.statuses?.count {
            self.performSegue(withIdentifier: SegueID.addNewBadge.rawValue, sender: nil)
        }
        else {
            let selectedBadge : Badge? = viewModel.statuses?[indexPath.row]
            self.performSegue(withIdentifier: SegueID.detailedBadgeInfo.rawValue, sender: selectedBadge)
        }
        return true
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddNewBadgeVC {
            destination.badgeCallback = { [weak self] badge in
                self?.viewModel.statuses?.append(badge)
                self?.collectionView?.reloadData()
            }
        }
        else if let destination = segue.destination as? DetailedBadgeInfoVC {
            guard let badge = sender as? Badge else { return }
            destination.setBadge(detailedBadge: badge)
        }
    }
}

extension ProfileBadgesCollectionVC: UICollectionViewDelegateRightAlignedLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return c.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return c.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return c.sectionInsets.right
    }
}

extension ProfileBadgesCollectionVC: ProfileBadgesCollectionVMProtocol {
    func reloadCells(indexes: [IndexPath]) {
        collectionView?.reloadItems(at: indexes)
    }
    
    func reloadCollectionView() {
        collectionView?.reloadData()
    }
}
