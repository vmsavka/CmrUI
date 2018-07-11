//
//  CmrContainerVC.swift
//  CmrUI
//

import UIKit

class CmrContainerVC: UIViewController {
    
    private var tab: ContainerTab?
    private var currentVC: UIViewController?
    
    var alert: UIAlertController? // Will implement it later, maybe it will replaced by PXAlertView
    private lazy var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray) // Will move it to separate class later
    
    fileprivate var dataSource = [ContainerTab]()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = [.feedItem, .galleryItem, .itemsItem, .settingsItem, .cartItem]
        setupAppearance()
    }
    
    //MARK: - Helpers
    
    func setupAppearance(){
        //Will implement NavigationRouter later and remove follow code
        //Also custom NavigationBar or shared helper will be useful
        //Make navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //Hide line under NavigationBar
        
        if tab == nil {
            transition(to: .feedItem)
        }
        navigationItem.title = NSLocalizedString((tab?.tabTitle())!, comment: "")
        
        //It's a stub, don't pay attention for it
        //I'm going to create separate ViewController for Bar buttons
        let storyboard = UIStoryboard(name: "CmrTabBar", bundle: nil)
        let cmr: CmrTabBar? = storyboard.instantiateViewController(withIdentifier: "CmrTabBar") as? CmrTabBar
        let backgroundView = cmr?.drawBackgroundView()
        view.addSubview(backgroundView!)
        self.view.bringSubview(toFront: backgroundView!)
        
        //setupBarButtons()
        
    }
    
    func loadInitialView() {
        showActivityIndicator()
    }

    private func showActivityIndicator() {
        // Activity indicator setup and rendering
    }
    
    private func render(viewController: UIViewController, transitionType: CATransition) {
        // Shows arbitrary viewController from current
    }
    
    private func displayError(error: Error) {
        // Provides interface for error handling
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

// MARK: - Tranasitions

extension CmrContainerVC {
    func transition(to newTab: ContainerTab) {
        currentVC?.removeFromParentViewController()
        let vc = viewController(for: newTab)
        add(vc)
        currentVC = vc
        tab = newTab
    }
    
    func add(_ child: UIViewController) {
            addChildViewController(child)
            view.addSubview(child.view)
            child.didMove(toParentViewController: self)
        }
        
    func remove() {
            guard parent != nil else {
                return
            }
            
            willMove(toParentViewController: nil)
            removeFromParentViewController()
            view.removeFromSuperview()
    }
}

private extension CmrContainerVC {
    func viewController(for tab: ContainerTab) -> UIViewController {
        switch tab {
        case .feedItem:
            return UIViewController()
        case .galleryItem:
            return UIViewController()
        case .itemsItem:
            return UIViewController()
        case .settingsItem:
            return UIViewController()
        case .cartItem:
            return UIViewController()
        case .count:
            return UIViewController()
        }
    }
}

extension CmrContainerVC {
    enum ContainerTab: Int {
        typealias RawValue = Int
        
        case feedItem = 0
        case galleryItem = 1
        case itemsItem = 2
        case settingsItem = 3
        case cartItem = 4
        case count = 5
        
        func tabTitle() -> String {
            switch self {
            case .feedItem: return "Feed"
            case .galleryItem: return "Gallery"
            case .itemsItem: return "Items"
            case .settingsItem: return "Settings"
            case .cartItem: return "Cart"
            case .count: return ""
            }
        }
        
        func image() -> UIImage? {
            switch self {
            case .feedItem:
                return UIImage(named:"FeedTabBarIco")
            case .galleryItem:
                return UIImage(named:"GalleryTabBarIco")
            case .itemsItem:
                return UIImage(named:"ItemsTabBarIco")
            case .settingsItem:
                return UIImage(named:"SettingsTabBarIco")
            case .cartItem:
                return UIImage(named:"FeedTabBarIco")
            case .count:
                return nil
            }
        }
        
        static func countOfTabs() -> Int {
            return ContainerTab.count.rawValue
        }
    }
}

//Will move it later
/*
class ErrorViewController: UIViewController {
    var reloadHandler: () -> Void = {}
    
    func handle(_ error: Error) {
        let errorViewController = ErrorViewController()
        errorViewController.reloadHandler = { [weak self] in
            self?.doSomething()
        }
        add(errorViewController)
    }
}
 */
