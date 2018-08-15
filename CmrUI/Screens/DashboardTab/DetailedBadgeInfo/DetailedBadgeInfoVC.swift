//
//  DetailedBadgeInfoVC.swift
//  CmrUI
//

import UIKit

private struct Constants {
    static let backgroundColor = UIColor(red: 106.0/255.0, green: 106.0/255.0, blue: 106.0/255.0, alpha: 1.0)
}

class DetailedBadgeInfoVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    fileprivate typealias c = Constants
    
    lazy fileprivate var viewModel: DetailedBadgeInfoVM = {
        return DetailedBadgeInfoVM(delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadDetailedBadgeInfo()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = c.backgroundColor
        textView.backgroundColor = c.backgroundColor
    }
    
    func setBadge(detailedBadge: Badge) {
        viewModel.badge = detailedBadge
    }
}

extension DetailedBadgeInfoVC: DetailedBadgeInfoVMProtocol {
    func reloadPage() {
        imageView.image = viewModel.badge?.image()
        textView.text = "Detailed info about:\n\n" + (viewModel.badge?.title() ?? "") 
    }
}
