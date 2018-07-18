//
//  NewsFeedDetailedVC.swift
//  CmrUI
//
//  Created by Vasyl.Savka on 7/16/18.
//  Copyright © 2018 Vasyl.Savka. All rights reserved.
//

import UIKit

private let feedNewsTextCellColor = UIColor(red: 226.0/255.0, green: 229.0/255.0, blue: 232.0/255.0, alpha: 1.0)
private let backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
private let closeButtonColor = UIColor(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0)
private let closeButtonTextColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)

fileprivate struct NewsFeedCloseButtonPosition {
    static let kLeftOffset: CGFloat = 0.9
    static let kTopOffset: CGFloat = 0.042
    static let height: CGFloat = 30.0
    static let width: CGFloat = 30.0
}

class NewsFeedDetailedVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var feedItem: FeedItem?
    private var customInteractor : CustomInteractor?
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavigationRouter.shared.refreshNavigationBar(fromView: self.view)
        self.navigationController?.delegate = self
        addCloseButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (feedItem != nil) {
            titleLabel.text = feedItem?.title
            subtitleLabel.text = feedItem?.subtitle
            backgroundImageView.image = feedItem?.image ?? nil
            contentLabel.text = feedItem?.content
            heightConstraint.constant = feedItem?.image == nil ? 0 : 320
        }
        setupAppearance()
    }
    
    func setupAppearance() {
        
        view.backgroundColor = backgroundColor
        backgroundImageView.backgroundColor = feedNewsTextCellColor
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 20))
        label.font = UIFont(name: "Noteworthy-Bold", size: 25)
        label.text = "wristcam"
        self.navigationItem.titleView = label
    }
    func addCloseButton() {
        /*closeButton = UIButton(frame: CGRect(x: self.view.frame.size.width * NewsFeedCloseButtonPosition.kLeftOffset,
                                                      y: self.view.frame.size.width * NewsFeedCloseButtonPosition.kTopOffset,
                                                      width: NewsFeedCloseButtonPosition.width,
                                                      height: NewsFeedCloseButtonPosition.height))*/
        closeButton?.layer.cornerRadius = NewsFeedCloseButtonPosition.width / 2.0
        closeButton?.backgroundColor = closeButtonColor
        closeButton?.setTitleColor(closeButtonTextColor, for: .normal)
        let attributes = [NSAttributedStringKey.foregroundColor: closeButtonTextColor,
                          NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22.0, weight: UIFont.Weight.medium)]
        closeButton?.setAttributedTitle(NSAttributedString(string: "x",
                                                          attributes: attributes),
                                                          for: .normal)
        closeButton?.titleEdgeInsets = UIEdgeInsetsMake(0, 1.5, 5, 1)
        
        //closeButton?.addTarget(self, action: #selector(self.dismissVC()), for: .touchUpInside)
        //self.view.addSubview(closeButton!)
        //closeButton.translatesAutoresizingMaskIntoConstraints = true
    }

    @objc func buttonAction(_ sender:UIButton!)
    {        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        print("Button tapped")

    }
    
    @IBAction func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let ci = customInteractor else { return nil }
        return ci.transitionInProgress ? customInteractor : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let frame = self.view.frame
        let item  = feedItem
        var img: UIImage = UIImage()
        if item?.image != nil {
            img = (item?.image!)!
        }
        
        switch operation {
        case .push:
            self.customInteractor = CustomInteractor(attachTo: toVC)
            return ZoomTransition(duration: TimeInterval(UINavigationControllerHideShowBarDuration), isPresenting: true, originFrame: frame, image: img)
        default:
            return ZoomTransition(duration: TimeInterval(UINavigationControllerHideShowBarDuration), isPresenting: false, originFrame: frame, image: img)
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let frame = self.view.frame
        let item  = feedItem
        var img: UIImage = UIImage()
        if item?.image != nil {
            img = (item?.image!)!
        }
        
        return ZoomTransition(duration: TimeInterval(UINavigationControllerHideShowBarDuration), isPresenting: true, originFrame: frame, image: img)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
