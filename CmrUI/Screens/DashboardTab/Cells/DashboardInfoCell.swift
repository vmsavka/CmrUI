//
//  DashboardInfoCell.swift
//  CmrUI
//

import UIKit

protocol AddChildVCProtocol {
    func addChildVC(childController: UIViewController, containerView: UIView)
}

class DashboardInfoCell: UICollectionViewCell , DashboardCellView {
    
    //@IBOutlet weak var badgesCollectionView: UICollectionView!
    
    @IBOutlet weak var badgesContainerView: UIView!
    @IBOutlet weak var ellipsesView: EllipsesLogoView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var parentVC: AddChildVCProtocol?
    var badgesAdded: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if badgesAdded == false {
            setup()
        }
    }

    func setup() {
        //DashboardPropertiesCollectionVC
        let board = UIStoryboard.storyboardWith(name: .dashboard)
        let badgesVC = board.instantiateViewController(withIdentifier: "DashboardBadgesCollectionVC") as! DashboardBadgesCollectionVC
        badgesVC.view.frame = CGRect(x: 0, y: 0,
                                     width: badgesContainerView.frame.size.width - 10,
                                     height: badgesContainerView.frame.size.height)
        badgesAdded = true
        parentVC?.addChildVC(childController: badgesVC, containerView: badgesContainerView)
    }    
}

extension DashboardInfoCell {
    
    func display(title: String) {
        statusLabel.text = title
    }
    
    func display(name: String) {
        nameLabel.text = name
    }
    
    func display(description: String) {
        descriptionLabel.text = description
    }
    
    func display(image: UIImage) {
        ellipsesView.image = image
    }
    
    func display(date: Date) {
        
    }
    
    func setBackground(color: UIColor) {
        self.backgroundColor = color
    }
}
