//
//  ProfileInfoCell.swift
//  CmrUI
//

import UIKit

protocol AddChildVCProtocol {
    func addChildVC(childController: UIViewController, containerView: UIView)
}

class ProfileInfoCell: UICollectionViewCell , ProfileCellView {
    
    //@IBOutlet weak var badgesCollectionView: UICollectionView!
    
    @IBOutlet weak var badgesContainerView: UIView!
    @IBOutlet weak var ellipsesView: EllipsesLogoView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var parentVC: AddChildVCProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }

    func setup() {
        //ProfilePropertiesCollectionVC
        let board = UIStoryboard.storyboardWith(name: .profile)
        let badgesVC = board.instantiateViewController(withIdentifier: "ProfileBadgesCollectionVC") as! ProfileBadgesCollectionVC
        badgesVC.view.frame = CGRect(x: 0, y: 0,
                                     width: badgesContainerView.frame.size.width - 10,
                                     height: badgesContainerView.frame.size.height)

        parentVC?.addChildVC(childController: badgesVC, containerView: badgesContainerView)
    }    
}

extension ProfileInfoCell {
    
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
